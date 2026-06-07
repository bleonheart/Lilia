from __future__ import annotations

import html
import shutil
from pathlib import Path


DOCS_DIR = Path(__file__).resolve().parent.parent
MODULES_ROOT = (DOCS_DIR / ".." / ".." / "metrorp" / "gitmodules").resolve()
OUTPUT_DIR = DOCS_DIR / "docs" / "modules"
INDEX_PATH = OUTPUT_DIR / "index.md"
LEGACY_DEFINITION_PATH = DOCS_DIR / "docs" / "definitions" / "metrorp-gitmodules.md"
LEGACY_DOWNLOADS_DIR = DOCS_DIR / "docs" / "downloads" / "metrorp-gitmodules"
LEGACY_OUTPUT_DIR = DOCS_DIR / "docs" / "metrorp-gitmodules"


def iter_markdown_files(root: Path) -> list[Path]:
    files = [
        path
        for path in root.rglob("*")
        if path.is_file() and path.suffix.lower() == ".md"
    ]
    return sorted(files, key=lambda path: str(path.relative_to(root)).lower())


def render_index(files: list[Path]) -> str:
    cards: list[str] = []
    sections: list[str] = []

    for source in files:
        relative_source = source.relative_to(MODULES_ROOT)
        title = source.stem.replace("_", " ")
        cards.append(
            "\n".join(
                [
                    '<a class="home-card" href="#' + html.escape(relative_source.stem.lower().replace("_", "-")) + '">',
                    f'  <span class="card-kicker">{html.escape(relative_source.parent.as_posix() or ".")}</span>',
                    f"  <h3>{html.escape(title)}</h3>",
                    f"  <p><code>{html.escape(relative_source.as_posix())}</code></p>",
                    "</a>",
                ]
            )
        )

        sections.append(
            "\n".join(
                [
                    f'### <a id="{html.escape(relative_source.stem.lower().replace("_", "-"))}"></a>{html.escape(title)}',
                    "",
                    f"`{html.escape(relative_source.as_posix())}`",
                    "",
                    source.read_text(encoding="utf-8", errors="ignore").strip(),
                ]
            )
        )

    listing = "\n".join(cards) if cards else "<p>No markdown files were found in the MetroRP gitmodules source.</p>"
    content = "\n\n---\n\n".join(sections) if sections else "_No markdown files found._"

    return f"""# Modules

<div class="reference-hero">
  <p class="home-eyebrow">MetroRP Markdown Sync</p>
  <h1>Workflow-style markdown import</h1>
  <p>This page is generated from <code>{html.escape(str(MODULES_ROOT))}</code> and imports only existing <code>.md</code> files into the workflow-style <code>docs/modules/index.md</code> output. No Lua scraping, ZIP packaging, or generated download artifacts are included.</p>
</div>

<div class="card-grid module-stats">
  <div class="card">
    <span class="card-kicker">Source</span>
    <h3>Folder</h3>
    <p><code>{html.escape(str(MODULES_ROOT))}</code></p>
  </div>
  <div class="card">
    <span class="card-kicker">Markdown Files</span>
    <h3>{len(files)}</h3>
    <p>Only files that already exist as markdown in the MetroRP gitmodules tree are copied here.</p>
  </div>
</div>

## Imported Files

<div class="home-grid">
{listing}
</div>

## Content

{content}
"""


def main() -> int:
    shutil.rmtree(OUTPUT_DIR, ignore_errors=True)
    shutil.rmtree(LEGACY_OUTPUT_DIR, ignore_errors=True)
    shutil.rmtree(LEGACY_DOWNLOADS_DIR, ignore_errors=True)
    LEGACY_DEFINITION_PATH.unlink(missing_ok=True)

    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)

    if not MODULES_ROOT.exists():
        INDEX_PATH.write_text(
            "# MetroRP GitModules\n\n"
            f"> Source folder not found: `{MODULES_ROOT}`\n",
            encoding="utf-8",
        )
        print(f"MetroRP gitmodules folder not found: {MODULES_ROOT}")
        return 0

    markdown_files = iter_markdown_files(MODULES_ROOT)
    INDEX_PATH.write_text(render_index(markdown_files), encoding="utf-8")
    print(f"Imported {len(markdown_files)} markdown file(s) from MetroRP gitmodules.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
