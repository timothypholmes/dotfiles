#!/usr/bin/env bash

# AWS functions and aliases

# Update AWS credentials from clipboard
function aws_update_credentials() {
    local profile_name="$1"
    local credentials_file="$HOME/.aws/credentials"
    
    if [[ -z "$profile_name" ]]; then
        echo "Usage: aws_update_credentials <profile_name>"
        echo "Example: aws_update_credentials dev_something"
        echo ""
        echo "This will look for [*_dev_something] in your clipboard and update those credentials"
        return 1
    fi
    
    # Get clipboard content
    local clipboard_content
    if command -v pbpaste >/dev/null 2>&1; then
        clipboard_content=$(pbpaste)
    elif command -v xclip >/dev/null 2>&1; then
        clipboard_content=$(xclip -selection clipboard -o)
    else
        echo "Error: No clipboard utility found (pbpaste or xclip)"
        return 1
    fi
    
    # Find the profile section in clipboard
    local profile_section
    profile_section=$(echo "$clipboard_content" | grep -A 20 "\[.*${profile_name}\]" | head -20)
    
    if [[ -z "$profile_section" ]]; then
        echo "Error: Could not find profile matching '*${profile_name}' in clipboard"
        echo "Looking for pattern: [*${profile_name}]"
        echo ""
        echo "Available profiles in clipboard:"
        echo "$clipboard_content" | grep "^\[.*\]" || echo "No profiles found"
        return 1
    fi
    
    # Extract the exact profile name from the section
    local exact_profile_name
    exact_profile_name=$(echo "$profile_section" | head -1 | sed 's/^\[\(.*\)\]$/\1/')
    
    echo "Found profile: [$exact_profile_name]"
    
    # Create credentials file if it doesn't exist
    mkdir -p "$(dirname "$credentials_file")"
    touch "$credentials_file"
    
    # Remove existing profile section if it exists
    if grep -q "^\[$exact_profile_name\]" "$credentials_file"; then
        echo "Updating existing profile..."
        # Use awk to remove the old profile section
        awk -v profile="$exact_profile_name" '
        /^\[/ { in_target = ($0 == "[" profile "]") }
        !in_target || /^\[/ && !($0 == "[" profile "]") { print }
        /^\[/ && ($0 == "[" profile "]") { in_target = 1 }
        ' "$credentials_file" > "${credentials_file}.tmp" && mv "${credentials_file}.tmp" "$credentials_file"
    else
        echo "Adding new profile..."
    fi
    
    # Add the new profile section
    echo "$profile_section" >> "$credentials_file"
    
    echo "✅ AWS credentials updated for profile: $exact_profile_name"
    echo "You can now use: aws --profile $exact_profile_name <command>"
    
    # Set as default profile if requested
    read -p "Set this as your default AWS profile? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        export AWS_PROFILE="$exact_profile_name"
        echo "export AWS_PROFILE=\"$exact_profile_name\"" > "$HOME/.aws_current_profile"
        echo "✅ Set $exact_profile_name as default profile for this session"
        echo "Add 'source ~/.aws_current_profile' to your shell config to persist"
    fi
}

# Quick credential update (searches for common patterns)
function aws_quick_update() {
    echo "Scanning clipboard for AWS credentials..."
    
    # Get clipboard content
    local clipboard_content
    if command -v pbpaste >/dev/null 2>&1; then
        clipboard_content=$(pbpaste)
    elif command -v xclip >/dev/null 2>&1; then
        clipboard_content=$(xclip -selection clipboard -o)
    else
        echo "Error: No clipboard utility found"
        return 1
    fi
    
    # Find all profile sections
    local profiles
    profiles=$(echo "$clipboard_content" | grep "^\[.*\]" | sed 's/^\[\(.*\)\]$/\1/')
    
    if [[ -z "$profiles" ]]; then
        echo "No AWS profiles found in clipboard"
        return 1
    fi
    
    echo "Found profiles:"
    echo "$profiles" | nl
    echo
    
    read -p "Enter the number of the profile to update (or 'q' to quit): " choice
    
    if [[ "$choice" == "q" ]]; then
        return 0
    fi
    
    local selected_profile
    selected_profile=$(echo "$profiles" | sed -n "${choice}p")
    
    if [[ -z "$selected_profile" ]]; then
        echo "Invalid selection"
        return 1
    fi
    
    aws_update_credentials "$selected_profile"
}

# List AWS profiles
function aws_list_profiles() {
    if [[ -f "$HOME/.aws/credentials" ]]; then
        echo "Available AWS profiles:"
        grep "^\[.*\]" "$HOME/.aws/credentials" | sed 's/^\[\(.*\)\]$/  \1/'
    else
        echo "No AWS credentials file found"
    fi
}

# Switch AWS profile
function aws_switch_profile() {
    local profile="$1"
    
    if [[ -z "$profile" ]]; then
        aws_list_profiles
        echo
        read -p "Enter profile name: " profile
    fi
    
    if [[ -n "$profile" ]]; then
        export AWS_PROFILE="$profile"
        echo "export AWS_PROFILE=\"$profile\"" > "$HOME/.aws_current_profile"
        echo "✅ Switched to AWS profile: $profile"
    fi
}

# Show current AWS profile and identity
function aws_whoami() {
    echo "Current AWS Profile: ${AWS_PROFILE:-default}"
    if command -v aws >/dev/null 2>&1; then
        echo "AWS Identity:"
        aws sts get-caller-identity 2>/dev/null || echo "  Not authenticated or invalid credentials"
    else
        echo "AWS CLI not installed"
    fi
}

# AWS region helpers
function aws_set_region() {
    local region="$1"
    
    if [[ -z "$region" ]]; then
        echo "Usage: aws_set_region <region>"
        echo "Common regions: us-east-1, us-west-2, eu-west-1, ap-southeast-1"
        return 1
    fi
    
    export AWS_DEFAULT_REGION="$region"
    echo "✅ Set AWS region to: $region"
}

function aws_show_region() {
    echo "Current AWS Region: ${AWS_DEFAULT_REGION:-not set}"
}

# EC2 helpers
function aws_list_instances() {
    aws ec2 describe-instances \
        --query 'Reservations[*].Instances[*].[InstanceId,State.Name,InstanceType,Tags[?Key==`Name`].Value|[0]]' \
        --output table
}

function aws_start_instance() {
    local instance_id="$1"
    if [[ -z "$instance_id" ]]; then
        echo "Usage: aws_start_instance <instance-id>"
        return 1
    fi
    aws ec2 start-instances --instance-ids "$instance_id"
}

function aws_stop_instance() {
    local instance_id="$1"
    if [[ -z "$instance_id" ]]; then
        echo "Usage: aws_stop_instance <instance-id>"
        return 1
    fi
    aws ec2 stop-instances --instance-ids "$instance_id"
}

# S3 helpers
function aws_list_buckets() {
    aws s3 ls
}

function aws_bucket_size() {
    local bucket="$1"
    if [[ -z "$bucket" ]]; then
        echo "Usage: aws_bucket_size <bucket-name>"
        return 1
    fi
    aws s3api list-objects --bucket "$bucket" --output json --query '[sum(Contents[].Size), length(Contents[])]'
}

# Lambda helpers
function aws_list_functions() {
    aws lambda list-functions --query 'Functions[*].[FunctionName,Runtime,LastModified]' --output table
}

function aws_invoke_function() {
    local function_name="$1"
    local payload="$2"
    
    if [[ -z "$function_name" ]]; then
        echo "Usage: aws_invoke_function <function-name> [payload]"
        return 1
    fi
    
    if [[ -n "$payload" ]]; then
        aws lambda invoke --function-name "$function_name" --payload "$payload" response.json
    else
        aws lambda invoke --function-name "$function_name" response.json
    fi
    
    cat response.json && rm response.json
}

# AWS aliases
alias awsp="aws_switch_profile"
alias awswho="aws_whoami"
alias awsls="aws_list_profiles"
alias awsup="aws_quick_update"
alias awscreds="aws_update_credentials"

# EC2 aliases
alias ec2ls="aws_list_instances"
alias ec2start="aws_start_instance"
alias ec2stop="aws_stop_instance"

# S3 aliases
alias s3ls="aws_list_buckets"
alias s3size="aws_bucket_size"

# Lambda aliases
alias lambdals="aws_list_functions"
alias lambdainvoke="aws_invoke_function"

# Region aliases
alias awsregion="aws_show_region"
alias awssetregion="aws_set_region"

# ============================================================================
# AWS SAM (Serverless Application Model) Functions
# ============================================================================

# Initialize new SAM application
function sam_init_app() {
    local app_name="$1"
    local runtime="${2:-python3.9}"
    local template="${3:-hello-world}"
    
    if [[ -z "$app_name" ]]; then
        echo "Usage: sam_init_app <app_name> [runtime] [template]"
        echo "Runtimes: python3.9, python3.8, nodejs18.x, java11, dotnet6, go1.x"
        echo "Templates: hello-world, quick-start-web, quick-start-cloudformation"
        return 1
    fi
    
    echo "🚀 Creating SAM application: $app_name"
    echo "   Runtime: $runtime"
    echo "   Template: $template"
    
    sam init --name "$app_name" --runtime "$runtime" --app-template "$template" --no-interactive
    
    if [[ -d "$app_name" ]]; then
        cd "$app_name"
        echo "✅ SAM application created successfully!"
        echo "📁 Directory: $(pwd)"
        echo ""
        echo "Next steps:"
        echo "  sam build                    # Build the application"
        echo "  sam local start-api          # Start local API"
        echo "  sam local invoke             # Test function locally"
        echo "  sam deploy --guided          # Deploy to AWS"
    fi
}

# Build SAM application
function sam_build_app() {
    local use_container="${1:-false}"
    
    if [[ ! -f "template.yaml" && ! -f "template.yml" ]]; then
        echo "❌ No SAM template found in current directory"
        return 1
    fi
    
    echo "🔨 Building SAM application..."
    
    if [[ "$use_container" == "true" || "$use_container" == "--use-container" ]]; then
        echo "   Using container for build..."
        sam build --use-container
    else
        sam build
    fi
    
    if [[ $? -eq 0 ]]; then
        echo "✅ Build completed successfully!"
        echo "📦 Artifacts in .aws-sam/build/"
    else
        echo "❌ Build failed"
        return 1
    fi
}

# Start SAM local API
function sam_start_api() {
    local port="${1:-3000}"
    local host="${2:-127.0.0.1}"
    
    if [[ ! -d ".aws-sam/build" ]]; then
        echo "🔨 No build found, building first..."
        sam_build_app
    fi
    
    echo "🌐 Starting SAM local API..."
    echo "   URL: http://$host:$port"
    echo "   Press Ctrl+C to stop"
    echo ""
    
    sam local start-api --port "$port" --host "$host"
}

# Invoke SAM function locally
function sam_invoke_local() {
    local function_name="$1"
    local event_file="$2"
    
    if [[ -z "$function_name" ]]; then
        echo "Usage: sam_invoke_local <function_name> [event_file]"
        echo ""
        echo "Available functions:"
        sam list functions --output table 2>/dev/null || echo "Run 'sam build' first"
        return 1
    fi
    
    if [[ ! -d ".aws-sam/build" ]]; then
        echo "🔨 No build found, building first..."
        sam_build_app
    fi
    
    local cmd="sam local invoke $function_name"
    
    if [[ -n "$event_file" ]]; then
        if [[ -f "$event_file" ]]; then
            cmd="$cmd --event $event_file"
        else
            echo "❌ Event file not found: $event_file"
            return 1
        fi
    fi
    
    echo "⚡ Invoking function: $function_name"
    if [[ -n "$event_file" ]]; then
        echo "   Event file: $event_file"
    fi
    echo ""
    
    eval "$cmd"
}

# Generate SAM event templates
function sam_generate_event() {
    local event_type="$1"
    local output_file="$2"
    
    if [[ -z "$event_type" ]]; then
        echo "Usage: sam_generate_event <event_type> [output_file]"
        echo ""
        echo "Common event types:"
        echo "  apigateway     # API Gateway event"
        echo "  s3             # S3 event"
        echo "  dynamodb       # DynamoDB event"
        echo "  cloudwatch     # CloudWatch event"
        echo "  sns            # SNS event"
        echo "  sqs            # SQS event"
        return 1
    fi
    
    local cmd="sam local generate-event $event_type"
    
    if [[ -n "$output_file" ]]; then
        echo "📄 Generating $event_type event template to: $output_file"
        eval "$cmd" > "$output_file"
        echo "✅ Event template saved!"
    else
        echo "📄 $event_type event template:"
        eval "$cmd"
    fi
}

# SAM deploy with environment
function sam_deploy_env() {
    local env="${1:-dev}"
    local guided="${2:-false}"
    
    if [[ ! -f "template.yaml" && ! -f "template.yml" ]]; then
        echo "❌ No SAM template found"
        return 1
    fi
    
    echo "🚀 Deploying SAM application to environment: $env"
    
    local cmd="sam deploy"
    
    if [[ "$guided" == "true" || "$guided" == "--guided" ]]; then
        cmd="$cmd --guided"
    else
        cmd="$cmd --stack-name sam-app-$env --s3-bucket sam-deployments-$env --capabilities CAPABILITY_IAM"
    fi
    
    # Add environment-specific parameters
    case "$env" in
        "dev")
            cmd="$cmd --parameter-overrides Environment=dev LogLevel=DEBUG"
            ;;
        "staging")
            cmd="$cmd --parameter-overrides Environment=staging LogLevel=INFO"
            ;;
        "prod")
            cmd="$cmd --parameter-overrides Environment=prod LogLevel=WARN"
            ;;
    esac
    
    eval "$cmd"
}

