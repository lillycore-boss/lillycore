#!/usr/bin/env bash
set -euo pipefail

# ===============================

# CONFIG YOU MUST SET (EDIT THIS)

# ===============================

OWNER_LOGIN="<OWNER_LOGIN>"                  # same as script 01
OWNER_TYPE="user"                            # "user" or "org"
PROJECT_NUMBER="<PROJECT_NUMBER>"            # numeric project number from the URL (e.g., 6)
WORKDIR="/tmp/lillycore_cards/<phase_id>"    # must match script 01
MANIFEST_NAME="manifest.tsv"                 # must match script 01

# These are the values you’ll set across cards (edit per phase)

PHASE_ID="<phase_id>"                        # e.g., "p1"
PARENT_ID_DEFAULT="<parent_id>"              # e.g., "P1"
ATTEMPT_NUMBER="1"

# ===============================

# CORE (DO NOT EDIT)

# ===============================

fail(){ echo "ERROR: $*" >&2; exit 1; }
command -v gh >/dev/null 2>&1 || fail "gh CLI not found"
command -v jq >/dev/null 2>&1 || fail "jq not found"

MANIFEST="${WORKDIR}/${MANIFEST_NAME}"
[[ -f "$MANIFEST" ]] || fail "Manifest not found: $MANIFEST (run script 01 first)"

# ProjectV2 id lookup (user vs org)

get_project_v2_id() {
if [[ "$OWNER_TYPE" == "org" ]]; then
gh api graphql -f query="query { organization(login: "${OWNER_LOGIN}") { projectV2(number: ${PROJECT_NUMBER}) { id } } }" 
--jq '.data.organization.projectV2.id'
else
gh api graphql -f query="query { user(login: "${OWNER_LOGIN}") { projectV2(number: ${PROJECT_NUMBER}) { id } } }" 
--jq '.data.user.projectV2.id'
fi
}

PROJECT_V2_ID="$(get_project_v2_id)"
[[ -n "$PROJECT_V2_ID" && "$PROJECT_V2_ID" != "null" ]] || fail "Could not resolve ProjectV2 ID (check OWNER_LOGIN/TYPE and PROJECT_NUMBER)"

# Load all project fields once (we need IDs, not names)

