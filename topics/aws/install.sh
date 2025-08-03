#!/usr/bin/env bash

# AWS topic installer

# Install AWS CLI if not already installed
if ! command -v aws &> /dev/null; then
    echo "Installing AWS CLI..."
    if command -v brew &> /dev/null; then
        brew install awscli
    else
        echo "Please install AWS CLI manually:"
        echo "https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html"
    fi
else
    echo "AWS CLI already installed"
fi

# Create AWS config directory
mkdir -p "$HOME/.aws"

# Create basic config file if it doesn't exist
if [[ ! -f "$HOME/.aws/config" ]]; then
    echo "Creating basic AWS config..."
    cat > "$HOME/.aws/config" << 'EOF'
[default]
region = us-east-1
output = json

# Add more profiles as needed
# [profile dev]
# region = us-east-1
# output = table

# [profile prod]
# region = us-west-2
# output = json
EOF
fi

# Create credentials file if it doesn't exist
if [[ ! -f "$HOME/.aws/credentials" ]]; then
    echo "Creating empty AWS credentials file..."
    touch "$HOME/.aws/credentials"
    chmod 600 "$HOME/.aws/credentials"
fi

# Install additional AWS tools
if command -v brew &> /dev/null; then
    echo "Installing additional AWS tools..."
    brew install awscli-session-manager || echo "Session Manager plugin already installed or not available"
    brew install aws-iam-authenticator || echo "IAM Authenticator already installed or not available"
fi

# Install AWS SAM CLI
if ! command -v sam &> /dev/null; then
    echo "Installing AWS SAM CLI..."
    if command -v brew &> /dev/null; then
        brew install aws-sam-cli
    else
        echo "Please install AWS SAM CLI manually:"
        echo "https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/install-sam-cli.html"
    fi
else
    echo "AWS SAM CLI already installed"
fi

echo "AWS setup complete!"
echo ""
echo "Usage:"
echo "  aws_update_credentials <profile_name>  - Update credentials from clipboard"
echo "  aws_quick_update                       - Interactive credential update"
echo "  awsp <profile>                         - Switch AWS profile"
echo "  awswho                                 - Show current AWS identity"
echo "  awsls                                  - List available profiles"
echo ""
echo "SAM Functions:"
echo "  saminit <app_name>                     - Create new SAM application"
echo "  sambuild                               - Build SAM application"
echo "  samapi [port]                          - Start local API (default: 3000)"
echo "  saminvoke <function> [event_file]      - Invoke function locally"
echo "  samevent <type> [output_file]          - Generate event templates"
echo ""
echo "Glue Functions:"
echo "  gluecreate <job_name>                  - Create Glue job with local testing"
echo "  gluetest <job_name>                    - Test Glue job with Docker"
echo "  gluedeploy <job> <bucket> <role>       - Deploy job to AWS"
echo "  gluerun <job_name> [wait]              - Run Glue job"