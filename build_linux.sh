#!/bin/bash
# Linux / macOS build (same code as build_windows.bat, no Winsock needed).
cd "$(dirname "$0")"
g++ -std=c++11 -Wall -Wextra -pedantic CPP/backend.cpp -o parking_server
if [ $? -ne 0 ]; then
  echo "Build failed. Check that g++ is installed."
  exit 1
fi
echo "Build successful. Run ./run_linux.sh next."
