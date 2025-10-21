# HTMLheader.txt - Embedded HTML Template

## Overview

GenList-Butler includes the Tuesday Ukes' custom HTMLheader.txt template **embedded directly in the code** as a Python string constant. This means users get the beautiful, modern HTML styling out of the box without needing any external files.

## How It Works

The tool looks for HTMLheader.txt in this order:

1. **Current working directory** - If you have `HTMLheader.txt` in the directory where you run the command, it will use that (for custom styling)
2. **Embedded default** - Uses the built-in Tuesday Ukes template (stored in `cli.py` as `DEFAULT_HTML_HEADER`)

## Implementation

The template is embedded as a multi-line string constant in `src/genlist_butler/cli.py`:

```python
DEFAULT_HTML_HEADER = """<!DOCTYPE html>
<html lang="en-US" class="no-js">
<head>
...
</head>
"""
```

This approach is:
- ✅ **Simpler** - No need to deal with package resource files
- ✅ **More reliable** - Always available, no file path issues
- ✅ **Self-contained** - Everything in one Python file
- ✅ **Easier to maintain** - Just edit the string constant

## For Package Users

When someone installs genlist-butler via pipx, they automatically get the Tuesday Ukes HTMLheader template. No configuration needed, no external files required!

```bash
pipx install genlist-butler
genlist-butler ./music index.html
# ↑ This will produce beautifully styled HTML with the Tuesday Ukes theme
```

## Customization

Users who want their own custom styling can:

1. **Create a custom HTMLheader.txt** in their working directory
2. Run genlist-butler from that directory
3. The tool will use their custom header instead of the packaged one

Example:
```bash
cd my-music-folder
# Create your custom HTMLheader.txt here
nano HTMLheader.txt
# Run genlist-butler
genlist-butler . catalog.html
```

## Benefits

### For Users:
- **Zero configuration** - Beautiful HTML out of the box
- **Consistent branding** - Tuesday Ukes look and feel
- **Professional output** - No need to write HTML/CSS
- **No external files** - Everything embedded in the tool

### For You:
- **Simple maintenance** - Just edit the Python string constant
- **No packaging complexity** - No need to deal with package_data or resource files
- **Version controlled** - Template updates with the code
- **Customizable** - Users can still override with their own HTMLheader.txt

## Technical Details

### Code structure:

```python
# At the top of cli.py
DEFAULT_HTML_HEADER = """<!DOCTYPE html>
...
"""

# In main()
if os.path.exists("HTMLheader.txt"):
    with open("HTMLheader.txt", "r", encoding='utf-8') as headerText:
        header = headerText.readlines()
    print("Using custom HTMLheader.txt from current directory", file=sys.stderr)
else:
    # Use the embedded default header
    header = DEFAULT_HTML_HEADER.splitlines(keepends=True)
```

Simple, clean, and reliable!

## Updating the Template

To update the template:

1. Edit the `DEFAULT_HTML_HEADER` string constant in `src/genlist_butler/cli.py`
2. Test locally: `pip install -e .`
3. Bump version in `pyproject.toml`
4. Rebuild: `python -m build`
5. Publish: `twine upload dist/*`

That's it! No need to worry about package resources or file paths.

## Testing

The template is always available since it's embedded in the code. Just test the command:

```bash
pip install -e .
genlist-butler ./test-music output.html
```

Open `output.html` to see the beautiful Tuesday Ukes styling!
