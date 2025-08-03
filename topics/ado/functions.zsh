#!/usr/bin/env bash

# Azure DevOps functions and aliases

# Helper function to get current repository name
function current_repository() {
    basename $(git rev-parse --show-toplevel 2>/dev/null || echo "unknown")
}

# Helper function to get current branch
function current_branch() {
    git branch --show-current 2>/dev/null || echo "main"
}

# Get pipeline name from repository name
function get_pipeline_name() {
    local repo_name=$(current_repository)
    
    # Handle common repository naming patterns
    # Remove common prefixes/suffixes that might not be in pipeline names
    local pipeline_name="$repo_name"
    
    # Remove .git suffix if present
    pipeline_name="${pipeline_name%.git}"
    
    # If repo has extra path components or suffixes, try to find matching pipeline
    # First try the full repo name as pipeline name
    if az pipelines list --name "$pipeline_name" --output table >/dev/null 2>&1; then
        echo "$pipeline_name"
        return 0
    fi
    
    # If that fails, try common variations
    # Remove common repo prefixes/suffixes
    local variations=(
        "${pipeline_name#*-}"  # Remove everything up to first dash
        "${pipeline_name%-*}"  # Remove everything after last dash
        "${repo_name}"         # Original name
    )
    
    for variation in "${variations[@]}"; do
        if [[ -n "$variation" ]] && az pipelines list --name "$variation" --output table >/dev/null 2>&1; then
            echo "$variation"
            return 0
        fi
    done
    
    # If no exact match found, return the repo name and let user know
    echo "$repo_name"
    return 1
}

# Run Azure DevOps pipeline
function run_pipeline() {
    local env="$1"
    
    if [[ -z "$env" ]]; then
        echo "Usage: run_pipeline <environment>"
        echo "Available environments: dev, qa"
        return 1
    fi
    
    echo "Running pipeline for environment: $env"
    
    # Get pipeline name dynamically
    local pipeline_name
    pipeline_name=$(get_pipeline_name)
    local pipeline_exists=$?
    
    if [[ $pipeline_exists -ne 0 ]]; then
        echo "Warning: Could not verify pipeline '$pipeline_name' exists"
        echo "Attempting to run anyway..."
    fi
    
    echo "Pipeline: $pipeline_name"
    echo "Repository: $(current_repository)"
    echo "Branch: $(current_branch)"
   
    case "$env" in
        "dev")
            az pipelines run --name "$pipeline_name" --branch "$(current_branch)" \
                --parameters 'Environments=- env: dev' --output table --open
            ;;
        "qa")
            az pipelines run --name "$pipeline_name" --branch "$(current_branch)" \
                --parameters 'Environments=- env: qa' 'MakeQAGo=true' --output table --open
            ;;
        *)
            echo "Invalid environment: $env"
            echo "Available environments: dev, qa"
            return 1
            ;;
    esac
}

# Create Azure DevOps work item (story)
function ado_create_story() {
    local title="$1"
    local description="$2"
    
    if [[ -z "$title" ]]; then
        echo "Usage: ado_create_story 'Story Title' 'Description'"
        return 1
    fi
    
    az boards work-item create --title "$title" --type "User Story" --description "${description:-$title}" --output table
}

# Create Azure DevOps work item (bug)
function ado_create_bug() {
    local title="$1"
    local description="$2"
    
    if [[ -z "$title" ]]; then
        echo "Usage: ado_create_bug 'Bug Title' 'Description'"
        return 1
    fi
    
    az boards work-item create --title "$title" --type "Bug" --description "${description:-$title}" --output table
}

# List recent work items
function ado_list_work_items() {
    az boards work-item list --output table
}

# Show pipeline runs
function ado_list_pipelines() {
    az pipelines runs list --output table
}

# Set ADO organization and project (run once to configure)
function ado_setup() {
    local org="$1"
    local project="$2"
    
    if [[ -z "$org" || -z "$project" ]]; then
        echo "Usage: ado_setup 'organization' 'project'"
        echo "Example: ado_setup 'mycompany' 'myproject'"
        return 1
    fi
    
    az devops configure --defaults organization="https://dev.azure.com/$org" project="$project"
    echo "ADO configured for organization: $org, project: $project"
}

# ADO aliases
alias ado-login="az login"
alias ado-story="ado_create_story"
alias ado-bug="ado_create_bug"
alias ado-list="ado_list_work_items"
alias ado-pipelines="ado_list_pipelines"
alias ado-run="run_pipeline"