# ============================================================================
# AWS Glue Functions
# ============================================================================

# Create Glue job locally for testing
function glue_create_local_job() {
    local job_name="$1"
    local job_type="${2:-pythonshell}"
    
    if [[ -z "$job_name" ]]; then
        echo "Usage: glue_create_local_job <job_name> [job_type]"
        echo "Job types: glueetl, pythonshell, streaming"
        return 1
    fi
    
    mkdir -p "glue-jobs/$job_name"
    cd "glue-jobs/$job_name"
    
    # Create main job script
    cat > "${job_name}.py" << EOF
import sys
from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job

## @params: [JOB_NAME]
args = getResolvedOptions(sys.argv, ['JOB_NAME'])

sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)
job.init(args['JOB_NAME'], args)

# Your Glue job logic here
print(f"Starting Glue job: {args['JOB_NAME']}")

# Example: Read from S3
# datasource0 = glueContext.create_dynamic_frame.from_catalog(
#     database="your_database",
#     table_name="your_table"
# )

# Example: Transform data
# transformed_data = ApplyMapping.apply(
#     frame=datasource0,
#     mappings=[
#         ("old_column", "string", "new_column", "string")
#     ]
# )

# Example: Write to S3
# glueContext.write_dynamic_frame.from_options(
#     frame=transformed_data,
#     connection_type="s3",
#     connection_options={"path": "s3://your-bucket/output/"},
#     format="parquet"
# )

