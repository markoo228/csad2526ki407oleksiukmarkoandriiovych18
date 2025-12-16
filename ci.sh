#!/usr/bin/env bash
# Robust local CI script for CMake builds and tests
# - creates build dir if needed
# - configures (cmake -S . -B build -DCMAKE_BUILD_TYPE=$CONFIG)
# - builds unit_tests and attempts run_tests; if run_tests target missing, runs ctest directly

set -euo pipefail

BUILD_DIR="build"
CONFIG="${CMAKE_BUILD_TYPE:-Release}"

# Find an executable, optionally try common install locations
find_exe() {
  local name="$1"
  if command -v "$name" >/dev/null 2>&1; then
    command -v "$name"
    return 0
  fi
  # Common CMake install locations (Windows via MSYS/WSL paths)
  case "${OSTYPE:-}" in
    msys*|cygwin*|win32*)
      if [ -x "/c/Program Files/CMake/bin/$name.exe" ]; then
        printf '%s' "/c/Program Files/CMake/bin/$name.exe"
        return 0
      fi
      if [ -x "/c/Program Files (x86)/CMake/bin/$name.exe" ]; then
        printf '%s' "/c/Program Files (x86)/CMake/bin/$name.exe"
        return 0
      fi
      ;;
    *)
      if [ -x "/usr/bin/$name" ]; then
        printf '%s' "/usr/bin/$name"
        return 0
      fi
      if [ -x "/usr/local/bin/$name" ]; then
        printf '%s' "/usr/local/bin/$name"
        return 0
      fi
      ;;
  esac
  return 1
}

CMAKE_CMD="$(find_exe cmake || true)"
CTEST_CMD="$(find_exe ctest || true)"

if [ -z "$CMAKE_CMD" ]; then
  echo "ERROR: cmake not found in PATH or common locations" >&2
  exit 2
fi

printf 'Using CMake: %s\n' "$CMAKE_CMD"

echo ":: Start: creating '${BUILD_DIR}' (if needed) and configuring with CMake (config=${CONFIG})..."
mkdir -p "$BUILD_DIR"

echo ":: Configuring"
if ! "$CMAKE_CMD" -S . -B "$BUILD_DIR" -DCMAKE_BUILD_TYPE="$CONFIG"; then
  echo "ERROR: CMake configuration failed" >&2
  exit 1
fi

echo ":: Building unit_tests"
if ! "$CMAKE_CMD" --build "$BUILD_DIR" --config "$CONFIG" --target unit_tests; then
  echo "ERROR: Building unit_tests failed" >&2
  exit 1
fi

# Prefer building run_tests target (if it exists); otherwise fall back to running ctest directly
echo ":: Attempting to build 'run_tests' target (optional)"
if "$CMAKE_CMD" --build "$BUILD_DIR" --config "$CONFIG" --target run_tests >/dev/null 2>&1; then
  echo "run_tests target executed"
  echo "SUCCESS: Tests executed via run_tests target"
  exit 0
fi

# run_tests target not available or failed; run ctest directly
if [ -z "$CTEST_CMD" ]; then
  echo "WARNING: ctest not found in PATH or common locations; attempting to locate via cmake" >&2
  # Try to locate ctest next to cmake if possible
  CMAKE_DIR=$(dirname "$(readlink -f "$CMAKE_CMD" 2>/dev/null || printf '%s' "$CMAKE_CMD")")
  if [ -x "$CMAKE_DIR/ctest" ]; then
    CTEST_CMD="$CMAKE_DIR/ctest"
  elif [ -x "$CMAKE_DIR/ctest.exe" ]; then
    CTEST_CMD="$CMAKE_DIR/ctest.exe"
  else
    echo "ERROR: ctest not found; cannot run tests" >&2
    exit 2
  fi
fi

echo ":: Running ctest (dir=${BUILD_DIR}, config=${CONFIG})"
if ! "$CTEST_CMD" --test-dir "$BUILD_DIR" -C "$CONFIG" --output-on-failure; then
  echo "ERROR: Tests failed" >&2
  exit 1
fi

echo "SUCCESS: Build and tests completed successfully"
exit 0
