#!/bin/bash

# Script to create IAM policy and attach to your current user
# This will give your user the necessary permissions for Bedrock, S3, and OpenSearch

echo "Creating IAM policy for Lawsearch project..."
echo ""

# Get current AWS user
CURRENT_USER=$(aws sts get-caller-identity --query 'Arn' --output text | cut -d'/' -f2)
echo "Current AWS user: $CURRENT_USER"
echo ""

# Create the policy document
cat > /tmp/lawsearch-policy.json << 'EOF'
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "BedrockAccess",
            "Effect": "Allow",
            "Action": [
                "bedrock:InvokeModel",
                "bedrock:InvokeModelWithResponseStream",
                "bedrock:ListFoundationModels",
                "bedrock:GetFoundationModel"
            ],
            "Resource": "*"
        },
        {
            "Sid": "S3Access",
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:GetObject",
                "s3:DeleteObject",
                "s3:ListBucket",
                "s3:CreateBucket",
                "s3:ListAllMyBuckets"
            ],
            "Resource": [
                "arn:aws:s3:::lawsearch-*",
                "arn:aws:s3:::lawsearch-*/*"
            ]
        },
        {
            "Sid": "OpenSearchAccess",
            "Effect": "Allow",
            "Action": [
                "es:*",
                "opensearch:*"
            ],
            "Resource": "*"
        }
    ]
}
EOF

echo "Creating policy..."
POLICY_ARN=$(aws iam create-policy \
    --policy-name LawsearchBedrockFullPolicy \
    --policy-document file:///tmp/lawsearch-policy.json \
    --query 'Policy.Arn' \
    --output text 2>/dev/null)

if [ $? -eq 0 ]; then
    echo "✓ Policy created: $POLICY_ARN"
else
    echo "Policy may already exist, trying to get existing ARN..."
    ACCOUNT_ID=$(aws sts get-caller-identity --query 'Account' --output text)
    POLICY_ARN="arn:aws:iam::${ACCOUNT_ID}:policy/LawsearchBedrockFullPolicy"
    echo "Using policy: $POLICY_ARN"
fi

echo ""
echo "Attaching policy to user: $CURRENT_USER"
aws iam attach-user-policy \
    --user-name "$CURRENT_USER" \
    --policy-arn "$POLICY_ARN"

if [ $? -eq 0 ]; then
    echo "✓ Policy attached successfully!"
    echo ""
    echo "IMPORTANT: Wait 30 seconds for IAM changes to propagate..."
    sleep 5
    echo "Please wait... (25 seconds remaining)"
    sleep 10
    echo "Please wait... (15 seconds remaining)"
    sleep 10
    echo "Please wait... (5 seconds remaining)"
    sleep 5
    echo ""
    echo "✓ Done! You can now test your AWS access."
else
    echo "✗ Failed to attach policy. You may need administrator permissions."
    echo "  Ask your AWS administrator to attach the policy, or run this with admin credentials."
fi

# Cleanup
rm /tmp/lawsearch-policy.json

echo ""
echo "Next steps:"
echo "1. Test Bedrock access: aws bedrock list-foundation-models --region us-east-1 --query 'modelSummaries[?contains(modelId, \`nova\`)].modelId'"
echo "2. Create S3 bucket (see below)"
echo "3. Create OpenSearch domain (see AWS console)"
