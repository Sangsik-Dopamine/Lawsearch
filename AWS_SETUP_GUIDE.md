# AWS Setup Guide for Nova Bedrock Chatbot

## Prerequisites
- AWS Account (if you don't have one, sign up at aws.amazon.com)
- Credit card for AWS billing
- Basic understanding of AWS console

---

## Step 1: Create AWS Account & Initial Setup

### 1.1 Sign Up for AWS (if needed)
1. Go to https://aws.amazon.com
2. Click "Create an AWS Account"
3. Follow the registration process
4. Complete identity verification and payment method setup

### 1.2 Enable Required AWS Regions
For this project, we'll use **us-east-1** (N. Virginia) as it has the best Bedrock availability.

---

## Step 2: AWS Bedrock Setup

### 2.1 Verify Bedrock Access (Automatic Enablement)

**Good News!** AWS has simplified Bedrock access. Models are now **automatically enabled** when first invoked - no manual activation needed!

#### What You Need to Know:
- ✅ **Nova Pro** and **Titan Embeddings** will be enabled automatically when you first use them
- ✅ No need to visit the "Model access" page (it's been retired)
- ✅ First-time API call will activate the model for your account
- ✅ IAM permissions still control access (we'll set this up in Step 5)

#### Optional: Verify Bedrock is Available
1. Log into AWS Console
2. Search for "Bedrock" in the top search bar
3. Click "Amazon Bedrock"
4. Browse **"Model catalog"** in the left sidebar
5. Search for **"Nova Pro"** to confirm it's available in your region
6. You can test it in the **Playground** (optional)

> **Note:** Make sure you're in **us-east-1** region. Models will auto-enable on first use via API.

---

## Step 3: Create S3 Bucket for PDF Storage

### 3.1 Create S3 Bucket
1. In AWS Console, search for "S3"
2. Click **"Create bucket"**
3. Bucket settings:
   - **Bucket name**: `lawsearch-pdf-storage-[your-unique-id]` (must be globally unique)
   - **AWS Region**: `us-east-1`
   - **Block Public Access**: Keep all checked (we'll use signed URLs)
   - **Bucket Versioning**: Enable (recommended)
   - **Encryption**: Enable (SSE-S3)
4. Click **"Create bucket"**

### 3.2 Create Folder Structure (Optional)
Inside your bucket, you can create folders:
- `pdfs/` - uploaded PDF files
- `processed/` - processed documents

---

## Step 4: Set Up Amazon OpenSearch

### 4.1 Create OpenSearch Domain
1. In AWS Console, search for "OpenSearch"
2. Click **"Create domain"**
3. Configuration:
   - **Domain name**: `lawsearch-vectors`
   - **Deployment type**: **Development and testing** (cheaper for starting)
   - **Version**: Latest (e.g., 2.11)
   - **Data nodes**:
     - Instance type: `t3.small.search` (cheapest)
     - Number of nodes: 1
   - **Network**:
     - **Public access** (easier for development)
     - Create security policy to restrict access
   - **Fine-grained access control**:
     - Enable
     - Create master user: `admin` / `[Strong-Password-123!]`
   - **Access policy**:
     - Select "Only use fine-grained access control"
4. Click **"Create"**
5. **Wait 10-15 minutes** for domain creation

### 4.2 Note Your OpenSearch Endpoint
Once created, copy the **Domain endpoint** (e.g., `https://lawsearch-vectors-xxxxx.us-east-1.es.amazonaws.com`)

---

## Step 5: Create IAM User for Application

### 5.1 Create IAM Policy
1. In AWS Console, search for "IAM"
2. Click **"Policies"** in left sidebar
3. Click **"Create policy"**
4. Switch to **JSON** tab
5. Paste this policy:

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "BedrockAccess",
            "Effect": "Allow",
            "Action": [
                "bedrock:InvokeModel",
                "bedrock:InvokeModelWithResponseStream"
            ],
            "Resource": [
                "arn:aws:bedrock:us-east-1::foundation-model/amazon.nova-pro-v1:0",
                "arn:aws:bedrock:us-east-1::foundation-model/amazon.titan-embed-text-v1"
            ]
        },
        {
            "Sid": "S3Access",
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:GetObject",
                "s3:DeleteObject",
                "s3:ListBucket"
            ],
            "Resource": [
                "arn:aws:s3:::lawsearch-pdf-storage-*",
                "arn:aws:s3:::lawsearch-pdf-storage-*/*"
            ]
        },
        {
            "Sid": "OpenSearchAccess",
            "Effect": "Allow",
            "Action": [
                "es:ESHttpGet",
                "es:ESHttpPost",
                "es:ESHttpPut",
                "es:ESHttpDelete"
            ],
            "Resource": "arn:aws:es:us-east-1:*:domain/lawsearch-vectors/*"
        }
    ]
}
```

6. Click **"Next"**
7. Policy name: `LawsearchBedrockPolicy`
8. Click **"Create policy"**

### 5.2 Create IAM User
1. In IAM, click **"Users"** in left sidebar
2. Click **"Create user"**
3. User name: `lawsearch-app-user`
4. Click **"Next"**
5. Select **"Attach policies directly"**
6. Search and select: `LawsearchBedrockPolicy`
7. Click **"Next"** then **"Create user"**

### 5.3 Create Access Keys
1. Click on the newly created user
2. Go to **"Security credentials"** tab
3. Scroll to **"Access keys"**
4. Click **"Create access key"**
5. Select **"Application running outside AWS"**
6. Click **"Next"** then **"Create access key"**
7. **IMPORTANT**: Copy both:
   - **Access key ID**: `AKIA...`
   - **Secret access key**: `xxxx...` (only shown once!)
8. Store these securely - we'll use them in the next step

---

## Step 6: Configure Local Environment

### 6.1 Install AWS CLI (if not installed)
```bash
# macOS
brew install awscli

