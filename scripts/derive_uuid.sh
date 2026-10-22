#!/bin/sh
# Derive a UUID (v4 layout) deterministically from a secret string.
# Method: h = lowercase hex sha256(SECRET bytes, no trailing newline)
#   take h[0:32]; set h[12]='4'; set h[16]=hex((int(h[16],16) & 3) | 8)
#   format 8-4-4-4-12.
# Usage: scripts/derive_uuid.sh "<SECRET>"   (or SECRET=... scripts/derive_uuid.sh)
set -e
S="${1:-$SECRET}"
[ -n "$S" ] || { echo "usage: $0 SECRET" >&2; exit 1; }
h=$(printf '%s' "$S" | sha256sum | cut -c1-32)
v=$(printf '%x' $(( (0x$(printf '%s' "$h" | cut -c17) & 3) | 8 )))
printf '%s-%s-4%s-%s%s-%s\n' "$(echo "$h"|cut -c1-8)" "$(echo "$h"|cut -c9-12)" \
  "$(echo "$h"|cut -c14-16)" "$v" "$(echo "$h"|cut -c18-20)" "$(echo "$h"|cut -c21-32)"
