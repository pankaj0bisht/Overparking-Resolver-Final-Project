#!/bin/bash
# Linux / macOS run (same as run_windows.bat).
cd "$(dirname "$0")"
if [ ! -f parking_server ]; then
  echo "parking_server not found. Run ./build_linux.sh first."
  exit 1
fi
./parking_server
