#!/usr/bin/env bash

# dbt functions and aliases

# Quick dbt project setup
function dbt_init_project() {
    local project_name="$1"
    local profile_name="${2:-$project_name}"
    
    if [[ -z "$project_name" ]]; then
        echo "Usage: dbt_init_project <project_name> [profile_name]"
        return 1
    fi
    
    echo "🚀 Initializing dbt project: $project_name"
    dbt init "$project_name"
    
    if [[ -d "$project_name" ]]; then
        cd "$project_name"
        echo "✅ Created dbt project: $project_name"
        echo "📝 Next steps:"
        echo "   1. Configure profiles.yml in ~/.dbt/"
        echo "   2. Update dbt_project.yml"
        echo "   3. Run: dbt debug"
    fi
}

# Smart dbt run with options
function dbt_run_smart() {
    local target=""
    local models=""
    local exclude=""
    local full_refresh=false
    
    while [[ $# -gt 0 ]]; do
        case $1 in
            -t|--target)
                target="$2"
                shift 2
                ;;
            -m|--models)
                models="$2"
                shift 2
                ;;
            -e|--exclude)
                exclude="$2"
                shift 2
                ;;
            --full-refresh)
                full_refresh=true
                shift
                ;;
            *)
                echo "Unknown option: $1"
                echo "Usage: dbt_run_smart [-t target] [-m models] [-e exclude] [--full-refresh]"
                return 1
                ;;
        esac
    done
    
    local cmd="dbt run"
    
    if [[ -n "$target" ]]; then
        cmd="$cmd --target $target"
    fi
    
    if [[ -n "$models" ]]; then
        cmd="$cmd --models $models"
    fi
    
    if [[ -n "$exclude" ]]; then
        cmd="$cmd --exclude $exclude"
    fi
    
    if [[ "$full_refresh" == "true" ]]; then
        cmd="$cmd --full-refresh"
    fi
    
    echo "🔄 Running: $cmd"
    eval "$cmd"
}

# dbt test with smart filtering
function dbt_test_smart() {
    local target=""
    local models=""
    local exclude=""
    
    while [[ $# -gt 0 ]]; do
        case $1 in
            -t|--target)
                target="$2"
                shift 2
                ;;
            -m|--models)
                models="$2"
                shift 2
                ;;
            -e|--exclude)
                exclude="$2"
                shift 2
                ;;
            *)
                echo "Unknown option: $1"
                echo "Usage: dbt_test_smart [-t target] [-m models] [-e exclude]"
                return 1
                ;;
        esac
    done
    
    local cmd="dbt test"
    
    if [[ -n "$target" ]]; then
        cmd="$cmd --target $target"
    fi
    
    if [[ -n "$models" ]]; then
        cmd="$cmd --models $models"
    fi
    
    if [[ -n "$exclude" ]]; then
        cmd="$cmd --exclude $exclude"
    fi
    
    echo "🧪 Running: $cmd"
    eval "$cmd"
}

# Complete dbt workflow
function dbt_workflow() {
    local target="${1:-dev}"
    
    echo "🚀 Running complete dbt workflow for target: $target"
    echo
    
    echo "1️⃣ Checking dbt configuration..."
    if ! dbt debug --target "$target"; then
        echo "❌ dbt debug failed"
        return 1
    fi
    
    echo
    echo "2️⃣ Installing dependencies..."
    dbt deps
    
    echo
    echo "3️⃣ Running dbt seed..."
    dbt seed --target "$target"
    
    echo
    echo "4️⃣ Running dbt run..."
    dbt run --target "$target"
    
    echo
    echo "5️⃣ Running dbt test..."
    dbt test --target "$target"
    
    echo
    echo "✅ dbt workflow completed for target: $target"
}

# Generate and serve dbt docs
function dbt_docs_serve() {
    local port="${1:-8080}"
    
    echo "📚 Generating dbt documentation..."
    dbt docs generate
    
    echo "🌐 Serving docs on port $port..."
    echo "   Open: http://localhost:$port"
    dbt docs serve --port "$port"
}

