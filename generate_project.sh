#!/usr/bin/env bash
set -euo pipefail

if ! command -v xcodegen >/dev/null 2>&1; then
  echo "XcodeGen is not installed."
  echo "Install with: brew install xcodegen"
  exit 1
fi

xcodegen generate

echo "Generated LunchReminder.xcodeproj"
