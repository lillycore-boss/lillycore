# ==============================
# FILE: p1_02_set_fields.sh
# ==============================
#!/usr/bin/env bash
set -euo pipefail

OWNER="lillycore-boss"
MAIN_PROJECT_NUMBER="6"   # numeric project number
PHASE_ID="p1"
ATTEMPT_NUMBER="1"
WORKDIR="/tmp/lillycore_cards/p1"
MANIFEST="${WORKDIR}/p1_manifest.tsv"

fail(){ echo "ERROR: $*" >&2; exit 1; }
command -v gh >/dev/null 2>&1 || fail "gh CLI not found"
command -v jq >/dev/null 2>&1 || fail "jq not found"
[[ -f "$MANIFEST" ]] || fail "Manifest not found: $MANIFEST (run p1_01_create_issues.sh first)"

# ProjectV2 id (user only)
PROJECT_V2_ID=$(gh api graphql -f query="query { user(login: \"${OWNER}\") { projectV2(number: ${MAIN_PROJECT_NUMBER}) { id } } }" --jq '.data.user.projectV2.id')
[[ -n "$PROJECT_V2_ID" && "$PROJECT_V2_ID" != "null" ]] || fail "Could not resolve ProjectV2 ID"

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
  echo "$FIELDS_JSON" | jq -r --arg n "$name" '
    .data.node.fields.nodes[]
    | select(.name == $n)
    | .id' | head -n 1
}

FIELD_CARD_ID="$(field_id_by_name "Card ID")"
FIELD_PHASE_ID="$(field_id_by_name "Phase ID")"
FIELD_PARENT_ID="$(field_id_by_name "Parent ID")"
FIELD_EXECUTOR_ROLE="$(field_id_by_name "Executor Role")"
FIELD_DELIVERABLES="$(field_id_by_name "Deliverables")"
FIELD_ATTEMPT="$(field_id_by_name "Attempt #")"

# sanity
[[ -n "$FIELD_CARD_ID" && "$FIELD_CARD_ID" != "null" ]] || fail "Could not find field id for 'Card ID'"


# Page through items until we find the issue number
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
    if [[ "$has_next" != "true" ]]; then
      break
    fi
  done
  return 1
}

set_fields() {
  local card_id="$1"; shift
  local issue_number="$1"; shift
  local parent_id="$1"; shift
  local role="$1"; shift
  local delivers="$1"; shift

  local item_id
  item_id="$(get_item_id_for_issue "$issue_number" || true)"
  if [[ -z "$item_id" || "$item_id" == "null" ]]; then
    echo "WARN: item id not found yet for $card_id (#$issue_number). Try rerun in 30s." >&2
    return 0
  fi
  # Text fields
  gh project item-edit --id "$item_id" --project-id "$PROJECT_V2_ID" --field-id "$FIELD_CARD_ID" --text "$card_id"
  gh project item-edit --id "$item_id" --project-id "$PROJECT_V2_ID" --field-id "$FIELD_PHASE_ID" --text "$PHASE_ID"
  gh project item-edit --id "$item_id" --project-id "$PROJECT_V2_ID" --field-id "$FIELD_PARENT_ID" --text "$parent_id"
  gh project item-edit --id "$item_id" --project-id "$PROJECT_V2_ID" --field-id "$FIELD_EXECUTOR_ROLE" --text "$role"
  gh project item-edit --id "$item_id" --project-id "$PROJECT_V2_ID" --field-id "$FIELD_DELIVERABLES" --text "$delivers"

  # Number field
  gh project item-edit --id "$item_id" --project-id "$PROJECT_V2_ID" --field-id "$FIELD_ATTEMPT" --number "$ATTEMPT_NUMBER"


  echo "FIELDS SET: $card_id (#$issue_number) -> item $item_id"
}

# Card metadata (authoritative for field-setting)
# card_id  parent  role        deliverables
# NOTE: Parent ID for all frontier cards is "P1" per your board model.
while IFS=$'\t' read -r card_id issue_number full_title; do
  case "$card_id" in
    P1.1) set_fields "$card_id" "$issue_number" "P1" "architect" "P1.D1,P1.D3" ;;
    P1.2) set_fields "$card_id" "$issue_number" "P1" "architect" "P1.D2,P1.D3" ;;
    P1.3) set_fields "$card_id" "$issue_number" "P1" "architect" "P1.D4" ;;
    P1.4) set_fields "$card_id" "$issue_number" "P1" "architect" "P1.D5" ;;
    P1.5) set_fields "$card_id" "$issue_number" "P1" "architect" "P1.D6" ;;
    P1.QA) set_fields "$card_id" "$issue_number" "P1" "qa" "P1.D1,P1.D2,P1.D3,P1.D4,P1.D5,P1.D6" ;;
    *) echo "WARN: unknown card_id in manifest: $card_id" >&2 ;;
  esac

done < "$MANIFEST"

# Registry sync/validate can be run after fields are set.
# python3 docs/build/registry/registry_sync_from_github.py
# python3 docs/build/registry/registry_validate.py

