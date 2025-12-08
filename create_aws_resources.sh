#!/bin/bash

# Script to create required AWS resources for Lawsearch project

set -e

echo "=========================================="
echo "Lawsearch - AWS Resources Setup"
echo "=========================================="
echo ""

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Generate unique bucket name
TIMESTAMP=$(date +%s)
BUCKET_NAME="lawsearch-pdf-storage-${TIMESTAMP}"

echo "1. Creating S3 Bucket..."
echo "   Bucket name: ${BUCKET_NAME}"
echo ""

# Create S3 bucket
aws s3 mb s3://${BUCKET_NAME} --region us-east-1

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓${NC} S3 bucket created successfully!"

    # Enable versioning
    echo "   Enabling versioning..."
    aws s3api put-bucket-versioning \
        --bucket ${BUCKET_NAME} \
        --versioning-configuration Status=Enabled \
        --region us-east-1

    # Enable encryption
    echo "   Enabling encryption..."
    aws s3api put-bucket-encryption \
        --bucket ${BUCKET_NAME} \
        --server-side-encryption-configuration '{
            "Rules": [{
                "ApplyServerSideEncryptionByDefault": {
                    "SSEAlgorithm": "AES256"
                }
            }]
        }' \
        --region us-east-1

    # Create folder structure
    echo "   Creating folder structure..."
    aws s3api put-object --bucket ${BUCKET_NAME} --key pdfs/ --region us-east-1
    aws s3api put-object --bucket ${BUCKET_NAME} --key processed/ --region us-east-1

    echo -e "${GREEN}✓${NC} Bucket configured with versioning and encryption"
else
    echo -e "${RED}✗${NC} Failed to create S3 bucket"
    exit 1
fi

echo ""
echo "2. Your S3 Bucket Details:"
echo "   Name: ${BUCKET_NAME}"
echo "   Region: us-east-1"
echo "   Folders: pdfs/, processed/"
echo ""

# Update .env file if it exists
if [ -f ".env" ]; then
    echo "3. Updating .env file..."

    # Check if on macOS or Linux for sed compatibility
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        sed -i '' "s/S3_BUCKET_NAME=.*/S3_BUCKET_NAME=${BUCKET_NAME}/" .env
    else
        # Linux
        sed -i "s/S3_BUCKET_NAME=.*/S3_BUCKET_NAME=${BUCKET_NAME}/" .env
    fi

    echo -e "${GREEN}✓${NC} .env file updated with bucket name"
else
    echo -e "${YELLOW}⚠${NC} .env file not found, skipping update"
fi

echo ""
echo "=========================================="
echo "S3 Setup Complete!"
echo "=========================================="
echo ""
echo "Next steps:"
echo ""
echo "1. Test S3 access:"
echo "   ${YELLOW}aws s3 ls s3://${BUCKET_NAME}/${NC}"
echo ""
echo "2. Create OpenSearch domain (manual step):"
echo "   - Go to AWS Console → OpenSearch"
echo "   - Create domain: 'lawsearch-vectors'"
echo "   - Instance: t3.small.search"
echo "   - Deployment: Development (1 node)"
echo "   - Set master user: admin / [strong password]"
echo "   - Note the endpoint URL"
echo ""
echo "3. Update .env with OpenSearch endpoint"
echo ""
echo "4. Run verification script:"
echo "   ${YELLOW}python3 verify_aws_setup.py${NC}"
echo ""
