#!/bin/bash
# Hoppscotch Self-Hosted Installation Script
# Usage: curl -fsSL https://hoppscotch.io/install.sh | bash
#
# This script automates the setup of a self-hosted Hoppscotch instance
# using Docker Compose.

set -euo pipefail

# --- Configuration ---
HOPPSCOTCH_REPO="https://github.com/hoppscotch/hoppscotch.git"
INSTALL_DIR="${HOPPSCOTCH_INSTALL_DIR:-./hoppscotch}"
BRANCH="${HOPPSCOTCH_BRANCH:-main}"

# --- Colors ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# --- Helper Functions ---
info() {
  printf "${BLUE}[INFO]${NC} %s\n" "$1"
}

success() {
  printf "${GREEN}[OK]${NC} %s\n" "$1"
}

warn() {
  printf "${YELLOW}[WARN]${NC} %s\n" "$1"
}

error() {
  printf "${RED}[ERROR]${NC} %s\n" "$1" >&2
}

fatal() {
  error "$1"
  exit 1
}

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# --- Preflight Checks ---
check_dependencies() {
  info "Checking dependencies..."

  if ! command_exists git; then
    fatal "git is not installed. Please install git and try again."
  fi

  if ! command_exists docker; then
    fatal "Docker is not installed. Please install Docker (https://docs.docker.com/get-docker/) and try again."
  fi

  if ! docker info >/dev/null 2>&1; then
    fatal "Docker daemon is not running or current user lacks permission. Please start Docker or add your user to the docker group."
  fi

  # Check for docker compose (v2 plugin or standalone)
  if docker compose version >/dev/null 2>&1; then
    DOCKER_COMPOSE="docker compose"
  elif command_exists docker-compose; then
    DOCKER_COMPOSE="docker-compose"
  else
    fatal "Docker Compose is not installed. Please install Docker Compose (https://docs.docker.com/compose/install/) and try again."
  fi

  success "All dependencies satisfied (git, docker, docker compose)"
}

# --- Clone or Update Repository ---
setup_repository() {
  if [ -d "$INSTALL_DIR" ]; then
    warn "Directory '$INSTALL_DIR' already exists."
    if [ -d "$INSTALL_DIR/.git" ]; then
      info "Updating existing Hoppscotch installation..."
      git -C "$INSTALL_DIR" fetch origin "$BRANCH"
      git -C "$INSTALL_DIR" checkout "$BRANCH"
      git -C "$INSTALL_DIR" pull origin "$BRANCH"
      success "Repository updated"
    else
      fatal "'$INSTALL_DIR' exists but is not a git repository. Please remove it or set HOPPSCOTCH_INSTALL_DIR to a different path."
    fi
  else
    info "Cloning Hoppscotch into '$INSTALL_DIR'..."
    git clone --depth 1 --branch "$BRANCH" "$HOPPSCOTCH_REPO" "$INSTALL_DIR"
    success "Repository cloned"
  fi
}

# --- Environment Configuration ---
setup_env() {
  local env_file="$INSTALL_DIR/.env"

  if [ -f "$env_file" ]; then
    info "Existing .env file found, keeping it"
    return
  fi

  if [ -f "$INSTALL_DIR/.env.example" ]; then
    cp "$INSTALL_DIR/.env.example" "$env_file"
    success "Created .env from .env.example"
    warn "Please review and update '$env_file' with your configuration before starting."
    warn "At minimum, update the following:"
    warn "  - DATABASE_URL (if using an external database)"
    warn "  - JWT secrets and session secrets"
    warn "  - SMTP settings (for email features)"
    warn "  - OAuth provider credentials (if needed)"
  else
    warn "No .env.example found. You will need to create a .env file manually."
    warn "See https://docs.hoppscotch.io/documentation/self-host/community-edition/install-and-build#configuring-the-environment"
  fi
}

# --- Start Services ---
start_services() {
  printf "\n"
  info "Ready to start Hoppscotch!"
  printf "\n"
  printf "  ${BOLD}Start the default (all-in-one) setup:${NC}\n"
  printf "    cd %s && %s --profile default up -d\n" "$INSTALL_DIR" "$DOCKER_COMPOSE"
  printf "\n"
  printf "  ${BOLD}Available profiles:${NC}\n"
  printf "    default        - All-in-one service + database + auto-migration (recommended)\n"
  printf "    default-no-db  - All-in-one service without database (external DB)\n"
  printf "    backend        - Backend service only\n"
  printf "    app            - Main Hoppscotch web application\n"
  printf "    admin          - Self-host admin dashboard\n"
  printf "\n"
  printf "  ${BOLD}Stop services:${NC}\n"
  printf "    cd %s && %s --profile default down\n" "$INSTALL_DIR" "$DOCKER_COMPOSE"
  printf "\n"
}

# --- Main ---
main() {
  printf "\n"
  printf "${BOLD}  _   _                                _       _      ${NC}\n"
  printf "${BOLD} | | | | ___  _ __  _ __  ___  ___ ___| |_ ___| |__   ${NC}\n"
  printf "${BOLD} | |_| |/ _ \\| '_ \\| '_ \\/ __|/ __/ _ \\ __/ __| '_ \\  ${NC}\n"
  printf "${BOLD} |  _  | (_) | |_) | |_) \\__ \\ (_| (_) | || (__| | | | ${NC}\n"
  printf "${BOLD} |_| |_|\\___/| .__/| .__/|___/\\___\\___/ \\__\\___|_| |_| ${NC}\n"
  printf "${BOLD}             |_|   |_|                                 ${NC}\n"
  printf "\n"
  printf "  ${BOLD}Open Source API Development Ecosystem${NC}\n"
  printf "  https://hoppscotch.io\n"
  printf "\n"

  check_dependencies
  setup_repository
  setup_env
  start_services

  success "Hoppscotch installation complete!"
  printf "\n"
  printf "  Documentation: https://docs.hoppscotch.io\n"
  printf "  GitHub:        https://github.com/hoppscotch/hoppscotch\n"
  printf "  Community:     https://discord.gg/GAMWxmR\n"
  printf "\n"
}

main "$@"