print("Glue job completed successfully!")
job.commit()
EOF

    # Create local test script
    cat > "test_local.py" << EOF
#!/usr/bin/env python3
"""
Local test script for Glue job: $job_name
Run this to test your Glue logic locally without AWS dependencies
"""

import sys
import os

def mock_glue_context():
    """Mock Glue context for local testing"""
    class MockGlueContext:
        def __init__(self):
            self.spark_session = None
            
        def create_dynamic_frame_from_options(self, connection_type, connection_options, format_options=None):
            print(f"Mock: Reading from {connection_type} with options: {connection_options}")
            # Return mock data or read from local files
            return None
            
        def write_dynamic_frame_from_options(self, frame, connection_type, connection_options, format_options=None):
            print(f"Mock: Writing to {connection_type} with options: {connection_options}")
            
    return MockGlueContext()

def test_job_logic():
    """Test your job logic here"""
    print(f"Testing Glue job: $job_name")
    
    # Mock the Glue environment
    glueContext = mock_glue_context()
    
    # Test your transformations here
    print("Add your test logic here...")
    
    print("Local test completed!")

if __name__ == "__main__":
    test_job_logic()
EOF

    # Create requirements file
    cat > "requirements.txt" << EOF
# Local testing dependencies
pandas
pyarrow
pytest
boto3
EOF

    # Create Dockerfile for Glue development
    cat > "Dockerfile" << EOF
