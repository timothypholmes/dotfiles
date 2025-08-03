#!/usr/bin/env bash

# Docker functions and aliases

# Docker cleanup functions
function docker-cleanup() {
    echo "Cleaning up Docker..."
    docker system prune -f
    docker volume prune -f
    docker network prune -f
}

function docker-cleanup-all() {
    echo "Cleaning up ALL Docker resources (including images)..."
    docker system prune -a -f
    docker volume prune -f
    docker network prune -f
}

# Stop all containers
function docker-stop-all() {
    docker stop $(docker ps -aq) 2>/dev/null || echo "No containers to stop"
}

# Remove all containers
function docker-rm-all() {
    docker rm $(docker ps -aq) 2>/dev/null || echo "No containers to remove"
}

# Docker Compose helpers
function dc-up() {
    docker-compose up -d "$@"
}

function dc-down() {
    docker-compose down "$@"
}

function dc-logs() {
    docker-compose logs -f "$@"
}

# Docker aliases
alias d="docker"
alias dc="docker-compose"
alias dps="docker ps"
alias dpsa="docker ps -a"
alias di="docker images"
alias dex="docker exec -it"
alias dlog="docker logs -f"
alias dbuild="docker build"
alias dpull="docker pull"
alias dpush="docker push"

# Docker Compose aliases
alias dcup="docker-compose up -d"
alias dcdown="docker-compose down"
alias dclogs="docker-compose logs -f"
alias dcbuild="docker-compose build"
alias dcpull="docker-compose pull"
alias dcrestart="docker-compose restart"