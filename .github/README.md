# GitHub Automation Issue System

이 프로젝트는 GitHub 이슈 관리를 자동화하는 시스템입니다.

## 🚀 기능

### 자동화된 이슈 분류
- 이슈 제목과 내용을 기반으로 자동 라벨링
- 로그인 관련 500 에러 우선순위 자동 분류
- 중복 이슈 감지 및 알림
- 팀별 자동 할당

### 이슈 템플릿
- **일반 버그 리포트**: 표준 버그 리포팅 템플릿
- **로그인 500 에러**: 로그인 관련 500 에러 전용 상세 템플릿
- **Pull Request 템플릿**: 코드 리뷰를 위한 체계적인 PR 템플릿

### 알림 시스템
- 중요 이슈에 대한 Slack 알림 (설정 필요)
- 자동 댓글로 이슈 상태 업데이트
- 팀멤버 자동 멘션

## 📁 프로젝트 구조

```
.github/
├── ISSUE_TEMPLATE/
│   ├── bug_report.md          # 일반 버그 리포트 템플릿
│   └── bug_login_500.md       # 로그인 500 에러 전용 템플릿
├── workflows/
│   └── issue-classifier.yml   # 이슈 자동 분류 워크플로우
└── PULL_REQUEST_TEMPLATE.md   # PR 템플릿
```

## ⚙️ 설정 방법

### 1. 워크플로우 활성화
이 저장소를 fork하거나 파일들을 복사한 후, GitHub Actions가 자동으로 활성화됩니다.

### 2. 팀 멤버 설정
`issue-classifier.yml` 파일에서 다음 항목을 수정하세요:

```yaml
assignees: ['backend-team-lead'] # 실제 GitHub 사용자명으로 변경
```

### 3. Slack 알림 설정 (선택사항)
1. Slack에서 Webhook URL 생성
2. GitHub 저장소 Settings > Secrets and variables > Actions 
3. `SLACK_WEBHOOK_URL` 시크릿 추가

### 4. 라벨 사전 생성
다음 라벨들을 저장소에 미리 생성해두세요:

- `bug` (빨간색)
- `critical` (진한 빨간색)
- `high-priority` (주황색)
- `login` (파란색)
- `backend` (녹색)
- `frontend` (보라색)
- `mobile` (노란색)
- `performance` (회색)
- `security` (검은색)
- `possible-duplicate` (갈색)
- `needs-triage` (하늘색)
- `needs-immediate-attention` (분홍색)

## 🔄 워크플로우 동작

### 이슈 생성 시
1. **자동 분류**: 제목과 내용 분석하여 적절한 라벨 자동 추가
2. **팀 할당**: 카테고리에 따라 담당 팀에게 자동 할당
3. **우선순위 설정**: 키워드 기반 우선순위 자동 설정
4. **중복 감지**: 유사한 기존 이슈 검색 및 알림

### 특별 처리
- **로그인 500 에러**: 즉시 critical 라벨 추가, 백엔드 팀 할당, Slack 알림
- **보안 관련**: 자동으로 security + critical 라벨 추가
- **성능 이슈**: performance 라벨 자동 추가

## 📝 사용 방법

### 버그 리포트 작성
1. 새 이슈 생성
2. "Bug report" 템플릿 선택
3. 모든 섹션 자세히 작성
4. 제출 후 자동 분류 확인

### 로그인 500 에러 리포트
1. 새 이슈 생성  
2. "Login Error 500" 템플릿 선택
3. 로그인 관련 상세 정보 작성
4. 즉시 높은 우선순위로 처리됨

### Pull Request 작성
1. PR 생성 시 자동으로 템플릿 적용
2. 체크리스트 완료
3. 리뷰어에게 필요한 정보 제공

## 🛠️ 커스터마이징

### 새로운 이슈 타입 추가
1. `.github/ISSUE_TEMPLATE/` 폴더에 새 템플릿 추가
2. `issue-classifier.yml`에 해당 타입 처리 로직 추가

### 자동 분류 규칙 수정
`issue-classifier.yml`의 키워드 매칭 로직을 수정하여 분류 규칙 커스터마이징 가능

### 알림 채널 추가
Discord, Teams 등 다른 플랫폼 webhook 설정으로 알림 확장 가능

## 🔍 모니터링

### GitHub Actions 탭에서 확인 가능한 정보:
- 워크플로우 실행 상태
- 자동 분류 결과
- 에러 로그 (있는 경우)

### 이슈 댓글에서 확인 가능한 정보:
- 자동 적용된 라벨
- 감지된 중복 이슈
- 우선순위 및 담당팀 정보

## 📊 분석 및 개선

### 성능 지표
- 이슈 처리 시간 단축
- 중복 이슈 감소율  
- 팀별 워크로드 분산 효과

### 개선 제안
- 이슈 분류 정확도 향상을 위한 키워드 확장
- 머신러닝 기반 분류 시스템 도입
- 대시보드를 통한 이슈 트렌드 분석

---

## 🤝 기여하기

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 라이선스

이 프로젝트는 MIT 라이선스 하에 배포됩니다. 자세한 내용은 `LICENSE` 파일을 참조하세요.

## 📞 지원

문제가 있거나 기능 제안이 있으시면 이슈를 생성해주세요.