#!/bin/bash
# Test script for genlist package

set -e  # Exit on error

echo "================================"
echo "GenList-Butler Package Test"
echo "================================"
echo

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_info() {
    echo -e "${YELLOW}→ $1${NC}"
}

# Test 1: Check if Python is available
print_info "Checking Python installation..."
if command -v python3 &> /dev/null; then
    PYTHON_VERSION=$(python3 --version)
    print_success "Python found: $PYTHON_VERSION"
else
    print_error "Python 3 not found. Please install Python 3.12 or higher."
    exit 1
fi

# Test 2: Create a virtual environment
print_info "Creating test virtual environment..."
if [ -d "test_venv" ]; then
    rm -rf test_venv
fi
python3 -m venv test_venv
source test_venv/bin/activate || source test_venv/Scripts/activate
print_success "Virtual environment created and activated"

# Test 3: Install the package in development mode
print_info "Installing genlist in development mode..."
pip install -e . > /dev/null 2>&1
if [ $? -eq 0 ]; then
    print_success "Package installed successfully"
else
    print_error "Package installation failed"
    deactivate
    exit 1
fi

# Test 4: Check if command is available
print_info "Checking if genlist command is available..."
if command -v genlist &> /dev/null; then
    print_success "genlist command found"
else
    print_error "genlist command not found"
    deactivate
    exit 1
fi

# Test 5: Test --help flag
print_info "Testing --help flag..."
genlist --help > /dev/null 2>&1
if [ $? -eq 0 ]; then
    print_success "--help flag works"
else
    print_error "--help flag failed"
    deactivate
    exit 1
fi

# Test 6: Create test music directory
print_info "Creating test music directory..."
mkdir -p test_music
echo "{title: Test Song}" > test_music/test_song.chopro
echo "# Another Song" > test_music/another_song.cho
print_success "Test music files created"

# Test 7: Run the actual command
print_info "Running genlist on test music..."
genlist test_music test_output.html --no-intro
if [ -f "test_output.html" ]; then
    print_success "HTML output file created"
    
    # Check if HTML contains expected content
    if grep -q "test_song" test_output.html && grep -q "another_song" test_output.html; then
        print_success "HTML contains expected song titles"
    else
        print_error "HTML missing expected content"
        deactivate
        exit 1
    fi
else
    print_error "HTML output file not created"
    deactivate
    exit 1
fi

# Test 8: Test filter options
print_info "Testing filter options..."
genlist test_music test_output2.html --filter none --no-intro > /dev/null 2>&1
if [ -f "test_output2.html" ]; then
    print_success "Filter option works"
else
    print_error "Filter option failed"
    deactivate
    exit 1
fi

# Test 9: Check package version
print_info "Checking package version..."
python -c "import genlist_butler; print(f'Version: {genlist_butler.__version__}')"
print_success "Package version accessible"

# Cleanup
print_info "Cleaning up test files..."
rm -rf test_music test_output.html test_output2.html
deactivate
rm -rf test_venv
print_success "Cleanup complete"

echo
echo "================================"
echo -e "${GREEN}All tests passed! ✓${NC}"
echo "================================"
echo
echo "Next steps:"
echo "  1. Test with real music folder:"
echo "     genlist ../TUG/music test.html"
echo
echo "  2. Build the package:"
echo "     python -m build"
echo
echo "  3. Publish to TestPyPI:"
echo "     twine upload --repository testpypi dist/*"
echo
echo "See PUBLISHING.md for detailed instructions."
