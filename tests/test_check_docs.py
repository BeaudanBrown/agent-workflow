"""Behavior checks for the intentionally small local-link verifier."""

import subprocess
import sys
import tempfile
import unittest
from pathlib import Path

CHECKER = Path(__file__).resolve().parents[1] / "scripts" / "check-docs.py"


class CheckDocsTests(unittest.TestCase):
    def check(self, root):
        return subprocess.run(
            [sys.executable, str(CHECKER), str(root)],
            capture_output=True,
            text=True,
            check=False,
        )

    def test_valid_relative_links_and_ignored_external_links(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            (root / "docs").mkdir()
            (root / "docs" / "guide.md").write_text("# Guide\n")
            (root / "README.md").write_text(
                "[Guide](docs/guide.md#heading)\n"
                "[Web](https://example.com/not-checked)\n"
                "[Anchor](#local)\n"
            )
            result = self.check(root)
            self.assertEqual(result.returncode, 0, result.stderr)

    def test_missing_local_link_fails_with_location(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            (root / "README.md").write_text("[Missing](missing.md)\n")
            result = self.check(root)
            self.assertEqual(result.returncode, 1)
            self.assertIn("README.md:1: invalid local link: missing.md", result.stderr)

    def test_link_outside_repository_fails_even_when_target_exists(self):
        with tempfile.TemporaryDirectory() as directory:
            outer = Path(directory)
            root = outer / "repo"
            root.mkdir()
            (outer / "private.md").write_text("Not public documentation\n")
            (root / "README.md").write_text("[Outside](../private.md)\n")
            self.assertEqual(self.check(root).returncode, 1)

    def test_empty_repository_is_not_a_pass(self):
        with tempfile.TemporaryDirectory() as directory:
            result = self.check(Path(directory))
            self.assertEqual(result.returncode, 1)
            self.assertIn("No Markdown documents found", result.stderr)


if __name__ == "__main__":
    unittest.main()
