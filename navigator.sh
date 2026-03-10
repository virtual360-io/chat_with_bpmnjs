#!/usr/bin/env bash
set -euo pipefail

readonly FILE="${1:?Usage: navigator.sh <file.bpmn> <command> [args...]}"
readonly CMD="${2:-help}"
shift 2 2>/dev/null || true

if [ ! -f "$FILE" ]; then
  echo "Error: file not found: $FILE" >&2
  exit 1
fi

CACHE_DIR=$(mktemp -d)
trap 'rm -rf "$CACHE_DIR"' EXIT

NODES="$CACHE_DIR/nodes"   # type|id|name
EDGES="$CACHE_DIR/edges"   # label|source|target
ANNOTS="$CACHE_DIR/annots" # node_id|text

# ---------------------------------------------------------------------------
# Parse
# ---------------------------------------------------------------------------

parse_bpmn() {
  awk '/<(userTask|serviceTask|scriptTask|startEvent|endEvent|intermediateThrowEvent|dataStoreReference|exclusiveGateway|parallelGateway|inclusiveGateway|eventBasedGateway) / {
    type = $0; sub(/.*</, "", type); sub(/ .*/, "", type)
    id = $0;   sub(/.*id="/, "", id);   sub(/".*/, "", id)
    if ($0 ~ /name="/) { name = $0; sub(/.*name="/, "", name); sub(/".*/, "", name) }
    else               { name = "(unnamed)" }
    print type "|" id "|" name
  }' "$FILE" > "$NODES"

  awk '/<sequenceFlow / {
    if ($0 ~ /name="/) { lbl = $0; sub(/.*name="/, "", lbl); sub(/".*/, "", lbl) }
    else               { lbl = "" }
    src = $0; sub(/.*sourceRef="/, "", src); sub(/".*/, "", src)
    tgt = $0; sub(/.*targetRef="/, "", tgt); sub(/".*/, "", tgt)
    print lbl "|" src "|" tgt
  }' "$FILE" > "$EDGES"

  awk -F'|' '{print $2; print $3}' "$EDGES" | sort -u > "$CACHE_DIR/edge_ids"
  awk -F'|' '{print $2}' "$NODES" | sort -u > "$CACHE_DIR/node_ids"
  comm -23 "$CACHE_DIR/edge_ids" "$CACHE_DIR/node_ids" | while IFS= read -r missing_id; do
    [ -z "$missing_id" ] && continue
    echo "unknown|${missing_id}|(unnamed)" >> "$NODES"
  done

  awk '
    /<textAnnotation / {
      ann_id = $0; sub(/.*id="/, "", ann_id); sub(/".*/, "", ann_id); in_ann = 1
    }
    in_ann && /<text>/ {
      txt = $0; sub(/.*<text>/, "", txt); sub(/<\/text>.*/, "", txt)
      anns[ann_id] = txt; in_ann = 0
    }
    /<association / {
      src = $0; sub(/.*sourceRef="/, "", src); sub(/".*/, "", src)
      tgt = $0; sub(/.*targetRef="/, "", tgt); sub(/".*/, "", tgt)
      if (tgt in anns) print src "|" anns[tgt]
      else if (src in anns) print tgt "|" anns[src]
    }
  ' "$FILE" > "$ANNOTS"
}

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

node_name() { awk -F'|' -v id="$1" '$2==id{print $3;exit}' "$NODES"; }
node_type() { awk -F'|' -v id="$1" '$2==id{print $1;exit}' "$NODES"; }

resolve_id() {
  local q="$1"
  if awk -F'|' -v id="$q" '$2==id{found=1;exit}END{exit !found}' "$NODES" 2>/dev/null; then
    echo "$q"
    return
  fi
  awk -F'|' -v q="$q" 'BEGIN{ql=tolower(q)} tolower($3)~ql{print $2}' "$NODES"
}

get_next() {
  local nid="$1" dir="$2"
  case "$dir" in
    out) awk -F'|' -v n="$nid" '$2==n{print $1 "|" $3}' "$EDGES" ;;
    in)  awk -F'|' -v n="$nid" '$3==n{print $1 "|" $2}' "$EDGES" ;;
  esac
}

# ---------------------------------------------------------------------------
# Commands
# ---------------------------------------------------------------------------

cmd_help() {
  cat <<'EOF'
BPMN Navigator (shell)

Usage: navigator.sh <file.bpmn> <command> [args...]

Commands:
  summary                  Overview (counts, starts, ends)
  nodes [TYPE]             List nodes, optionally by type
  search QUERY             Case-insensitive name search
  node QUERY               Node details (connections, annotations)
  neighbors QUERY [N] [in] BFS from node, N levels (default 2), direction out|in
  path FROM TO             Shortest path between two nodes

Node types: userTask serviceTask scriptTask startEvent endEvent intermediateThrowEvent
EOF
}