# dbt model lineage for a specific model
function dbt_lineage() {
    local model="$1"
    
    if [[ -z "$model" ]]; then
        echo "Usage: dbt_lineage <model_name>"
        echo "Example: dbt_lineage my_model"
        return 1
    fi
    
    echo "🔍 Showing lineage for model: $model"
    echo
    echo "📥 Upstream dependencies (parents):"
    dbt list --models "+$model" --exclude "$model"
    echo
    echo "📤 Downstream dependencies (children):"
    dbt list --models "$model+"
}

# Fresh data check
function dbt_freshness() {
    local target="${1:-dev}"
    
    echo "🔍 Checking source freshness for target: $target"
    dbt source freshness --target "$target"
}

# Run specific model and its dependencies
function dbt_run_model() {
    local model="$1"
    local target="${2:-dev}"
    
    if [[ -z "$model" ]]; then
        echo "Usage: dbt_run_model <model_name> [target]"
        return 1
    fi
    
    echo "🔄 Running model '$model' and its dependencies on target: $target"
    dbt run --models "+$model" --target "$target"
}

# dbt clean and fresh start
function dbt_clean_start() {
    echo "🧹 Cleaning dbt artifacts..."
    dbt clean
    
    echo "🔄 Fresh dbt run..."
    dbt deps
    dbt run
    dbt test
}

# Show dbt project info
function dbt_info() {
    echo "📊 dbt Project Information"
    echo "=========================="
    
    if [[ -f "dbt_project.yml" ]]; then
        echo "📁 Project Name: $(grep '^name:' dbt_project.yml | cut -d' ' -f2)"
        echo "📋 dbt Version: $(grep '^require-dbt-version:' dbt_project.yml | cut -d' ' -f2 || echo 'Not specified')"
        echo "🎯 Profile: $(grep '^profile:' dbt_project.yml | cut -d' ' -f2)"
        echo
        
        echo "📂 Model Paths:"
        find . -name "*.sql" -path "*/models/*" | head -10
        if [[ $(find . -name "*.sql" -path "*/models/*" | wc -l) -gt 10 ]]; then
            echo "   ... and $(( $(find . -name "*.sql" -path "*/models/*" | wc -l) - 10 )) more"
        fi
        echo
        
        echo "🧪 Test Files:"
        find . -name "*.yml" -path "*/models/*" | head -5
        echo
    else
        echo "❌ Not in a dbt project directory (no dbt_project.yml found)"
    fi
    
    echo "🎯 Available targets:"
    if [[ -f ~/.dbt/profiles.yml ]]; then
        grep -A 20 "^$(grep '^profile:' dbt_project.yml | cut -d' ' -f2 2>/dev/null || echo 'default'):" ~/.dbt/profiles.yml | grep "^  [a-zA-Z]" | cut -d':' -f1 | sed 's/^  /   /'
    else
        echo "   No profiles.yml found"
    fi
}

# Quick model compilation check
function dbt_compile_check() {
    local model="$1"
    
    if [[ -n "$model" ]]; then
        echo "🔍 Compiling model: $model"
        dbt compile --models "$model"
    else
        echo "🔍 Compiling all models..."
        dbt compile
    fi
}

# dbt aliases for common commands
alias dbtd="dbt debug"
alias dbtr="dbt run"
alias dbtt="dbt test"
alias dbts="dbt seed"
alias dbtc="dbt compile"
alias dbtcl="dbt clean"
alias dbtdep="dbt deps"
alias dbtdocs="dbt docs generate && dbt docs serve"
alias dbtls="dbt list"

# Enhanced aliases with common options
alias dbtrd="dbt run --target dev"
alias dbtrp="dbt run --target prod"
alias dbtrs="dbt run --target staging"
alias dbttd="dbt test --target dev"
alias dbtttp="dbt test --target prod"
alias dbtts="dbt test --target staging"

# Quick development aliases
alias dbtdev="dbt_workflow dev"
alias dbtstg="dbt_workflow staging" 
alias dbtprod="dbt_workflow prod"
alias dbtinfo="dbt_info"
alias dbtfresh="dbt_freshness"
alias dbtclean="dbt_clean_start"

# dbt with common model selections
alias dbtchanged="dbt run --models state:modified --defer --state target"
alias dbtnew="dbt run --models state:new --defer --state target"