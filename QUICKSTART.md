# Quick Start Guide

This guide will help you get started with genlist-butler in 5 minutes.

## Installation

Install using pipx (recommended):

```bash
pipx install genlist-butler
```

Or using pip:

```bash
pip install genlist-butler
```

## Basic Usage

Generate a music catalog from a folder:

```bash
genlist-butler /path/to/music index.html
```

This will:
1. Scan the music folder recursively
2. Find all music files (.pdf, .chopro, .cho, .mscz, etc.)
3. Use git history to show only the newest versions
4. Generate an interactive HTML catalog

## Open the Result

Open `index.html` in your web browser. You'll see:
- 🔍 **Search bar** - Find songs by title
- 🎵 **Easy songs filter** - Show only beginner-friendly songs
- 🗂️ **Version toggle** - Show/hide older file versions
- 📊 **Song table** - Numbered list with download links

## Common Use Cases

### Show All File Versions

By default, only the newest version of each file is shown:

```bash
genlist-butler ./music index.html --filter none
```

### Hide Only Marked Files

Hide only files explicitly marked with `.hide` extension:

```bash
genlist-butler ./music index.html --filter hidden
```

### Generate PDFs First

If you have ChordPro files and want PDFs generated:

```bash
genlist-butler ./music index.html --genPDF
```

**Note:** Requires [ChordPro](https://www.chordpro.org/) to be installed.

### Skip the Introduction Section

Generate without the Tuesday Ukes introduction:

```bash
genlist-butler ./music index.html --no-intro
```

## File Markers

### Mark Easy Songs

Create a file named `songname.easy` in the same folder as your song files. This will mark all files with the same base name as "easy songs" that can be filtered in the HTML interface.

Example:
```
music/
  Amazing Grace.chopro
  Amazing Grace.pdf
  Amazing Grace.easy      ← Creates easy song marker
```

### Hide Old Versions

Create a file named `oldversion.hide` to hide all files with that base name:

```
music/
  old-arrangement/
    Yesterday.chopro
    Yesterday.hide        ← Hides Yesterday files in this folder
  new-arrangement/
    Yesterday.chopro      ← This one will be shown
```

## Folder Structure Example

Here's a recommended folder structure:

```
my-music-library/
  ├── Beatles/
  │   ├── Yesterday.chopro
  │   ├── Yesterday.pdf
  │   ├── Let It Be.chopro
  │   └── Let It Be.easy
  ├── Folk/
  │   ├── Amazing Grace.chopro
  │   ├── Amazing Grace.pdf
  │   └── This Land.chopro
  └── HTMLheader.txt (optional custom header)
```

Run from the parent folder:

```bash
cd my-music-library
genlist-butler . catalog.html
```

## Custom HTML Header

By default, genlist-butler uses a simple built-in HTML header. To customize:

1. Create a file named `HTMLheader.txt` in your working directory
2. Add your custom HTML header (must be valid HTML)
3. Run genlist-butler from that directory

Example `HTMLheader.txt`:

```html
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>My Music Collection</title>
<link rel="stylesheet" href="styles/main.css">
</head>
<body>
<header>
  <img src="logo.png" alt="Logo">
  <h1>My Music Library</h1>
</header>
```

## Troubleshooting

### "No files found"

- Check that your music folder contains supported file types
- Supported: `.pdf`, `.chopro`, `.cho`, `.mscz`, `.urltxt`

### "Git command failed"

- Git is required for timestamp-based filtering
- If git isn't available, the tool uses file modification times
- Install git: https://git-scm.com/downloads

### "ChordPro not found" (when using --genPDF)

- Install ChordPro from https://www.chordpro.org/
- Or skip PDF generation by omitting `--genPDF`

### Duplicate songs appear

- Use timestamp filtering (default) to show only newest versions
- Or manually create `.hide` files for old versions

## Next Steps

- Read the full [README.md](README.md) for all features
- Check [CHANGELOG.md](CHANGELOG.md) for version history
- For publishing your own fork, see [PUBLISHING.md](PUBLISHING.md)

## Getting Help

- Report issues: https://github.com/TuesdayUkes/genlist-butler/issues
- Tuesday Ukes website: https://tuesdayukes.org/

## Examples

### Complete Example

```bash
# Install
pipx install genlist-butler

# Navigate to your music folder
cd ~/Documents/UkuleleSongs

# Generate catalog with PDFs, showing only newest versions
genlist-butler . "My Songs.html" --genPDF --filter timestamp

# Open in browser
open "My Songs.html"  # macOS
xdg-open "My Songs.html"  # Linux
start "My Songs.html"  # Windows
```

### Development/Testing Example

```bash
# Show ALL versions (useful during development)
genlist-butler ./test-music test.html --filter none --no-intro

# Force regenerate all PDFs
genlist-butler ./music catalog.html --genPDF --forcePDF
```

## Tips

1. **Version Control**: Keep your music files in a git repository for best timestamp tracking
2. **Organization**: Use folders to organize by genre, artist, or difficulty
3. **Naming**: Use consistent naming (avoid special characters in filenames)
4. **Testing**: Use `--filter none` first to see all files, then switch to `timestamp`
5. **Performance**: The tool is very fast (~0.7 seconds for large libraries)

Enjoy making music! 🎵
