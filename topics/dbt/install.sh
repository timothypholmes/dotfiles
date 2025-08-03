#!/usr/bin/env bash

# dbt topic installer

echo "Installing dbt and related tools..."

# Install dbt-core and common adapters
if command -v pip3 >/dev/null 2>&1; then
    echo "Installing dbt-core..."
    pip3 install --user dbt-core
    
    echo "Installing common dbt adapters..."
    # Install based on your data warehouse - uncomment what you need
    # pip3 install --user dbt-snowflake
    # pip3 install --user dbt-bigquery  
    # pip3 install --user dbt-redshift
    # pip3 install --user dbt-postgres
    # pip3 install --user dbt-databricks
    # pip3 install --user dbt-duckdb
    
    echo "Installing dbt development tools..."
    pip3 install --user dbt-checkpoint
    pip3 install --user sqlfluff
else
    echo "pip3 not found. Please install Python 3 and pip3 first."
    return 1
fi

# Create dbt profiles directory
mkdir -p "$HOME/.dbt"

# Create a template profiles.yml if it doesn't exist
if [[ ! -f "$HOME/.dbt/profiles.yml" ]]; then
    echo "Creating template profiles.yml..."
    cat > "$HOME/.dbt/profiles.yml" << 'EOF'
# dbt profiles.yml template
# Update with your actual database credentials

default:
  outputs:
    dev:
      type: postgres  # Change to your adapter: snowflake, bigquery, redshift, etc.
      host: localhost
      user: your_username
      password: your_password
      port: 5432
      dbname: your_dev_database
      schema: your_schema
      
    staging:
      type: postgres
      host: your_staging_host
      user: your_username
      password: your_password
      port: 5432
      dbname: your_staging_database
      schema: your_schema
      
    prod:
      type: postgres
      host: your_prod_host
      user: your_username
      password: your_password
      port: 5432
      dbname: your_prod_database
      schema: your_schema
      
  target: dev
EOF
    chmod 600 "$HOME/.dbt/profiles.yml"
    echo "✅ Created template profiles.yml at ~/.dbt/profiles.yml"
    echo "⚠️  Please update it with your actual database credentials"
fi

# Install pre-commit hooks for dbt projects (optional)
if command -v pre-commit >/dev/null 2>&1; then
    echo "pre-commit is available for dbt project hooks"
else
    echo "Installing pre-commit for dbt project quality checks..."
    pip3 install --user pre-commit
fi

echo "📚 dbt setup complete!"
echo ""
echo "Next steps:"
echo "1. Update ~/.dbt/profiles.yml with your database credentials"
echo "2. Install your specific dbt adapter (e.g., dbt-snowflake, dbt-bigquery)"
echo "3. Run 'dbt_init_project my_project' to create a new dbt project"
echo "4. Run 'dbt debug' to test your connection"
echo ""
echo "Available commands:"
echo "  dbt_workflow [target]     - Run complete dbt workflow"
echo "  dbt_docs_serve [port]     - Generate and serve documentation"
echo "  dbt_info                  - Show project information"
echo "  dbtdev                    - Quick dev workflow"
echo "  dbtr                      - dbt run"
echo "  dbtt                      - dbt test"