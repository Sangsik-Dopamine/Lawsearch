#!/bin/bash

# GitHub Pages 빠른 배포 스크립트
# Quick deployment script for GitHub Pages

echo "=========================================="
echo "GitHub Pages 배포 준비"
echo "Preparing GitHub Pages Deployment"
echo "=========================================="
echo ""

# Check if we're in the right directory
if [ ! -f "index.html" ]; then
    echo "❌ index.html을 찾을 수 없습니다."
    echo "   Please run this from the Lawsearch directory"
    exit 1
fi

echo "✓ index.html 발견"
echo ""

# Create .nojekyll file (tells GitHub Pages not to use Jekyll)
echo "1. GitHub Pages 설정 파일 생성..."
touch .nojekyll

# Create a simple README for GitHub Pages
if [ ! -f "README.md" ]; then
    cat > README.md << 'EOF'
# Lawsearch - AI 법령 검색 챗봇

AWS Bedrock Nova를 활용한 법령 검색 챗봇 시스템

## 데모

[Live Demo](https://sangsik-dopamine.github.io/Lawsearch/)

## 기능

- 🤖 AI 챗봇 인터페이스
- 📁 PDF 파일 관리 터미널
- 📄 RAG 기반 문서 검색
- ☁️ AWS Bedrock Nova Pro 연동

## 기술 스택

- Frontend: HTML/CSS/JavaScript
- Backend: Python Flask + AWS Bedrock
- Storage: Amazon S3
- Vector DB: Amazon OpenSearch
EOF
    echo "✓ README.md 생성"
else
    echo "✓ README.md 이미 존재"
fi

echo ""
echo "2. Git 변경사항 확인..."
git status --short

echo ""
echo "3. 변경사항 커밋..."
git add .nojekyll README.md
git commit -m "Configure for GitHub Pages deployment" || echo "이미 커밋됨"

echo ""
echo "4. GitHub에 푸시..."
git push origin claude/nova-bedrock-chatbot-01RATQDkn8WxKEosnev5hKrW

echo ""
echo "=========================================="
echo "✓ 파일 준비 완료!"
echo "=========================================="
echo ""
echo "다음 단계:"
echo ""
echo "1. GitHub 웹사이트로 이동:"
echo "   https://github.com/Sangsik-Dopamine/Lawsearch"
echo ""
echo "2. Settings → Pages 메뉴 선택"
echo ""
echo "3. Branch 설정:"
echo "   - Branch: claude/nova-bedrock-chatbot-01RATQDkn8WxKEosnev5hKrW"
echo "   - Folder: / (root)"
echo "   - Save 클릭"
echo ""
echo "4. 1-2분 후 사이트 URL 확인:"
echo "   https://sangsik-dopamine.github.io/Lawsearch/"
echo ""
echo "=========================================="
echo ""
echo "💡 Tip: GitHub Actions로 자동 배포 설정하려면"
echo "   deploy_with_actions.sh 실행"
echo ""
