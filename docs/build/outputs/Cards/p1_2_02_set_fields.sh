#!/usr/bin/env bash
set -euo pipefail

# ===============================
# CONFIG YOU MUST SET (EDIT THIS)
# ===============================

OWNER_LOGIN="lillycore-boss"                  # same as script 01
OWNER_TYPE="user"                            # "user" or "org"
REPO_NAME="lillycore"                        # e.g., "lillycore"
PROJECT_NUMBER="6"                           # numeric project number from the URL (e.g., 6)
WORKDIR="/tmp/lillycore_cards/p1"            # must match script 01
MANIFEST_NAME="manifest.tsv"                 # must match script 01

# Values you’ll set across cards (edit per phase)
PHASE_ID="p1"                                # e.g., "p1"
PARENT_ID_DEFAULT="P1.2"                      # Project field value, not issue relationship
ATTEMPT_NUMBER="1"

# Issue-level metadata (repo issue properties)
MILESTONE_NAME="Phase 1 — Core Loop, Logging, User Preferences"   # exact milestone title as shown in GitHub UI
PARENT_ISSUE_NUMBER_DEFAULT="54"              # actual GitHub issue number for parent (P1.2)

# ===============================
# CORE (DO NOT EDIT)
# ===============================

fail(){ echo "ERROR: $*" >&2; exit 1; }
warn(){ echo "WARN:  $*" >&2; }

command -v gh >/dev/null 2>&1 || fail "gh CLI not found"
command -v jq >/dev/null 2>&1 || fail "jq not found"

[[ "$OWNER_LOGIN" != "<OWNER_LOGIN>" ]] || true
[[ "$REPO_NAME" != "<REPO_NAME>" ]] || true
[[ "$PROJECT_NUMBER" != "<PROJECT_NUMBER>" ]] || true
[[ "$PHASE_ID" != "<phase_id>" ]] || true
[[ "$MILESTONE_NAME" != "<milestone_full_name>" ]] || true
[[ "$PARENT_ISSUE_NUMBER_DEFAULT" != "<parent_issue_number>" ]] || true

REPO="${OWNER_LOGIN}/${REPO_NAME}"

MANIFEST="${WORKDIR}/${MANIFEST_NAME}"
[[ -f "$MANIFEST" ]] || fail "Manifest not found: $MANIFEST (run script 01 first)"

