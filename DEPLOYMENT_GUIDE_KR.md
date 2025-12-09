# GitHub 정적 웹사이트 배포 가이드

## 옵션 1: GitHub Pages (가장 쉬운 방법 - 무료)

### 장점:
- ✅ 완전 무료
- ✅ 설정 30초면 완료
- ✅ GitHub 저장소와 자동 동기화
- ✅ HTTPS 자동 지원
- ✅ 커스텀 도메인 연결 가능

### 단점:
- ❌ 백엔드 없음 (정적 파일만)
- ❌ 현재 chatbot은 실제 Bedrock API 연결 불가 (프론트엔드만 작동)

### 설정 방법:

#### 방법 A: GitHub 웹사이트에서 (가장 쉬움)

1. **GitHub 저장소로 이동**
   - https://github.com/Sangsik-Dopamine/Lawsearch

2. **Settings 탭 클릭**
   - 저장소 상단의 "Settings" 클릭

3. **Pages 메뉴 선택**
   - 왼쪽 사이드바에서 "Pages" 클릭

4. **Branch 설정**
   - Source: "Deploy from a branch" 선택
   - Branch: `claude/nova-bedrock-chatbot-01RATQDkn8WxKEosnev5hKrW` 선택
   - Folder: `/ (root)` 선택
   - **Save** 클릭

5. **배포 완료! (1-2분 대기)**
   - 페이지 상단에 URL 표시됨
   - URL 형식: `https://sangsik-dopamine.github.io/Lawsearch/`

6. **친구들에게 공유**
   - 해당 URL을 복사해서 공유하면 됩니다!

#### 방법 B: Git 명령어로 (더 빠름)

```bash
# 저장소 루트로 이동
cd /home/user/Lawsearch

# GitHub Pages용 설정 파일 생성
echo "theme: jekyll-theme-minimal" > _config.yml

# 변경사항 커밋
git add _config.yml
git commit -m "Enable GitHub Pages"
git push origin claude/nova-bedrock-chatbot-01RATQDkn8WxKEosnev5hKrW
```

그 다음 위의 "방법 A"의 2-5단계 진행

---

## 옵션 2: Netlify (추천 - 무료 + 쉬움)

### 장점:
- ✅ 완전 무료 (취미 프로젝트)
- ✅ GitHub 연동 자동 배포
- ✅ 빌드 프로세스 지원
- ✅ 폼, 서버리스 함수 지원
- ✅ 커스텀 도메인 무료

### 설정 방법:

1. **Netlify 가입**
   - https://netlify.com 접속
   - GitHub 계정으로 로그인

2. **"Add new site" → "Import an existing project"**

3. **GitHub 저장소 연결**
   - GitHub 선택
   - `Sangsik-Dopamine/Lawsearch` 선택

4. **배포 설정**
   - Branch: `claude/nova-bedrock-chatbot-01RATQDkn8WxKEosnev5hKrW`
   - Build command: (비워두기)
   - Publish directory: `/`
   - **Deploy site** 클릭

5. **배포 완료! (30초-1분)**
   - URL 형식: `https://random-name-12345.netlify.app`
   - 사이트 이름 변경 가능

---

## 옵션 3: AWS Amplify (AWS 통합 - 무료 티어)

### 장점:
- ✅ AWS 생태계 통합
- ✅ 나중에 백엔드 연결 쉬움
- ✅ GitHub 자동 배포
- ✅ 무료 티어: 월 1000분 빌드, 15GB 저장

### 설정 방법:

1. **AWS Console 접속**
   - AWS Amplify 서비스 검색

2. **"Host web app" 클릭**

3. **GitHub 연결**
   - GitHub 선택 및 인증
   - 저장소: `Lawsearch` 선택
   - 브랜치: `claude/nova-bedrock-chatbot-01RATQDkn8WxKEosnev5hKrW`

4. **빌드 설정**
   - App name: `lawsearch-chatbot`
   - 자동 감지된 설정 사용

5. **배포 시작**
   - "Save and deploy" 클릭
   - 2-3분 대기

6. **배포 완료!**
   - URL 형식: `https://main.xxxxx.amplifyapp.com`

---

## 옵션 4: Vercel (개발자 친화적 - 무료)

### 장점:
- ✅ 완전 무료 (개인 프로젝트)
- ✅ 초고속 배포
- ✅ GitHub 자동 동기화
- ✅ 서버리스 함수 지원

### 설정 방법:

1. **Vercel 가입**
   - https://vercel.com
   - GitHub 계정으로 로그인

2. **"Add New Project"**

3. **GitHub 저장소 Import**
   - `Sangsik-Dopamine/Lawsearch` 선택

4. **설정**
   - Framework Preset: Other
   - Root Directory: ./
   - **Deploy** 클릭

5. **배포 완료! (30초)**
   - URL 형식: `https://lawsearch-xxx.vercel.app`

---

## 비교표

| 옵션 | 난이도 | 속도 | 무료 | 백엔드 지원 | AWS 통합 |
|------|--------|------|------|-------------|----------|
| **GitHub Pages** | ⭐ 매우 쉬움 | 빠름 | ✅ | ❌ | ❌ |
| **Netlify** | ⭐⭐ 쉬움 | 매우 빠름 | ✅ | ✅ (서버리스) | ❌ |
| **AWS Amplify** | ⭐⭐⭐ 보통 | 보통 | ✅ (제한) | ✅ | ✅ |
| **Vercel** | ⭐⭐ 쉬움 | 초고속 | ✅ | ✅ (서버리스) | ❌ |

---

## 추천

### 지금 당장 보여주고 싶다면:
👉 **GitHub Pages** (30초 설정)

### 나중에 백엔드도 연결할 예정이라면:
👉 **Netlify** 또는 **Vercel**

### AWS Bedrock과 완전 통합하려면:
👉 **AWS Amplify** (나중에 Lambda, API Gateway 연결 쉬움)

---

## 중요: 현재 상태

⚠️ **주의**: 현재 `index.html`은 프론트엔드만 있어서:
- ✅ 채팅 인터페이스는 보임
- ✅ 법령 검색 UI 작동
- ❌ 실제 AI 응답은 안됨 (백엔드 미구현)
- ❌ 데이터는 목(mock) 데이터만 표시

실제 작동하는 AI 챗봇으로 만들려면:
1. **백엔드 구현 필요** (Flask + Bedrock - 다음 단계)
2. **백엔드를 AWS Lambda + API Gateway로 배포**
3. **프론트엔드에서 백엔드 API 호출**

---

## 다음 단계 제안

**선택 1: 일단 UI만 먼저 배포**
```bash
# GitHub Pages로 바로 배포
# 위의 "방법 A" 또는 "방법 B" 따라하기
```

**선택 2: 완전한 백엔드 먼저 만들고 배포**
- AWS 설정 완료 후
- Flask 백엔드 구현
- AWS Lambda로 배포
- 프론트엔드 연결

---

## 어떻게 진행하시겠어요?

1. **GitHub Pages로 일단 UI만 빠르게 배포할까요?**
   - 제가 바로 설정 도와드릴 수 있습니다

2. **AWS 설정 먼저 완료하고 완전한 챗봇 만들까요?**
   - IAM 권한 해결 → 백엔드 구현 → 전체 배포

3. **둘 다 하실래요?**
   - UI는 GitHub Pages로 먼저 배포
   - 백엔드는 AWS 설정 후 Lambda로 배포
   - 나중에 연결

알려주시면 바로 진행하겠습니다! 🚀