# Linux
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

# Windows
# Download installer from: https://awscli.amazonaws.com/AWSCLIV2.msi
```

### 6.2 Configure AWS Credentials
```bash
aws configure
```

Enter when prompted:
- **AWS Access Key ID**: [Your access key from Step 5.3]
- **AWS Secret Access Key**: [Your secret key from Step 5.3]
- **Default region name**: `us-east-1`
- **Default output format**: `json`

### 6.3 Verify Configuration
```bash
# Test Bedrock access
aws bedrock list-foundation-models --region us-east-1 --query 'modelSummaries[?contains(modelId, `nova`)].modelId'

# Test S3 access
aws s3 ls s3://lawsearch-pdf-storage-[your-unique-id]/

# Check OpenSearch endpoint
aws opensearch describe-domain --domain-name lawsearch-vectors --region us-east-1
```

---

## Step 7: Create Configuration File

Create a `.env` file in your project root:

```bash
# Run this command
cat > .env << 'EOF'
# AWS Configuration
AWS_REGION=us-east-1
AWS_ACCESS_KEY_ID=your_access_key_here
AWS_SECRET_ACCESS_KEY=your_secret_key_here

# S3 Configuration
S3_BUCKET_NAME=lawsearch-pdf-storage-[your-unique-id]
S3_PDF_FOLDER=pdfs/

# OpenSearch Configuration
OPENSEARCH_ENDPOINT=https://your-opensearch-endpoint.us-east-1.es.amazonaws.com
OPENSEARCH_USERNAME=admin
OPENSEARCH_PASSWORD=your-opensearch-password

# Bedrock Configuration
BEDROCK_MODEL_ID=amazon.nova-pro-v1:0
BEDROCK_EMBEDDING_MODEL_ID=amazon.titan-embed-text-v1

# Application Configuration
FLASK_ENV=development
FLASK_PORT=5000
EOF
```

**Important**: Add `.env` to `.gitignore`:
```bash
echo ".env" >> .gitignore
```

---

## Step 8: Verify Everything is Ready

Run these checks:

```bash
# 1. Check Bedrock models
aws bedrock list-foundation-models \
  --region us-east-1 \
  --query 'modelSummaries[?modelId==`amazon.nova-pro-v1:0`]'

# 2. Check S3 bucket
aws s3api head-bucket --bucket lawsearch-pdf-storage-[your-unique-id]

# 3. Check OpenSearch domain
aws opensearch describe-domain \
  --domain-name lawsearch-vectors \
  --query 'DomainStatus.Endpoint'
```

All should return success (no errors).

---

## Cost Estimation (Monthly)

For development/testing:
- **Bedrock Nova Pro**: ~$0.008 per 1K input tokens, ~$0.024 per 1K output
- **Bedrock Titan Embeddings**: ~$0.0001 per 1K tokens
- **S3 Storage**: ~$0.023 per GB
- **OpenSearch t3.small.search**: ~$40-50/month (on-demand)
- **Data Transfer**: Usually minimal for testing

**Total estimated**: ~$50-70/month for development

**Pro Tip**: Use OpenSearch Serverless for true pay-per-use (no idle costs).

---

## Quick Troubleshooting

### Model Access Denied or "ResourceNotFoundException"
- **Models auto-enable on first use** - the first API call may take a few extra seconds
- Check IAM policy includes correct model ARNs (see Step 5.1)
- Ensure you're in correct region (us-east-1)
- For Anthropic models (Claude), some users may need to submit use case details
- **Nova models** (Amazon) typically don't require use case approval

### OpenSearch Connection Failed
- Check security group allows your IP
- Verify fine-grained access control credentials
- Test with curl: `curl -u admin:password https://your-endpoint.es.amazonaws.com`

### S3 Access Denied
- Check bucket name matches in IAM policy
- Verify bucket is in same region
- Test: `aws s3 ls s3://your-bucket-name/`

---

## Next Steps

Once AWS is configured:
1. ✅ Install Python dependencies
2. ✅ Create backend Flask application
3. ✅ Implement Bedrock integration
4. ✅ Build terminal page UI
5. ✅ Connect RAG with OpenSearch

You're now ready to proceed with the implementation!

---

## Security Best Practices

- ✅ Never commit `.env` file to git
- ✅ Use IAM roles instead of access keys in production
- ✅ Enable CloudTrail for audit logging
- ✅ Regularly rotate access keys
- ✅ Use AWS Secrets Manager for production credentials
- ✅ Enable MFA on AWS root account