# ProjectV2 id lookup (user vs org)
get_project_v2_id() {
  if [[ "$OWNER_TYPE" == "org" ]]; then
    gh api graphql -f query="query { organization(login: \"${OWNER_LOGIN}\") { projectV2(number: ${PROJECT_NUMBER}) { id } } }" \
      --jq '.data.organization.projectV2.id'
  else
    gh api graphql -f query="query { user(login: \"${OWNER_LOGIN}\") { projectV2(number: ${PROJECT_NUMBER}) { id } } }" \
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
    if [[ "$cursor" == "null" ]]; then
      resp=$(gh api graphql -F projectId="$PROJECT_V2_ID" -f query='
query($projectId:ID!) {
  node(id:$projectId) {
    ... on ProjectV2 {
      items(first:100) {
        pageInfo { hasNextPage endCursor }
        nodes { id content { ... on Issue { number } } }
      }
    }
  }
}')
    else
      resp=$(gh api graphql -F projectId="$PROJECT_V2_ID" -F cursor="$cursor" -f query='
query($projectId:ID!, $cursor:String!) {
  node(id:$projectId) {
    ... on ProjectV2 {
      items(first:100, after:$cursor) {
        pageInfo { hasNextPage endCursor }
        nodes { id content { ... on Issue { number } } }
      }
    }
  }
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

    [[ "$has_next" == "true" ]] || break
  done

  return 1
}

# Typed field setting
set_text_field() {
  local item_id="$1"; local field_id="$2"; local value="$3"
  gh project item-edit --id "$item_id" --project-id "$PROJECT_V2_ID" --field-id "$field_id" --text "$value" >/dev/null
}

set_number_field() {
  local item_id="$1"; local field_id="$2"; local value="$3"
  gh project item-edit --id "$item_id" --project-id "$PROJECT_V2_ID" --field-id "$field_id" --number "$value" >/dev/null
}

# -------------------------------
# Issue-level metadata setters
# -------------------------------

set_issue_milestone() {
  local issue_number="$1"
  if ! gh issue edit "$issue_number" --repo "$REPO" --milestone "$MILESTONE_NAME" >/dev/null 2>&1; then
    warn "Could not set milestone '$MILESTONE_NAME' on ${REPO}#$issue_number (milestone missing or permissions?)"
  fi
}

get_issue_node_ids() {
  local parent_num="$1"
  local child_num="$2"
  gh api graphql -f query='
query($owner:String!, $repo:String!, $parent:Int!, $child:Int!) {
  repository(owner:$owner, name:$repo) {
    parent: issue(number:$parent) { id }
    child:  issue(number:$child)  { id }
  }
}' -F owner="$OWNER_LOGIN" -F repo="$REPO_NAME" -F parent="$parent_num" -F child="$child_num"
}

link_parent_relationship() {
  local parent_num="$1"
  local child_num="$2"

  local ids parent_id child_id
  if ! ids="$(get_issue_node_ids "$parent_num" "$child_num" 2>/dev/null)"; then
    warn "Could not resolve node IDs for parent=${REPO}#$parent_num child=${REPO}#$child_num"
    return 0
  fi

  parent_id="$(echo "$ids" | jq -r '.data.repository.parent.id')"
  child_id="$(echo "$ids" | jq -r '.data.repository.child.id')"

  if [[ -z "$parent_id" || "$parent_id" == "null" || -z "$child_id" || "$child_id" == "null" ]]; then
    warn "Node IDs missing for parent=${REPO}#$parent_num child=${REPO}#$child_num"
    return 0
  fi

  # Link child as sub-issue of parent (fills Relationships → Parent issue)
  if ! gh api graphql -f query='
mutation($issueId:ID!, $subIssueId:ID!) {
  addSubIssue(input:{issueId:$issueId, subIssueId:$subIssueId}) {
    clientMutationId
  }
}' -F issueId="$parent_id" -F subIssueId="$child_id" >/dev/null 2>&1; then
    warn "Could not link parent relationship for ${REPO}#$child_num -> parent ${REPO}#$parent_num (feature or perms?)"
  fi
}

# ===============================
# PER-CARD FIELD MAP (EDIT THIS)
# ===============================

apply_fields_for_card() {
  local card_id="$1"; local issue_number="$2"; local full_title="$3"

  # Defaults
  local parent_id="$PARENT_ID_DEFAULT"
  local role="architect"
  local delivers=""
  local parent_issue_number="$PARENT_ISSUE_NUMBER_DEFAULT"

  case "$card_id" in
    P1.2.1) role="architect"; delivers="P1.D3" ;;
    P1.2.2) role="architect"; delivers="P1.D2,P1.D3" ;;
    P1.2.3) role="architect"; delivers="P1.D2,P1.D3" ;;
    P1.2.4) role="architect"; delivers="P1.D2" ;;
    P1.2.QA) role="qa"; delivers="P1.D2,P1.D3" ;;
    *) warn "No mapping for card_id=$card_id; skipping"; return 0 ;;
  esac

  # Resolve item id (may lag)
  local item_id
  item_id="$(get_item_id_for_issue "$issue_number" || true)"
  if [[ -z "$item_id" || "$item_id" == "null" ]]; then
    warn "Project item not found yet for $card_id (#$issue_number). Rerun in 30–90s."
    return 0
  fi

  # Apply Project fields
  set_text_field "$item_id" "$FIELD_CARD_ID" "$card_id"
  set_text_field "$item_id" "$FIELD_PHASE_ID" "$PHASE_ID"
  set_text_field "$item_id" "$FIELD_PARENT_ID" "$parent_id"
  set_text_field "$item_id" "$FIELD_EXECUTOR_ROLE" "$role"
  set_text_field "$item_id" "$FIELD_DELIVERABLES" "$delivers"
  set_number_field "$item_id" "$FIELD_ATTEMPT" "$ATTEMPT_NUMBER"

  # Apply issue metadata
  set_issue_milestone "$issue_number"
  link_parent_relationship "$parent_issue_number" "$issue_number"

  echo "FIELDS+META SET: $card_id (#$issue_number)"
}

# ===============================
# RUN (DO NOT EDIT)
# ===============================

while IFS=$'\t' read -r card_id issue_number full_title; do
  apply_fields_for_card "$card_id" "$issue_number" "$full_title"
done < "$MANIFEST"

# Optional:
# python3 docs/build/registry/registry_sync_from_github.py
# python3 docs/build/registry/registry_validate.py