FROM amazon/aws-glue-libs:glue_libs_4.0.0_image_01

# Install additional dependencies
COPY requirements.txt .
RUN pip install -r requirements.txt

# Copy job files
COPY . /home/glue_user/workspace/

WORKDIR /home/glue_user/workspace/

# Default command
CMD ["python3", "${job_name}.py"]
EOF

    chmod +x "test_local.py"
    
    echo "✅ Glue job '$job_name' created successfully!"
    echo "📁 Directory: $(pwd)"
    echo ""
    echo "Files created:"
    echo "  ${job_name}.py     # Main Glue job script"
    echo "  test_local.py      # Local testing script"
    echo "  requirements.txt   # Python dependencies"
    echo "  Dockerfile         # Container for testing"
    echo ""
    echo "Next steps:"
    echo "  python3 test_local.py               # Test locally"
    echo "  glue_test_job $job_name              # Test with Glue container"
    echo "  glue_deploy_job $job_name            # Deploy to AWS"
}

# Test Glue job locally with Docker
function glue_test_job() {
    local job_name="$1"
    
    if [[ -z "$job_name" ]]; then
        echo "Usage: glue_test_job <job_name>"
        return 1
    fi
    
    if [[ ! -d "glue-jobs/$job_name" ]]; then
        echo "❌ Glue job directory not found: glue-jobs/$job_name"
        return 1
    fi
    
    cd "glue-jobs/$job_name"
    
    echo "🐳 Testing Glue job with Docker..."
    echo "   Job: $job_name"
    
    # Build the container
    docker build -t "glue-job-$job_name" .
    
    # Run the job
    docker run --rm -v "$(pwd)":/home/glue_user/workspace/ "glue-job-$job_name" python3 "test_local.py"
}

