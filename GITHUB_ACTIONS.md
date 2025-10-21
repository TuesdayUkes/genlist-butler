# GitHub Actions Setup Guide

This repository includes two GitHub Actions workflows:

## 1. Tests Workflow (`.github/workflows/test.yml`)

**Triggers:** Automatically on push and pull requests to `main` and `develop` branches

**What it does:**
- Tests the package on Linux, Windows, and macOS
- Tests with Python 3.12 and 3.13
- Verifies the command-line tool works
- Runs basic functionality tests
- Uploads test artifacts if tests fail

**Setup:** No setup required! This will run automatically once you push to GitHub.

## 2. Publish Workflow (`.github/workflows/publish.yml`)

**Triggers:** 
- Automatically when you publish a GitHub Release

**What it does:**
- Builds the package distribution (wheel and source)
- Publishes to both TestPyPI and PyPI using Trusted Publishing

## 3. Release Workflow (`.github/workflows/release.yml`)

**Triggers:** 
- Manually via workflow_dispatch (GitHub Actions UI)

**What it does:**
- Auto-increments version number (patch, minor, or major)
- Updates `pyproject.toml` and `__init__.py`
- Commits and pushes version changes
- Creates a git tag
- Creates a GitHub Release (which triggers the publish workflow)

**This is the recommended way to create releases!**

### Setup for Publishing:

#### Step 1: Configure PyPI Trusted Publishing

This workflow uses PyPI's [Trusted Publishing](https://docs.pypi.org/trusted-publishers/) which is more secure than using API tokens.

**For PyPI (production):**
1. Go to https://pypi.org/manage/account/publishing/
2. Add a new pending publisher:
   - **PyPI Project Name:** `genlist-butler`
   - **Owner:** `TuesdayUkes`
   - **Repository name:** `genlist-butler`
   - **Workflow name:** `publish.yml`
   - **Environment name:** `pypi`

**For TestPyPI (testing):**
1. Go to https://test.pypi.org/manage/account/publishing/
2. Add a new pending publisher with the same settings but:
   - **Environment name:** `testpypi`

#### Step 2: Configure GitHub Environments

1. Go to your repo: `https://github.com/TuesdayUkes/genlist-butler/settings/environments`
2. Create two environments:
   - **Name:** `pypi`
     - Add protection rules (recommended): Require reviewers
   - **Name:** `testpypi`
     - No protection needed (for testing)

#### Step 3: Create a Release (Recommended: Use the Release Workflow)

The easiest way to create a release with automatic version bumping:

1. **Go to Actions → Bump Version and Release → Run workflow**
2. **Select the version bump type:**
   - **patch** (1.0.0 → 1.0.1) - Bug fixes, small changes
   - **minor** (1.0.0 → 1.1.0) - New features, backward compatible
   - **major** (1.0.0 → 2.0.0) - Breaking changes
3. **Click "Run workflow"**

The workflow will automatically:
- Increment the version number
- Update `pyproject.toml` and `__init__.py`
- Commit and push the changes
- Create a git tag
- Create a GitHub Release
- Trigger the publish workflow to upload to PyPI

#### Alternative: Manual Release

If you prefer to manually control the version:

1. **Update the version** in `pyproject.toml` and `src/genlist_butler/__init__.py`
2. **Commit and push** your changes
3. **Create a GitHub Release:**
   - Go to: `https://github.com/TuesdayUkes/genlist-butler/releases/new`
   - Tag version: `v1.0.0` (or your version)
   - Release title: `v1.0.0`
   - Describe changes
   - Click "Publish release"

4. **Watch the workflow:**
   - Go to Actions tab to see the publish workflow run
   - It will automatically publish to both TestPyPI and PyPI

## Testing the Workflows Locally

Before pushing, you can test locally:

```bash
# Run the same tests that GitHub Actions will run
bash test.sh  # or test.bat on Windows

# Build the package (what the publish workflow does)
pip install build
python -m build
```

## Workflow Status

Check workflow status at:
- All workflows: `https://github.com/TuesdayUkes/genlist-butler/actions`
- Tests: `https://github.com/TuesdayUkes/genlist-butler/actions/workflows/test.yml`
- Release: `https://github.com/TuesdayUkes/genlist-butler/actions/workflows/release.yml`
- Publishing: `https://github.com/TuesdayUkes/genlist-butler/actions/workflows/publish.yml`

## Troubleshooting

### Tests fail on GitHub but pass locally
- Ensure all files are committed (especially in `src/`)
- Check Python version compatibility
- Review the test artifacts uploaded by the workflow

### Publishing fails with "not authorized"
- Verify Trusted Publishing is configured on PyPI/TestPyPI
- Ensure environment names match exactly (`pypi` and `testpypi`)
- Check that the workflow has proper permissions

### Want to publish to only PyPI or only TestPyPI?
Edit `.github/workflows/publish.yml` and comment out the job you don't want.

## Security Notes

✅ **Trusted Publishing** is used (no API tokens to manage!)
✅ **Environment protection** can be enabled for production
✅ **Permissions** are minimal (only `id-token: write`)
