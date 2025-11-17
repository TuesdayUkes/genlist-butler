#!/usr/bin/env python3
"""Simple test script to demonstrate the line numbers feature"""

import sys
import os
sys.path.insert(0, 'src')

from genlist_butler.cli import main

# Test with line numbers (default)
print("Testing with line numbers (default)...")
sys.argv = ['genlist', 'test_music', 'test_with_numbers.html']
try:
    main()
    print("✓ Generated test_with_numbers.html")
except Exception as e:
    print(f"✗ Error: {e}")

# Test without line numbers
print("\nTesting without line numbers...")
sys.argv = ['genlist', 'test_music', 'test_without_numbers.html', '--no-line-numbers']
try:
    main()
    print("✓ Generated test_without_numbers.html")
except Exception as e:
    print(f"✗ Error: {e}")

print("\nTest complete!")
