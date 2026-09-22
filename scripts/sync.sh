#!/usr/bin/env bash
# Copy everything under shared/ into every template under templates/,
# preserving the directory structure, so shared files only need to be
# maintained in one place.
#
# Usage: ./scripts/sync.sh
set -euo pipefail

cd "$(dirname "$0")/.."

src="shared"
updated=0

for tmpl in templates/*/; do
	name=$(basename "$tmpl")
	while IFS= read -r -d '' f; do
		rel=${f#"$src"/}
		dest="$tmpl$rel"
		mkdir -p "$(dirname "$dest")"
		if ! cmp -s "$f" "$dest"; then
			cp "$f" "$dest"
			echo "updated: templates/$name/$rel"
			updated=$((updated + 1))
		else
			echo "ok:      templates/$name/$rel"
		fi
	done < <(find "$src" -type f -print0)
done

echo "done, $updated file(s) updated."
