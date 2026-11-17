#!/usr/bin/env bash
# Checks that sdk-docs/ describes the release this branch publishes.
#
#   .github/scripts/check-release-docs.sh
#
# main publishes iOS: the version is the one in Package.swift's binary target URL.
# gh-pages publishes Android: the version is the latest <release> of com.irdb:irkit-ui, and
# getting-started/maven-and-aars.md must be stamped with it.
#
# Then check_sdk_docs.mjs checks every page, and that CHANGELOG.md has an entry for that version.
# Run by .github/workflows/sdk-docs.yml on every push and pull request to main and gh-pages, and by
# the SDK repos' release tooling before they commit a release.
#
# Exits 1 when the docs have problems, and 2 when it can't check them: no published version to
# read, or no node.
set -euo pipefail
cd "$(dirname "$0")/../.."

if ! command -v node >/dev/null 2>&1; then
  echo "node not found; check_sdk_docs.mjs runs on it (brew install node)." >&2
  exit 2
fi

if [[ -f Package.swift ]]; then
  platform=iOS
  version=$(sed -nE 's#.*/releases/download/([^/]+)/IRKit\.xcframework\.zip.*#\1#p' Package.swift | head -1)
elif [[ -f com/irdb/irkit-ui/maven-metadata.xml ]]; then
  platform=Android
  version=$(sed -nE 's#.*<release>([^<]+)</release>.*#\1#p' com/irdb/irkit-ui/maven-metadata.xml | head -1)
else
  echo "Neither Package.swift (iOS, main) nor com/irdb/irkit-ui/maven-metadata.xml (Android, gh-pages) is here." >&2
  exit 2
fi
if [[ -z "$version" ]]; then
  echo "Could not read the published $platform version." >&2
  exit 2
fi
echo "$platform publishes $version"

status=0
if [[ $platform == Android ]]; then
  stamp=sdk-docs/getting-started/maven-and-aars.md
  if ! grep -qF "**Documented library version:** \`$version\`" "$stamp"; then
    echo "$stamp: not stamped with the published version $version. Run /generate-client-docs in irkit-android for this publish." >&2
    status=1
  fi
fi
node .github/scripts/check_sdk_docs.mjs sdk-docs "$version" || status=1
exit $status