FIELDS_JSON=$(gh api graphql -F projectId="$PROJECT_V2_ID" -f query='
query($projectId:ID!) {
node(id:$projectId) {
... on ProjectV2 {
fields(first:100) {
nodes {
__typename
... on ProjectV2FieldCommon { id name dataType }
... on ProjectV2SingleSelectField { id name dataType }
}
}
}
}
}')

field_id_by_name() {
local name="$1"
echo "$FIELDS_JSON" | jq -r --arg n "$name" '.data.node.fields.nodes[] | select(.name == $n) | .id' | head -n 1
}

# EDIT ONLY IF YOUR FIELD NAMES DIFFER

FIELD_CARD_ID="$(field_id_by_name "Card ID")"
FIELD_PHASE_ID="$(field_id_by_name "Phase ID")"
FIELD_PARENT_ID="$(field_id_by_name "Parent ID")"
FIELD_EXECUTOR_ROLE="$(field_id_by_name "Executor Role")"
FIELD_DELIVERABLES="$(field_id_by_name "Deliverables")"
FIELD_ATTEMPT="$(field_id_by_name "Attempt #")"

[[ -n "$FIELD_CARD_ID" && "$FIELD_CARD_ID" != "null" ]] || fail "Missing field: Card ID"
[[ -n "$FIELD_PHASE_ID" && "$FIELD_PHASE_ID" != "null" ]] || fail "Missing field: Phase ID"
[[ -n "$FIELD_PARENT_ID" && "$FIELD_PARENT_ID" != "null" ]] || fail "Missing field: Parent ID"
[[ -n "$FIELD_EXECUTOR_ROLE" && "$FIELD_EXECUTOR_ROLE" != "null" ]] || fail "Missing field: Executor Role"
[[ -n "$FIELD_DELIVERABLES" && "$FIELD_DELIVERABLES" != "null" ]] || fail "Missing field: Deliverables"
[[ -n "$FIELD_ATTEMPT" && "$FIELD_ATTEMPT" != "null" ]] || fail "Missing field: Attempt #"

# Project item id lookup by issue number (paged)

get_item_id_for_issue() {
local issue_number="$1"
local cursor="null"

for _ in $(seq 1 25); do
local resp

```
if [[ "$cursor" == "null" ]]; then
  resp=$(gh api graphql -F projectId="$PROJECT_V2_ID" -f query='\
    query($projectId:ID!) {\
      node(id:$projectId) {\
        ... on ProjectV2 {\
          items(first:100) {\
            pageInfo { hasNextPage endCursor }\
            nodes { id content { ... on Issue { number } } }\
          }\
        }\
      }\
    }')
else
  resp=$(gh api graphql -F projectId="$PROJECT_V2_ID" -F cursor="$cursor" -f query='\
    query($projectId:ID!, $cursor:String!) {\
      node(id:$projectId) {\
        ... on ProjectV2 {\
          items(first:100, after:$cursor) {\
            pageInfo { hasNextPage endCursor }\
            nodes { id content { ... on Issue { number } } }\
          }\
        }\
      }\
    }')
fi

local found
found=$(echo "$resp" | jq -r ".data.node.items.nodes[] | select(.content.number == ${issue_number}) | .id" | head -n 1)
if [[ -n "$found" && "$found" != "null" ]]; then
  echo "$found"
  return 0
fi

local has_next
has_next=$(echo "$resp" | jq -r '.data.node.items.pageInfo.hasNextPage')
cursor=$(echo "$resp" | jq -r '.data.node.items.pageInfo.endCursor')

if [[ "$has_next" != "true" ]]; then
  break
fi
```

done

return 1
}

# Typed field setting (your gh requires field-id + typed value)

set_text_field() {
local item_id="$1"; local field_id="$2"; local value="$3"
gh project item-edit --id "$item_id" --project-id "$PROJECT_V2_ID" --field-id "$field_id" --text "$value" >/dev/null
}

set_number_field() {
local item_id="$1"; local field_id="$2"; local value="$3"
gh project item-edit --id "$item_id" --project-id "$PROJECT_V2_ID" --field-id "$field_id" --number "$value" >/dev/null
}

# ===============================

# PER-CARD FIELD MAP (EDIT THIS)

# ===============================

# This is the only “logic” you edit: roles/deliverables/parent overrides.

# Everything else should stay stable.

apply_fields_for_card() {
local card_id="$1"; local issue_number="$2"; local full_title="$3"

# Defaults

local parent_id="$PARENT_ID_DEFAULT"
local role="implementer"
local delivers=""

case "$card_id" in
P1) parent_id="none"; role="architect"; delivers="P1.D1,P1.D2,P1.D3,P1.D4,P1.D5,P1.D6" ;;
P1.1) role="architect"; delivers="P1.D1,P1.D3" ;;
P1.2) role="architect"; delivers="P1.D2,P1.D3" ;;
P1.3) role="architect"; delivers="P1.D4" ;;
P1.4) role="architect"; delivers="P1.D5" ;;
P1.5) role="architect"; delivers="P1.D6" ;;
P1.QA) role="qa"; delivers="P1.D1,P1.D2,P1.D3,P1.D4,P1.D5,P1.D6" ;;
*) echo "WARN: No mapping for card_id=$card_id; skipping" >&2; return 0 ;;
esac

# Resolve item id (may lag). If not found, warn and continue.

local item_id
item_id="$(get_item_id_for_issue "$issue_number" || true)"
if [[ -z "$item_id" || "$item_id" == "null" ]]; then
echo "WARN: Project item not found yet for $card_id (#$issue_number). Rerun this script in 30–90s." >&2
return 0
fi

# Apply fields

set_text_field "$item_id" "$FIELD_CARD_ID" "$card_id"
set_text_field "$item_id" "$FIELD_PHASE_ID" "$PHASE_ID"
set_text_field "$item_id" "$FIELD_PARENT_ID" "$parent_id"
set_text_field "$item_id" "$FIELD_EXECUTOR_ROLE" "$role"
set_text_field "$item_id" "$FIELD_DELIVERABLES" "$delivers"
set_number_field "$item_id" "$FIELD_ATTEMPT" "$ATTEMPT_NUMBER"

echo "FIELDS SET: $card_id (#$issue_number)"
}

# ===============================

# RUN (DO NOT EDIT)

# ===============================

while IFS=$'\t' read -r card_id issue_number full_title; do
apply_fields_for_card "$card_id" "$issue_number" "$full_title"
done < "$MANIFEST"

# Optional (uncomment if you want registry sync after field-set)

# python3 docs/build/registry/registry_sync_from_github.py

# python3 docs/build/registry/registry_validate.py