cmd_summary() {
  echo "=== BPMN Summary ==="
  echo "File: $(basename "$FILE")"
  echo "Nodes: $(wc -l < "$NODES" | tr -d ' ')  Edges: $(wc -l < "$EDGES" | tr -d ' ')  Annotations: $(wc -l < "$ANNOTS" | tr -d ' ')"
  echo ""
  echo "--- By type ---"
  awk -F'|' '{c[$1]++} END{for(t in c) printf "  %-28s %d\n",t,c[t]}' "$NODES" | sort -t' ' -k2 -rn
  echo ""
  echo "--- Start events ---"
  awk -F'|' '$1=="startEvent"{printf "  %s  (%s)\n",$3,$2}' "$NODES"
  echo ""
  echo "--- End events ---"
  awk -F'|' '$1=="endEvent"{printf "  %s  (%s)\n",$3,$2}' "$NODES"
}

cmd_nodes() {
  local filter="${1:-}"
  if [ -n "$filter" ]; then
    awk -F'|' -v t="$filter" '$1==t{printf "%-28s %-28s %s\n",$1,$2,$3}' "$NODES"
  else
    awk -F'|' '{printf "%-28s %-28s %s\n",$1,$2,$3}' "$NODES"
  fi
}

cmd_search() {
  local q="${1:?Usage: search QUERY}"
  awk -F'|' -v q="$q" 'BEGIN{ql=tolower(q)} tolower($3)~ql{printf "[%s] %s  (%s)\n",$1,$3,$2}' "$NODES"
  local edge_hits
  edge_hits=$(awk -F'|' -v q="$q" 'BEGIN{ql=tolower(q)} tolower($1)~ql{print $0}' "$EDGES")
  if [ -n "$edge_hits" ]; then
    echo ""
    echo "--- Matching edges ---"
    echo "$edge_hits" | while IFS='|' read -r lbl src tgt; do
      printf "  [%s] %s -> %s\n" "$lbl" "$(node_name "$src")" "$(node_name "$tgt")"
    done
  fi
}

cmd_node() {
  local q="${1:?Usage: node QUERY}"
  local ids
  ids=$(resolve_id "$q")
  if [ -z "$ids" ]; then
    echo "Not found: $q" >&2
    return 1
  fi

  echo "$ids" | while IFS= read -r id; do
    echo "=== $(node_name "$id") ==="
    echo "Type: $(node_type "$id")"
    echo "ID:   $id"

    local inc
    inc=$(awk -F'|' -v t="$id" '$3==t' "$EDGES")
    if [ -n "$inc" ]; then
      echo ""
      echo "Incoming:"
      echo "$inc" | while IFS='|' read -r lbl src _; do
        printf "  <- [%s]  %s (%s)\n" "$lbl" "$(node_name "$src")" "$src"
      done
    fi

    local out
    out=$(awk -F'|' -v s="$id" '$2==s' "$EDGES")
    if [ -n "$out" ]; then
      echo ""
      echo "Outgoing:"
      echo "$out" | while IFS='|' read -r lbl _ tgt; do
        printf "  -> [%s]  %s (%s)\n" "$lbl" "$(node_name "$tgt")" "$tgt"
      done
    fi

    local ann
    ann=$(awk -F'|' -v n="$id" '$1==n{print $2}' "$ANNOTS")
    if [ -n "$ann" ]; then
      echo ""
      echo "Annotations:"
      echo "$ann" | while IFS= read -r txt; do echo "  * $txt"; done
    fi
    echo ""
  done
}

cmd_neighbors() {
  local q="${1:?Usage: neighbors QUERY [DEPTH] [in|out]}"
  local max_depth="${2:-2}"
  local dir="${3:-out}"
  local start_id
  start_id=$(resolve_id "$q" | head -1)
  if [ -z "$start_id" ]; then
    echo "Not found: $q" >&2
    return 1
  fi

  echo "$start_id" > "$CACHE_DIR/bfs_q"
  : > "$CACHE_DIR/bfs_v"

  local depth=0
  while [ "$depth" -lt "$max_depth" ] && [ -s "$CACHE_DIR/bfs_q" ]; do
    : > "$CACHE_DIR/bfs_nq"

    while IFS= read -r nid; do
      grep -qxF "$nid" "$CACHE_DIR/bfs_v" 2>/dev/null && continue
      echo "$nid" >> "$CACHE_DIR/bfs_v"

      local pad
      pad=$(printf '%*s' $((depth * 2)) '')
      echo "${pad}[$(node_type "$nid")] $(node_name "$nid")  ($nid)"

      get_next "$nid" "$dir" | while IFS='|' read -r lbl next; do
        local arrow; [ "$dir" = "in" ] && arrow="<-" || arrow="->"
        echo "${pad}  ${arrow} [${lbl}]  $(node_name "$next")"
        echo "$next" >> "$CACHE_DIR/bfs_nq"
      done
    done < "$CACHE_DIR/bfs_q"

    if [ -s "$CACHE_DIR/bfs_nq" ]; then
      sort -u "$CACHE_DIR/bfs_nq" > "$CACHE_DIR/bfs_q"
    else
      : > "$CACHE_DIR/bfs_q"
    fi
    depth=$((depth + 1))
  done
}

