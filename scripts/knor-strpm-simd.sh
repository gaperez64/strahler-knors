#!/bin/bash
#
# Wrapper around knor that always uses the STRPM solver with SIMD. Reads an
# eHOA specification either from a positional file argument or, if no
# argument is given, from stdin. Extra arguments are forwarded to knor as-is.
#
# Examples:
#     scripts/knor-strpm-simd.sh examples/full_arbiter_3.tlsf.ehoa -a
#     cat spec.ehoa | scripts/knor-strpm-simd.sh -a -v --bisim --onehot
#
# Exit codes mirror knor:
#   10  realizable
#   20  unrealizable
#   anything else  parse / runtime error

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
BIN="$ROOT/build/knor"

if [ ! -x "$BIN" ]; then
    echo "Error: $BIN not found. Run scripts/compile.sh first." >&2
    exit 3
fi

# Separate the optional file argument (the first non-flag positional) from
# the rest, which is forwarded to knor. If there's no file, knor reads from
# stdin per its own --help.
file=""
forwarded=()
for arg in "$@"; do
    if [ -z "$file" ] && [ -e "$arg" ] && [ "${arg#-}" = "$arg" ]; then
        file="$arg"
    else
        forwarded+=("$arg")
    fi
done

if [ -n "$file" ]; then
    exec "$BIN" --strpm-simd "${forwarded[@]}" "$file"
else
    exec "$BIN" --strpm-simd "${forwarded[@]}"
fi
