#!/bin/bash

# Lawsearch Project Quick Setup Script
# This script helps you set up the project after AWS configuration

set -e

echo "=========================================="
echo "Lawsearch Chatbot - Quick Setup"
echo "=========================================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if Python is installed
echo "1. Checking Python installation..."
if ! command -v python3 &> /dev/null; then
    echo -e "${RED}✗ Python 3 is not installed${NC}"
    echo "  Please install Python 3.8 or higher"
    exit 1
fi
PYTHON_VERSION=$(python3 --version)
echo -e "${GREEN}✓${NC} $PYTHON_VERSION found"
echo ""

# Check if pip is installed
echo "2. Checking pip installation..."
if ! command -v pip3 &> /dev/null; then
    echo -e "${RED}✗ pip3 is not installed${NC}"
    exit 1
fi
echo -e "${GREEN}✓${NC} pip3 found"
echo ""

# Create virtual environment
echo "3. Creating virtual environment..."
if [ -d "venv" ]; then
    echo -e "${YELLOW}⚠${NC} Virtual environment already exists"
    read -p "  Do you want to recreate it? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        rm -rf venv
        python3 -m venv venv
        echo -e "${GREEN}✓${NC} Virtual environment recreated"
    fi
else
    python3 -m venv venv
    echo -e "${GREEN}✓${NC} Virtual environment created"
fi
echo ""

# Activate virtual environment
echo "4. Activating virtual environment..."
source venv/bin/activate
echo -e "${GREEN}✓${NC} Virtual environment activated"
echo ""

# Upgrade pip
echo "5. Upgrading pip..."
pip install --upgrade pip > /dev/null 2>&1
echo -e "${GREEN}✓${NC} pip upgraded"
echo ""

# Install requirements
echo "6. Installing Python dependencies..."
echo "   This may take a few minutes..."
pip install -r requirements.txt > /dev/null 2>&1
echo -e "${GREEN}✓${NC} Dependencies installed"
echo ""

# Check if .env exists
echo "7. Checking configuration..."
if [ -f ".env" ]; then
    echo -e "${GREEN}✓${NC} .env file found"
else
    echo -e "${YELLOW}⚠${NC} .env file not found"
    echo "  Creating template .env file..."
    cat > .env << 'EOF'
# AWS Configuration
AWS_REGION=us-east-1
AWS_ACCESS_KEY_ID=your_access_key_here
AWS_SECRET_ACCESS_KEY=your_secret_key_here

# S3 Configuration
S3_BUCKET_NAME=lawsearch-pdf-storage-YOUR-UNIQUE-ID
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
    echo -e "${GREEN}✓${NC} Template .env file created"
    echo -e "${YELLOW}  → Please edit .env with your AWS credentials${NC}"
fi
echo ""

# Check if .gitignore exists
echo "8. Checking .gitignore..."
if [ -f ".gitignore" ]; then
    if ! grep -q ".env" .gitignore; then
        echo ".env" >> .gitignore
        echo "venv/" >> .gitignore
        echo "__pycache__/" >> .gitignore
        echo "*.pyc" >> .gitignore
        echo -e "${GREEN}✓${NC} Updated .gitignore"
    else
        echo -e "${GREEN}✓${NC} .gitignore already configured"
    fi
else
    cat > .gitignore << 'EOF'
# Environment
.env
venv/

# Python
__pycache__/
*.py[cod]
*$py.class
*.so

# IDE
.vscode/
.idea/
*.swp
*.swo

# OS
.DS_Store
Thumbs.db
EOF
    echo -e "${GREEN}✓${NC} Created .gitignore"
fi
echo ""

# Create necessary directories
echo "9. Creating project directories..."
mkdir -p backend
mkdir -p backend/config
mkdir -p logs
mkdir -p uploads
echo -e "${GREEN}✓${NC} Directories created"
echo ""

# Make verification script executable
echo "10. Making scripts executable..."
chmod +x verify_aws_setup.py
echo -e "${GREEN}✓${NC} Scripts are executable"
echo ""

# Summary
echo "=========================================="
echo "Setup Complete!"
echo "=========================================="
echo ""
echo "Next Steps:"
echo ""
echo "1. Edit .env file with your AWS credentials:"
echo "   ${YELLOW}nano .env${NC}"
echo ""
echo "2. Verify AWS setup:"
echo "   ${YELLOW}python3 verify_aws_setup.py${NC}"
echo ""
echo "3. Follow AWS_SETUP_GUIDE.md if you haven't configured AWS yet"
echo ""
echo "4. Once AWS is configured, I'll help you build the backend"
echo ""
echo "To activate the virtual environment later:"
echo "   ${YELLOW}source venv/bin/activate${NC}"
echo ""
echo -e "${GREEN}Happy coding! 🚀${NC}"
echo ""
