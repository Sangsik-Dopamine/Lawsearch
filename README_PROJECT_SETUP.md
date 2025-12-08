# Lawsearch - Nova Bedrock Chatbot with RAG

A chatbot application powered by AWS Bedrock Nova-Pro with PDF management and RAG (Retrieval-Augmented Generation) capabilities.

## Features

- 🤖 **AI Chatbot** - Powered by Amazon Nova Pro via AWS Bedrock
- 📁 **Terminal Interface** - File manager for PDFs with folder operations
- 📄 **RAG System** - Upload PDFs and make them queryable via chat
- 🔍 **Vector Search** - Amazon OpenSearch for semantic document retrieval
- ☁️ **Cloud Storage** - S3 for secure file storage

---

## Project Setup Guide

Follow these steps in order:

### Step 1: Run Quick Setup

This will install all dependencies and create the necessary project structure:

```bash
# Make script executable (if not already)
chmod +x quick_setup.sh

# Run setup
./quick_setup.sh
```

This script will:
- ✅ Check Python installation
- ✅ Create virtual environment
- ✅ Install all dependencies
- ✅ Create `.env` template
- ✅ Set up `.gitignore`
- ✅ Create project directories

### Step 2: Configure AWS

Follow the comprehensive guide:

```bash
# Read the AWS setup guide
cat AWS_SETUP_GUIDE.md

# Or open in your editor
nano AWS_SETUP_GUIDE.md
```

**AWS Setup Checklist:**
- [ ] Create AWS account (if needed)
- [ ] Enable Bedrock Nova Pro model access
- [ ] Enable Bedrock Titan Embeddings
- [ ] Create S3 bucket for PDF storage
- [ ] Create OpenSearch domain
- [ ] Create IAM user with appropriate permissions
- [ ] Generate access keys
- [ ] Configure AWS CLI (`aws configure`)
- [ ] Update `.env` file with credentials

### Step 3: Update Configuration

Edit your `.env` file with actual AWS credentials:

```bash
nano .env
```

Replace these placeholders:
- `your_access_key_here` → Your AWS Access Key ID
- `your_secret_key_here` → Your AWS Secret Access Key
- `lawsearch-pdf-storage-YOUR-UNIQUE-ID` → Your actual S3 bucket name
- `your-opensearch-endpoint` → Your OpenSearch endpoint URL
- `your-opensearch-password` → Your OpenSearch master password

### Step 4: Verify AWS Setup

Run the verification script to ensure everything is configured correctly:

```bash
# Activate virtual environment (if not already active)
source venv/bin/activate

# Run verification
python3 verify_aws_setup.py
```

Expected output:
```
✓ AWS credentials found
✓ Bedrock API access successful
✓ Nova Pro model found
✓ S3 access successful
✓ OpenSearch domain found
✓ Bedrock inference successful

🎉 All checks passed! You're ready to start development.
```

If any checks fail, refer back to `AWS_SETUP_GUIDE.md`.

---

## Project Structure

```
Lawsearch/
├── index.html              # Main chatbot interface (your existing)
├── terminal.html           # File management interface (to be created)
├── backend/
│   ├── app.py             # Flask server
│   ├── bedrock_client.py  # AWS Bedrock integration
│   ├── rag_engine.py      # RAG implementation
│   ├── storage_manager.py # S3 file operations
│   └── config/
│       └── aws_config.py  # AWS configuration
├── uploads/               # Temporary upload directory
├── logs/                  # Application logs
├── .env                   # Environment variables (not in git)
├── .gitignore
├── requirements.txt       # Python dependencies
├── verify_aws_setup.py    # AWS verification script
├── quick_setup.sh         # Setup automation script
├── AWS_SETUP_GUIDE.md     # Detailed AWS setup instructions
└── README_PROJECT_SETUP.md # This file
```

---

## Architecture Overview

```
┌─────────────────┐
│   Frontend      │
│  (HTML/JS)      │
│                 │
│  - index.html   │  ← Chatbot Interface
│  - terminal.html│  ← File Manager
└────────┬────────┘
         │ HTTP/REST
         ↓
┌─────────────────┐
│  Flask Backend  │
│                 │
│  - API Routes   │
│  - File Upload  │
│  - RAG Logic    │
└────────┬────────┘
         │
    ┌────┴────┬──────────┬────────────┐
    ↓         ↓          ↓            ↓
┌────────┐ ┌───────┐ ┌───────┐  ┌──────────┐
│Bedrock │ │  S3   │ │Vector │  │OpenSearch│
│ Nova   │ │Storage│ │ Embed │  │  Index   │
└────────┘ └───────┘ └───────┘  └──────────┘
```

### Data Flow

1. **Document Upload** → Terminal UI → Backend → S3 Storage
2. **Document Processing** → Extract text → Generate embeddings → Store in OpenSearch
3. **User Query** → Chatbot → Retrieve relevant docs → Send to Nova → Response
4. **File Operations** → Terminal UI → Backend → S3 operations

