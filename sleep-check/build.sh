#!/bin/bash

# Compile for ARM64
clang -framework ApplicationServices -framework CoreGraphics -framework CoreFoundation sleep-check.c -o sleep-check-arm64 -arch arm64

# Compile for x86_64
clang -framework ApplicationServices -framework CoreGraphics -framework CoreFoundation sleep-check.c -o sleep-check-x86-64 -arch x86_64

# Create universal binary
lipo -create sleep-check-arm64 sleep-check-x86-64 -output sleep-check-macos-universal

# Clean up intermediate files
rm sleep-check-arm64 sleep-check-x86-64

echo "Universal binary created: sleep-check_universal"