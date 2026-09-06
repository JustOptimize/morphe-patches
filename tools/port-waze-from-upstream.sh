#!/usr/bin/env bash
# Diff the Waze patch sources against rushiranpise/morphe-patches.
#
# Upstream deleted these files on 2026-08-17 in commit 560c5ff ("fix: clean up"),
# so UPSTREAM_REF pins the last commit that still had them. Nothing downstream of
# that ref exists to track.
#
# The Kotlin has deliberately diverged (see git log), so this only reports on it.
# The resources are meant to stay byte-identical, so a resource diff is an error.
#
# Usage: tools/port-waze-from-upstream.sh [--restore-resources]
#   (no args)            print every difference; exit 1 if a resource diverged
#   --restore-resources  rewrite the resource files from upstream.
#                        Never touches Kotlin, which would undo our fixes.

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

restore=0
[[ "${1:-}" == "--restore-resources" ]] && restore=1

if (( restore )); then
    for f in "${RES_FILES[@]}"; do
        mkdir -p "$ROOT/$(dirname "$f")"
        fetch "$f" > "$ROOT/$f"
        echo "restored: $f"
    done
    exit 0
fi

resource_diverged=0
for f in "${KOTLIN_FILES[@]}" "${RES_FILES[@]}"; do
    case "$f" in
        *.kt) upstream=$(fetch "$f" | rewrite) ;;
        *)    upstream=$(fetch "$f") ;;
    esac

    if printf '%s\n' "$upstream" | diff -q - "$ROOT/$f" >/dev/null 2>&1; then
        continue
    fi

    printf '%s\n' "$upstream" | diff -u --label "upstream/$f" - --label "$f" "$ROOT/$f" || true

    case "$f" in
        *.kt) ;;
        *) resource_diverged=1 ;;
    esac
done

if (( resource_diverged )); then
    echo "error: a resource diverged from upstream @ $UPSTREAM_REF" >&2
    exit 1
fi

echo "resources match upstream @ $UPSTREAM_REF"
