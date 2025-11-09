#!/usr/bin/env bash

set -euo pipefail

export GITHUB="true"

GITHUB_ACTION_PATH="${GITHUB_ACTION_PATH%/}"
DRONE_SCP_RELEASE_URL="${DRONE_SCP_RELEASE_URL:-https://github.com/appleboy/drone-scp/releases/download}"
DRONE_SCP_VERSION="${DRONE_SCP_VERSION:-1.8.0}"

function log_error() {
  echo "$1" >&2
  exit "$2"
}

function detect_client_info() {
  CLIENT_PLATFORM="${SCP_CLIENT_OS:-$(uname -s | tr '[:upper:]' '[:lower:]')}"
  CLIENT_ARCH="${SCP_CLIENT_ARCH:-$(uname -m)}"

  case "${CLIENT_PLATFORM}" in
  darwin | linux | windows) ;;
  *) log_error "Unknown or unsupported platform: ${CLIENT_PLATFORM}. Supported platforms are Linux, Darwin, and Windows." 2 ;;
  esac

  case "${CLIENT_ARCH}" in
  x86_64* | i?86_64* | amd64*) CLIENT_ARCH="amd64" ;;
  aarch64* | arm64*) CLIENT_ARCH="arm64" ;;
  *) log_error "Unknown or unsupported architecture: ${CLIENT_ARCH}. Supported architectures are x86_64, i686, and arm64." 3 ;;
  esac
}

function process_flatten() {
  # Only process if flatten is enabled and strip_components is not manually set
  if [[ "${INPUT_FLATTEN}" == 'true' ]] && [[ -z "${INPUT_STRIP_COMPONENTS}" ]]; then
    # Parse the source paths (comma-separated)
    IFS=',' read -ra SOURCE_PATHS <<< "${INPUT_SOURCE}"
    local max_depth=0
    
    for source_path in "${SOURCE_PATHS[@]}"; do
      # Trim whitespace
      source_path=$(echo "$source_path" | xargs)
      
      # Calculate directory depth (count slashes before wildcard or end)
      if [[ "$source_path" == *"*"* ]]; then
        # Has wildcard - count slashes before the *
        local path_before_wildcard="${source_path%%\**}"
        local depth=$(echo "$path_before_wildcard" | tr -cd '/' | wc -c)
      else
        # No wildcard - treat as directory, count all slashes
        local depth=$(echo "$source_path" | sed 's:/*$::' | tr -cd '/' | wc -c)
        # Add 1 to strip the directory itself
        depth=$((depth + 1))
      fi
      
      # Track maximum depth for multiple sources
      if [[ $depth -gt $max_depth ]]; then
        max_depth=$depth
      fi
    done
    
    # Set strip_components if we found paths to flatten
    if [[ $max_depth -gt 0 ]]; then
      export INPUT_STRIP_COMPONENTS="$max_depth"
      echo "Flatten enabled: automatically setting strip_components=${max_depth}"
    fi
  fi
}

detect_client_info
process_flatten
DOWNLOAD_URL_PREFIX="${DRONE_SCP_RELEASE_URL}/v${DRONE_SCP_VERSION}"
CLIENT_BINARY="drone-scp-${DRONE_SCP_VERSION}-${CLIENT_PLATFORM}-${CLIENT_ARCH}"
TARGET="${GITHUB_ACTION_PATH}/${CLIENT_BINARY}"
echo "Downloading ${CLIENT_BINARY} from ${DOWNLOAD_URL_PREFIX}"
INSECURE_OPTION=""
if [[ "${INPUT_CURL_INSECURE}" == 'true' ]]; then
  INSECURE_OPTION="--insecure"
fi

if [[ ! -x "${TARGET}" ]]; then
  curl -fsSL --retry 5 --keepalive-time 2 ${INSECURE_OPTION} "${DOWNLOAD_URL_PREFIX}/${CLIENT_BINARY}" -o "${TARGET}"
  chmod +x "${TARGET}"
else
  echo "Binary ${CLIENT_BINARY} already exists and is executable, skipping download."
fi

echo "======= CLI Version Information ======="
"${TARGET}" --version
echo "======================================="
if [[ "${INPUT_CAPTURE_STDOUT}" == 'true' ]]; then
  {
    echo 'stdout<<EOF'
    "${TARGET}" "$@" | tee -a "${GITHUB_OUTPUT}"
    echo 'EOF'
  } >>"${GITHUB_OUTPUT}"
else
  "${TARGET}" "$@"
fi
