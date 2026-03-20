#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SLUG="three-d-showcase"
DIST_DIR="${ROOT_DIR}/dist"
STAGING_DIR="$(mktemp -d)"
PLUGIN_DIR="${STAGING_DIR}/${SLUG}"
ARCHIVE_PATH="${DIST_DIR}/${SLUG}.zip"

cleanup() {
	rm -rf "${STAGING_DIR}"
}
trap cleanup EXIT

mkdir -p "${PLUGIN_DIR}" "${DIST_DIR}"

while IFS= read -r -d '' file; do
	mkdir -p "${PLUGIN_DIR}/$(dirname "${file}")"
	cp -R "${ROOT_DIR}/${file}" "${PLUGIN_DIR}/${file}"
done < <(
	git -C "${ROOT_DIR}" ls-files -z -- \
		':(exclude)dist' \
		':(exclude)node_modules'
)

(
	cd "${STAGING_DIR}"
	rm -f "${ARCHIVE_PATH}"
	zip -qr "${ARCHIVE_PATH}" "${SLUG}"
)

printf 'Created %s\n' "${ARCHIVE_PATH}"
