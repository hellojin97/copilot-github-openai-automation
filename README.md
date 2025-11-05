# GitHub Actions Issue Classifier 설정 가이드

## 개요
이 워크플로우는 GitHub 이슈가 생성되거나 수정될 때 Azure OpenAI API를 사용하여 자동으로 이슈를 분류하고 적절한 라벨을 붙이며, 사용자에게 도움이 되는 코멘트를 자동으로 남깁니다.

## 설정 방법

### 1. GitHub Repository Secrets 설정

워크플로우가 작동하려면 다음 시크릿을 GitHub Repository에 추가해야 합니다:

1. GitHub Repository로 이동
2. **Settings** 탭 클릭
3. 왼쪽 사이드바에서 **Secrets and variables** > **Actions** 클릭
4. **New repository secret** 버튼 클릭
5. 다음 시크릿 추가:

#### AZURE_OPENAI_API_KEY
- **Name**: `AZURE_OPENAI_API_KEY`
- **Value**: `[여기에 제공받은 Azure OpenAI API 키를 입력하세요]`

### 2. 워크플로우 기능

#### 트리거 조건
- 이슈가 새로 생성될 때 (`opened`)
- 이슈가 수정될 때 (`edited`)

#### 자동 분류 라벨
- `bug`: 버그 리포트
- `feature`: 새로운 기능 요청
- `enhancement`: 기존 기능 개선
- `documentation`: 문서 관련
- `question`: 질문
- `help wanted`: 도움이 필요한 이슈
- `good first issue`: 초보자에게 적합한 이슈
- `priority-high`: 높은 우선순위
- `priority-medium`: 중간 우선순위
- `priority-low`: 낮은 우선순위

#### 에러 처리
- API 호출 실패 시 `needs-triage` 라벨 자동 추가
- 사용자에게 친근한 에러 메시지 제공

### 3. 사용 방법

1. 위의 시크릿을 설정한 후
2. 새로운 이슈를 생성하거나 기존 이슈를 수정
3. 워크플로우가 자동으로 실행되어 분석 결과를 제공

### 4. Azure OpenAI 설정 정보

- **Endpoint**: `https://eduin4ucpopenaikrc.openai.azure.com/openai/deployments/gpt-4o-mini/chat/completions?api-version=2025-01-01-preview`
- **Model**: `gpt-4o-mini`
- **API Version**: `2025-01-01-preview`

### 5. 워크플로우 로그 확인

워크플로우 실행 상태는 Repository의 **Actions** 탭에서 확인할 수 있습니다.

## 주의사항

1. **API 키 보안**: API 키는 반드시 GitHub Secrets에 저장하고 절대 코드에 하드코딩하지 마세요.
2. **API 사용량**: Azure OpenAI API 사용량을 주기적으로 모니터링하세요.
3. **권한**: 워크플로우는 이슈 읽기/쓰기 권한이 필요합니다.

## 커스터마이징

필요에 따라 다음을 수정할 수 있습니다:
- 라벨 목록
- AI 프롬프트
- 코멘트 형식
- 트리거 조건
