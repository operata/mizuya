#!/usr/bin/env bash
# Cut a pre-release (alpha|beta|rc) from main: knope picks the version and writes the
# changelog, the bump goes on a throwaway branch, and gh creates the GitHub pre-release + `v*` tag at
# that exact commit (which fires push-artifact.yaml). main itself is never modified, so
# the prerelease version can't leak into main.
#
# gh creates the release instead of knope's `Release` step so the tag target is pinned to the bump
# commit on the throwaway branch rather than left to knope's API call.
set -euo pipefail

label="${1:?usage: prerelease.sh <alpha|beta|rc>}"
case "$label" in
alpha | beta | rc) ;;
*)
  echo "label must be alpha, beta or rc, got '$label'" >&2
  exit 1
  ;;
esac

: "${GH_TOKEN:?GH_TOKEN must be set (the create-github-app-token step exports it)}"

package_version() { pkl eval -x 'package.version' PklProject; }

# The bump commit must never land on a named branch (it would leak the prerelease version into a PR
# or main), so work on a detached HEAD and restore the original branch afterwards.
if ! git diff --quiet HEAD; then
  echo "working tree has uncommitted changes; run from a clean checkout" >&2
  exit 1
fi
orig=$(git symbolic-ref -q --short HEAD || true)
pushed_branch=""
cleanup() {
  if [ -n "$pushed_branch" ]; then
    git push --quiet origin --delete "$pushed_branch" || true
  fi
  if [ -n "$orig" ]; then
    git reset --hard --quiet
    git switch --quiet "$orig"
  fi
}
trap cleanup EXIT
git switch --detach --quiet

knope prepare-prerelease --prerelease-label "$label"
version=$(package_version)

# knope numbers prereleases from tags reachable from HEAD. The bump commit lives on a throwaway
# branch, so a second run from the same base would repeat -<label>.0 and collide on the tag.
if git ls-remote --exit-code --tags origin "refs/tags/v${version}" >/dev/null 2>&1; then
  base="${version%%-*}"
  last=$(git ls-remote --tags origin "refs/tags/v${base}-${label}.*" |
    sed -E "s#.*-${label}\.([0-9]+)\$#\1#" | sort -n | tail -1)
  git reset --hard --quiet HEAD
  knope prepare-prerelease --prerelease-label "$label" \
    --override-version "${base}-${label}.$((last + 1))"
  version=$(package_version)
fi

tag="v${version}"
branch="prerelease/${tag}"

git add PklProject CHANGELOG.md
git commit -m "chore: prepare release ${version}"
sha=$(git rev-parse HEAD)

# The tag must point at a commit that exists on the remote before the release is created.
pushed_branch="$branch"
git push origin "HEAD:refs/heads/${branch}"

# Newest changelog section, without its heading.
notes=$(mktemp)
awk '/^## /{n++; next} n==1' CHANGELOG.md >"$notes"

gh release create "$tag" --prerelease --target "$sha" --title "$version" --notes-file "$notes"
rm -f "$notes"