# Deploy Glue job to AWS
function glue_deploy_job() {
    local job_name="$1"
    local s3_bucket="$2"
    local role_arn="$3"
    
    if [[ -z "$job_name" || -z "$s3_bucket" || -z "$role_arn" ]]; then
        echo "Usage: glue_deploy_job <job_name> <s3_bucket> <role_arn>"
        echo "Example: glue_deploy_job my_job my-glue-scripts-bucket arn:aws:iam::123456789012:role/GlueServiceRole"
        return 1
    fi
    
    if [[ ! -f "glue-jobs/$job_name/${job_name}.py" ]]; then
        echo "❌ Glue job script not found: glue-jobs/$job_name/${job_name}.py"
        return 1
    fi
    
    echo "🚀 Deploying Glue job: $job_name"
    echo "   S3 Bucket: $s3_bucket"
    echo "   Role: $role_arn"
    
    # Upload script to S3
    aws s3 cp "glue-jobs/$job_name/${job_name}.py" "s3://$s3_bucket/scripts/${job_name}.py"
    
    # Create or update the Glue job
    aws glue create-job \
        --name "$job_name" \
        --role "$role_arn" \
        --command '{
            "Name": "glueetl",
            "ScriptLocation": "s3://'$s3_bucket'/scripts/'$job_name'.py"
        }' \
        --default-arguments '{
            "--TempDir": "s3://'$s3_bucket'/temp/",
            "--job-bookmark-option": "job-bookmark-enable",
            "--enable-metrics": ""
        }' \
        --max-retries 1 \
        --timeout 60 \
        --glue-version "4.0" \
        --number-of-workers 2 \
        --worker-type "G.1X"
    
    echo "✅ Glue job deployed successfully!"
}

# Run Glue job
function glue_run_job() {
    local job_name="$1"
    local wait_for_completion="${2:-false}"
    
    if [[ -z "$job_name" ]]; then
        echo "Usage: glue_run_job <job_name> [wait]"
        return 1
    fi
    
    echo "🔄 Starting Glue job: $job_name"
    
    local job_run_id=$(aws glue start-job-run --job-name "$job_name" --query 'JobRunId' --output text)
    
    if [[ -n "$job_run_id" ]]; then
        echo "✅ Job started with run ID: $job_run_id"
        
        if [[ "$wait_for_completion" == "true" || "$wait_for_completion" == "wait" ]]; then
            echo "⏳ Waiting for job completion..."
            aws glue wait job-run-completed --job-name "$job_name" --run-id "$job_run_id"
            echo "✅ Job completed!"
            
            # Show final status
            aws glue get-job-run --job-name "$job_name" --run-id "$job_run_id" --query 'JobRun.JobRunState' --output text
        fi
    else
        echo "❌ Failed to start job"
        return 1
    fi
}

# List Glue jobs
function glue_list_jobs() {
    echo "📋 AWS Glue Jobs:"
    aws glue get-jobs --query 'Jobs[*].[Name,CreatedOn,LastModifiedOn]' --output table
}

# SAM aliases
alias saminit="sam_init_app"
alias sambuild="sam_build_app"
alias samapi="sam_start_api"
alias saminvoke="sam_invoke_local"
alias samevent="sam_generate_event"
alias samdeploy="sam_deploy_env"

# Glue aliases  
alias gluecreate="glue_create_local_job"
alias gluetest="glue_test_job"
alias gluedeploy="glue_deploy_job"
alias gluerun="glue_run_job"
alias gluelist="glue_list_jobs"