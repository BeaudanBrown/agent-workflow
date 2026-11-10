"""Check repository-relative inline Markdown links (not anchors or remote URLs)."""

import re
import sys
from pathlib import Path
from urllib.parse import unquote, urlsplit

LINK = re.compile(r"!?\[[^\]\n]*\]\(([^\s()]+)(?:\s+\"[^\"\n]*\")?\)")


def main() -> int:
    root = Path(sys.argv[1] if len(sys.argv) > 1 else ".").resolve()
    failures = []
    count = 0
    for document in sorted(root.rglob("*.md")):
        relative = document.relative_to(root)
        if any(part.startswith(".") for part in relative.parts):
            continue
        count += 1
        for number, line in enumerate(document.read_text().splitlines(), 1):
            for target in LINK.findall(line):
                url = urlsplit(target)
                if url.scheme or url.netloc or not url.path:
                    continue
                path = (document.parent / unquote(url.path)).resolve()
                if not path.is_relative_to(root) or not path.exists():
                    failures.append(f"{relative}:{number}: invalid local link: {target}")
    if not count:
        failures.append("No Markdown documents found")
    for failure in failures:
        print(failure, file=sys.stderr)
    if failures:
        return 1
    print(f"Checked local inline links in {count} Markdown documents")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
