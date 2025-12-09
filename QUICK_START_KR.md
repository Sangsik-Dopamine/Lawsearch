# 🚀 빠른 시작 가이드

## 선택하세요:

### 옵션 1️⃣: 지금 바로 웹사이트로 배포 (GitHub Pages)

가장 빠르고 쉬운 방법! **무료**

```bash
cd /home/user/Lawsearch
./deploy_to_github_pages.sh
```

그 다음:
1. https://github.com/Sangsik-Dopamine/Lawsearch 접속
2. **Settings** → **Pages** 클릭
3. **Branch** 선택: `claude/nova-bedrock-chatbot-01RATQDkn8WxKEosnev5hKrW`
4. **Save** 클릭
5. 1분 대기 후 사이트 URL 확인!

**예상 URL**: `https://sangsik-dopamine.github.io/Lawsearch/`

---

### 옵션 2️⃣: Netlify로 배포 (더 빠른 배포)

1. https://netlify.com 접속
2. GitHub 계정으로 로그인
3. **Add new site** → **Import an existing project**
4. `Lawsearch` 저장소 선택
5. **Deploy** 클릭
6. 완료! URL 받기

**자동 배포 설정 파일 포함됨**: `netlify.toml`

---

### 옵션 3️⃣: AWS 연동 완성하고 실제 AI 챗봇 만들기

먼저 AWS 설정 완료:

```bash
# 1. IAM 권한 수정
./fix_iam_permissions.sh

# 2. S3 버킷 생성
./create_aws_resources.sh

# 3. OpenSearch 도메인 생성 (AWS Console)
# 4. 검증
python3 verify_aws_setup.py
```

그 다음 백엔드 구현 → 배포

---

## 현재 상태

✅ **작동하는 것:**
- 채팅 인터페이스 UI
- 법령 표시 화면
- 기본 애니메이션

❌ **아직 안되는 것:**
- 실제 AI 응답 (백엔드 미구현)
- PDF 업로드 기능
- RAG 검색

**실제 작동시키려면**: 옵션 3️⃣ 진행 필요

---

## 추천 순서

### 빠르게 보여주기만 하려면:
```
옵션 1️⃣ (GitHub Pages)
→ 30초 설정 → 1분 배포 → 완료!
```

### 완전한 AI 챗봇 만들려면:
```
옵션 3️⃣ (AWS 설정)
→ 백엔드 개발
→ Lambda 배포
→ 프론트엔드 연결
```

### 둘 다 하려면:
```
1. 옵션 1️⃣로 먼저 UI 배포 (친구들에게 보여주기)
2. 옵션 3️⃣로 백엔드 개발 (실제 기능 구현)
3. 나중에 연결
```

---

## 자세한 가이드

- **배포 상세 가이드**: `DEPLOYMENT_GUIDE_KR.md`
- **AWS 설정 가이드**: `AWS_SETUP_GUIDE.md`
- **AWS 문제 해결**: `QUICK_FIX_GUIDE.md`
- **프로젝트 전체 문서**: `README_PROJECT_SETUP.md`

---

## 어떻게 하시겠어요?

1. **지금 바로 배포**: GitHub Pages 선택 (위의 명령어 실행)
2. **AWS 먼저 설정**: IAM 권한 문제 해결부터
3. **둘 다**: UI 먼저 배포하고 동시에 AWS 설정

알려주시면 도와드리겠습니다! 🎯
