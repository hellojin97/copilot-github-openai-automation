# 🐛 Bug Generator FastAPI

의도적으로 다양한 에러를 발생시키는 FastAPI 애플리케이션입니다.  
GitHub 이슈 자동 분류 시스템을 테스트하기 위해 만들어졌습니다.

## 설치 및 실행

### 1. 의존성 설치
```bash
# uv를 사용하여 가상환경에 패키지 설치
uv pip install -r requirements.txt
```

### 2. 애플리케이션 실행
```bash
# uv를 사용하여 실행
uv run python main.py

# 또는 직접 실행
python main.py
```

### 3. API 문서 확인
- **Swagger UI**: http://localhost:8000/docs
- **ReDoc**: http://localhost:8000/redoc

## 🔥 에러 엔드포인트들

### GET 엔드포인트
- `GET /` - 기본 정보 (정상 작동)
- `GET /random-error` - 랜덤한 에러 발생 (70% 확률)
- `GET /divide` - 0으로 나누기 에러
- `GET /timeout` - 타임아웃 에러 (50% 확률)
- `GET /database-error` - DB 연결 에러
- `GET /auth-error` - 인증 에러
- `GET /memory-error` - 메모리 부족 에러
- `GET /health` - 헬스체크 (20% 확률로 에러)

### POST 엔드포인트
- `POST /validation-error` - 유효성 검사 에러
- `POST /calculate` - 계산 API (다양한 에러 케이스)

## 🧪 테스트 예시

### cURL을 사용한 테스트
```bash
# 랜덤 에러 테스트
curl http://localhost:8000/random-error

# 0으로 나누기 에러
curl http://localhost:8000/divide

# 유효성 검사 에러 (잘못된 데이터)
curl -X POST "http://localhost:8000/validation-error" \
     -H "Content-Type: application/json" \
     -d '{"name": "error", "age": -5, "email": "invalid-email"}'

# 계산 API (0으로 나누기)
curl -X POST "http://localhost:8000/calculate" \
     -H "Content-Type: application/json" \
     -d '{"a": 10, "b": 0, "operation": "/"}'
```

### PowerShell을 사용한 테스트
```powershell
# 랜덤 에러 테스트
Invoke-RestMethod -Uri "http://localhost:8000/random-error"

# POST 요청 (유효성 검사 에러)
$body = @{
    name = "error"
    age = -5
    email = "invalid-email"
} | ConvertTo-Json

Invoke-RestMethod -Uri "http://localhost:8000/validation-error" -Method POST -Body $body -ContentType "application/json"
```

## 📋 GitHub 이슈 등록 시나리오

이 애플리케이션을 사용하여 다음과 같은 이슈들을 등록해볼 수 있습니다:

### 🐛 버그 리포트
- "API 호출 시 500 에러 발생"
- "0으로 나누기 에러가 처리되지 않음"
- "타임아웃 에러가 간헐적으로 발생"

### ✨ 기능 요청
- "에러 로깅 기능 추가 요청"
- "사용자 친화적인 에러 메시지 개선"
- "에러 통계 대시보드 구현"

### ❓ 질문
- "메모리 에러는 언제 발생하나요?"
- "어떤 HTTP 상태 코드가 반환되나요?"
- "에러 처리 방식에 대한 설명"

## 🔧 에러 타입별 상태 코드

- `400`: 잘못된 요청 (Bad Request)
- `401`: 인증 실패 (Unauthorized)
- `408`: 요청 시간 초과 (Request Timeout)
- `413`: 요청 엔티티가 너무 큼 (Payload Too Large)
- `422`: 유효성 검사 실패 (Unprocessable Entity)
- `500`: 내부 서버 에러 (Internal Server Error)
- `503`: 서비스 사용 불가 (Service Unavailable)
- `507`: 메모리 부족 (Insufficient Storage)

이제 이 애플리케이션의 다양한 에러들을 경험하고 GitHub 이슈로 등록하여 AI 자동 분류 시스템을 테스트해보세요! 🚀