cmd_path() {
  local from_q="${1:?Usage: path FROM TO}"
  local to_q="${2:?Usage: path FROM TO}"
  local from_id to_id
  from_id=$(resolve_id "$from_q" | head -1)
  to_id=$(resolve_id "$to_q" | head -1)
  if [ -z "$from_id" ] || [ -z "$to_id" ]; then
    echo "Could not resolve: from=$from_q to=$to_q" >&2
    return 1
  fi

  echo "Path: $(node_name "$from_id") -> $(node_name "$to_id")"
  echo ""

  echo "$from_id" > "$CACHE_DIR/pq"
  : > "$CACHE_DIR/pv"
  echo "${from_id}|_START_|_NONE_" > "$CACHE_DIR/pp"

  local found=0 depth=0 max=25
  while [ "$depth" -lt "$max" ] && [ -s "$CACHE_DIR/pq" ]; do
    : > "$CACHE_DIR/pnq"

    while IFS= read -r nid; do
      grep -qxF "$nid" "$CACHE_DIR/pv" 2>/dev/null && continue
      echo "$nid" >> "$CACHE_DIR/pv"

      if [ "$nid" = "$to_id" ]; then
        found=1
        break 2
      fi

      awk -F'|' -v s="$nid" '$2==s{print $1 "|" $3}' "$EDGES" | while IFS='|' read -r lbl tgt; do
        if ! grep -qxF "$tgt" "$CACHE_DIR/pv" 2>/dev/null; then
          echo "$tgt" >> "$CACHE_DIR/pnq"
          if ! grep -q "^${tgt}|" "$CACHE_DIR/pp" 2>/dev/null; then
            echo "${tgt}|${nid}|${lbl}" >> "$CACHE_DIR/pp"
          fi
        fi
      done
    done < "$CACHE_DIR/pq"

    if [ -s "$CACHE_DIR/pnq" ]; then
      sort -u "$CACHE_DIR/pnq" > "$CACHE_DIR/pq"
    else
      : > "$CACHE_DIR/pq"
    fi
    depth=$((depth + 1))
  done

  if [ "$found" -eq 0 ]; then
    echo "No path found (max depth $max)"
    return 1
  fi

  local cur="$to_id"
  : > "$CACHE_DIR/pr"
  while [ "$cur" != "_START_" ] && [ -n "$cur" ]; do
    local pline parent elbl
    pline=$(grep "^${cur}|" "$CACHE_DIR/pp" | head -1)
    parent=$(echo "$pline" | cut -d'|' -f2)
    elbl=$(echo "$pline" | cut -d'|' -f3)
    echo "${cur}|${elbl}" >> "$CACHE_DIR/pr"
    cur="$parent"
  done

  awk '{a[NR]=$0} END{for(i=NR;i>=1;i--)print a[i]}' "$CACHE_DIR/pr" > "$CACHE_DIR/pf"

  local step=0
  while IFS='|' read -r nid elbl; do
    local name type
    name=$(node_name "$nid")
    type=$(node_type "$nid")
    if [ "$step" -eq 0 ]; then
      printf "  (%d) [%s] %s\n" "$step" "$type" "$name"
    else
      printf "       | [%s]\n" "$elbl"
      printf "       v\n"
      printf "  (%d) [%s] %s\n" "$step" "$type" "$name"
    fi
    step=$((step + 1))
  done < "$CACHE_DIR/pf"

  echo ""
  echo "Steps: $((step - 1))"
}

# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------

parse_bpmn

case "$CMD" in
  summary)   cmd_summary ;;
  nodes)     cmd_nodes "$@" ;;
  search)    cmd_search "$@" ;;
  node)      cmd_node "$@" ;;
  neighbors) cmd_neighbors "$@" ;;
  path)      cmd_path "$@" ;;
  help|*)    cmd_help ;;
esac
