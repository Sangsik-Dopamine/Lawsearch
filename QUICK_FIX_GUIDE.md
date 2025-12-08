# Quick Fix Guide - IAM Permissions Issue

## Problem Summary

Your AWS user `sangsik` (ARN: `arn:aws:iam::839950285553:user/sangsik`) doesn't have the necessary permissions to access Bedrock, S3, and OpenSearch.

---

## Solution (Choose One)

### Option A: Automated Fix (Recommended)

Run the automated script to add permissions to your current user:

```bash
cd /home/user/Lawsearch
./fix_iam_permissions.sh
```

This will:
- ✅ Create an IAM policy with Bedrock, S3, and OpenSearch permissions
- ✅ Attach it to your current user `sangsik`
- ✅ Wait for IAM changes to propagate

**Note:** You need to be logged in with administrator credentials or have `iam:CreatePolicy` and `iam:AttachUserPolicy` permissions.

---

### Option B: Manual Fix via AWS Console

If you don't have IAM permissions to run the script, follow these steps:

1. **Log in to AWS Console** with administrator account

2. **Go to IAM** → Users → `sangsik`

3. **Click "Add permissions"** → "Attach policies directly"

4. **Create inline policy** with this JSON:

```json
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
                "s3:*"
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
```

5. **Name the policy**: `LawsearchBedrockPolicy`

6. **Click "Create policy"**

7. **Wait 30 seconds** for IAM changes to propagate

---

## After Fixing Permissions

### Step 1: Verify Bedrock Access

```bash
aws bedrock list-foundation-models \
  --region us-east-1 \
  --query 'modelSummaries[?contains(modelId, `nova`)].modelId'
```

Expected output:
```json
[
    "amazon.nova-pro-v1:0",
    "amazon.nova-lite-v1:0",
    "amazon.nova-micro-v1:0"
]
```

---

### Step 2: Create S3 Bucket

Run the automated script:

```bash
cd /home/user/Lawsearch
./create_aws_resources.sh
```

Or manually:

```bash
# Create bucket with unique name
BUCKET_NAME="lawsearch-pdf-storage-$(date +%s)"
aws s3 mb s3://${BUCKET_NAME} --region us-east-1

# Enable versioning
aws s3api put-bucket-versioning \
  --bucket ${BUCKET_NAME} \
  --versioning-configuration Status=Enabled \
  --region us-east-1

# Test access
aws s3 ls s3://${BUCKET_NAME}/
```

**Save your bucket name!** You'll need it for the `.env` file.

---

### Step 3: Create OpenSearch Domain (Manual - AWS Console)

This must be done via AWS Console (takes 10-15 minutes):

1. **Go to AWS Console** → OpenSearch Service

2. **Click "Create domain"**

3. **Configuration:**
   - Domain name: `lawsearch-vectors`
   - Deployment type: **Development and testing**
   - Version: Latest (2.11 or higher)
   - Data nodes:
     - Instance: `t3.small.search`
     - Nodes: 1
   - Network: **Public access**
   - Fine-grained access control: **Enable**
     - Master user: `admin`
     - Password: Choose a strong password (save it!)
   - Access policy: "Only use fine-grained access control"

4. **Click "Create"** (wait 10-15 minutes)

5. **Copy the endpoint URL** (looks like: `https://lawsearch-vectors-xxxxx.us-east-1.es.amazonaws.com`)

---

### Step 4: Update .env File

Edit your `.env` file with the actual values:

```bash
nano .env
```

Update these lines:
```
S3_BUCKET_NAME=lawsearch-pdf-storage-1234567890  # Your actual bucket name
OPENSEARCH_ENDPOINT=https://your-actual-endpoint.us-east-1.es.amazonaws.com
OPENSEARCH_PASSWORD=your-actual-password
```

---

### Step 5: Run Verification

```bash
cd /home/user/Lawsearch
source venv/bin/activate  # If not already activated
python3 verify_aws_setup.py
```

Expected output:
```
✓ AWS credentials found
✓ Bedrock API access successful
✓ Nova Pro model found
✓ S3 access successful
✓ OpenSearch domain found
✓ Nova Pro inference successful

🎉 All checks passed!
```

---

## Common Errors Fixed

### Error 1: AccessDeniedException
**Cause:** Missing IAM permissions
**Fix:** Run `fix_iam_permissions.sh` or add policy manually

### Error 2: "zsh: no matches found"
**Cause:** Shell is interpreting brackets `[` `]` in command
**Fix:** Don't copy the example commands with brackets - use actual values

### Error 3: S3 bucket not found
**Cause:** Bucket doesn't exist yet
**Fix:** Run `create_aws_resources.sh` or create manually

### Error 4: OpenSearch not found
**Cause:** Domain hasn't been created
**Fix:** Create via AWS Console (takes 10-15 minutes)

---

## Quick Command Reference

```bash
# Fix IAM permissions
./fix_iam_permissions.sh

# Create S3 bucket
./create_aws_resources.sh

# Test Bedrock
aws bedrock list-foundation-models --region us-east-1

# Test S3 (replace with your bucket name)
aws s3 ls s3://lawsearch-pdf-storage-YOURNAME/

# Check OpenSearch
aws opensearch describe-domain --domain-name lawsearch-vectors --region us-east-1

# Run full verification
python3 verify_aws_setup.py
```

---

## Need Help?

- Check the full guide: `cat AWS_SETUP_GUIDE.md`
- View project documentation: `cat README_PROJECT_SETUP.md`
- IAM issues: Make sure you have admin access or ask your AWS administrator

---

**Once all checks pass, we'll move on to building the backend!** 🚀
