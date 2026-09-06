#!/usr/bin/env bash
# Re-fetch the Waze patch sources from rushiranpise/morphe-patches.
#
# Upstream deleted these files on 2026-08-17 in commit 560c5ff ("fix: clean up"),
# so UPSTREAM_REF pins the last commit that still had them. Nothing downstream of
# that ref exists to track. Rerun this to diff our copy against the original and
# see exactly which lines we changed.
#
# Usage: tools/port-waze-from-upstream.sh [--check]
#   (no args)  overwrite the local copies with upstream + our rewrites
#   --check    diff instead of writing; non-zero exit means we have diverged

set -euo pipefail

UPSTREAM_REF=8611906
BASE="https://raw.githubusercontent.com/rushiranpise/morphe-patches/${UPSTREAM_REF}"
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

KOTLIN_DIR="patches/src/main/kotlin/app/template/patches/waze"
RES_DIR="patches/src/main/resources/waze/assets/res"

KOTLIN_FILES=(
    "$KOTLIN_DIR/WazePatches.kt"
    "$KOTLIN_DIR/WazeFingerprints.kt"
)

RES_FILES=(
    "$RES_DIR/preferences"
    "$RES_DIR/skins/default/aa_skin_values.day.lua"
    "$RES_DIR/skins/default/aa_skin_values.night.lua"
    "$RES_DIR/skins/default/skin_structure.main.lua"
    "$RES_DIR/skins/default/skin_values.day.lua"
    "$RES_DIR/skins/default/skin_values.editor.day.lua"
    "$RES_DIR/skins/default/skin_values.editor.lua"
    "$RES_DIR/skins/default/skin_values.editor.night.lua"
    "$RES_DIR/skins/default/skin_values.low_contrasts.lua"
    "$RES_DIR/skins/default/skin_values.night.lua"
    "$RES_DIR/skins/default/experiment/skin_structure.main.lua"
    "$RES_DIR/skins/default/experiment/skin_values.day.lua"
    "$RES_DIR/skins/default/experiment/skin_values.editor.day.lua"
    "$RES_DIR/skins/default/experiment/skin_values.editor.lua"
    "$RES_DIR/skins/default/experiment/skin_values.editor.night.lua"
    "$RES_DIR/skins/default/experiment/skin_values.low_contrasts.lua"
    "$RES_DIR/skins/default/experiment/skin_values.night.lua"
)

# Upstream kept ensureRegisters in an unrelated app's package and reached across
# into it. Here Waze is the only consumer and the helper is app-agnostic, so it
# lives in shared/.
rewrite() {
    sed 's#^import app\.template\.patches\.blockerhero\.ensureRegisters$#import app.template.patches.shared.ensureRegisters#'
}

fetch() {
    curl -fsSL --retry 3 "$BASE/$1"
}

check=0
[[ "${1:-}" == "--check" ]] && check=1

diverged=0
for f in "${KOTLIN_FILES[@]}" "${RES_FILES[@]}"; do
    case "$f" in
        *.kt) body=$(fetch "$f" | rewrite) ;;
        *)    body=$(fetch "$f") ;;
    esac

    if (( check )); then
        if ! printf '%s\n' "$body" | diff -q - "$ROOT/$f" >/dev/null 2>&1; then
            echo "diverged: $f"
            diverged=1
        fi
    else
        mkdir -p "$ROOT/$(dirname "$f")"
        printf '%s\n' "$body" > "$ROOT/$f"
        echo "wrote: $f"
    fi
done

if (( check )); then
    (( diverged )) && exit 1
    echo "all files match upstream @ $UPSTREAM_REF (modulo the import rewrite)"
fi