---

## Tech Stack

### Frontend
- HTML5/CSS3/JavaScript
- Fetch API for backend communication
- Responsive design

### Backend
- **Framework**: Flask (Python)
- **AI Model**: Amazon Nova Pro (via Bedrock)
- **Embeddings**: Amazon Titan Embeddings
- **Vector DB**: Amazon OpenSearch
- **Storage**: Amazon S3
- **PDF Processing**: PyPDF2, LangChain

### AWS Services
- **Bedrock**: AI model inference
- **S3**: File storage
- **OpenSearch**: Vector search
- **IAM**: Authentication & authorization

---

## API Endpoints (To be implemented)

### Chat Endpoints
```
POST /api/chat              # Send message to chatbot
POST /api/chat/stream       # Stream chat responses
GET  /api/chat/history      # Get chat history
```

### File Management Endpoints
```
GET    /api/files           # List files and folders
POST   /api/files/upload    # Upload PDF
DELETE /api/files/:id       # Delete file
POST   /api/files/move      # Move file/folder
POST   /api/folders         # Create folder
DELETE /api/folders/:id     # Delete folder
```

### RAG Endpoints
```
POST /api/rag/index         # Index document for RAG
GET  /api/rag/search        # Search indexed documents
GET  /api/rag/status/:id    # Check indexing status
```

---

## Development Workflow

### 1. Start Development Server

```bash
# Activate virtual environment
source venv/bin/activate

# Run Flask server
python backend/app.py

# Server will start on http://localhost:5000
```

### 2. Test Endpoints

```bash
# Test health check
curl http://localhost:5000/api/health

# Test chat (once implemented)
curl -X POST http://localhost:5000/api/chat \
  -H "Content-Type: application/json" \
  -d '{"message": "Hello, what can you do?"}'
```

### 3. Access Interfaces

- **Chatbot**: http://localhost:5000/ (index.html)
- **Terminal**: http://localhost:5000/terminal (terminal.html)

---

## Next Steps

After completing AWS setup and verification:

1. **Backend Implementation** (Flask + Bedrock)
   - Create Flask application structure
   - Implement Bedrock client for Nova Pro
   - Set up API routes

2. **S3 Storage Manager**
   - File upload/download functions
   - Folder management
   - Presigned URLs for secure access

3. **RAG Engine**
   - PDF text extraction
   - Text chunking and embedding
   - OpenSearch indexing
   - Semantic search implementation

4. **Terminal UI**
   - File browser interface
   - Upload functionality
   - CRUD operations for files/folders

5. **Chatbot Integration**
   - Connect frontend to backend API
   - Implement streaming responses
   - Add RAG context to prompts

---

## Cost Optimization Tips

### Development Phase
- Use OpenSearch `t3.small.search` (1 node)
- Delete test data regularly from S3
- Monitor Bedrock token usage

### Production Phase
- Consider OpenSearch Serverless (pay-per-use)
- Enable S3 lifecycle policies
- Use caching for frequent queries
- Implement request throttling

---

## Troubleshooting

### Common Issues

#### "No module named 'boto3'"
```bash
source venv/bin/activate
pip install -r requirements.txt
```

#### "AWS credentials not found"
```bash
aws configure
# Or check your .env file
```

#### "AccessDeniedException: User is not authorized"
- Check IAM policy includes correct permissions
- Verify model access in Bedrock console
- Ensure correct AWS region (us-east-1)

#### "OpenSearch connection timeout"
- Check security group allows your IP
- Verify endpoint URL in .env
- Test with curl: `curl -u admin:password https://your-endpoint`

---

## Security Best Practices

- ✅ Never commit `.env` to git
- ✅ Use environment variables for secrets
- ✅ Enable MFA on AWS account
- ✅ Rotate access keys regularly
- ✅ Use IAM roles in production (not access keys)
- ✅ Enable CloudTrail for audit logging
- ✅ Restrict OpenSearch access by IP
- ✅ Use HTTPS in production
- ✅ Implement rate limiting
- ✅ Validate and sanitize file uploads

---

## Support & Resources

### Documentation
- [AWS Bedrock](https://docs.aws.amazon.com/bedrock/)
- [Amazon Nova Models](https://aws.amazon.com/bedrock/nova/)
- [OpenSearch](https://opensearch.org/docs/)
- [Flask](https://flask.palletsprojects.com/)
- [LangChain](https://python.langchain.com/)

### Getting Help
- Review `AWS_SETUP_GUIDE.md` for AWS configuration
- Run `verify_aws_setup.py` to diagnose issues
- Check application logs in `logs/` directory

---

## License

This project is for educational and development purposes.

---

**Ready to start?** Run `./quick_setup.sh` and follow the steps! 🚀
