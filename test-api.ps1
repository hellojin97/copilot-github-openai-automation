# FastAPI Bug Generator Test Script

Write-Host "Bug Generator API Test Starting..." -ForegroundColor Yellow
Write-Host ""

# 서버 상태 확인
Write-Host "📡 서버 연결 확인..." -ForegroundColor Cyan
try {
    $response = Invoke-RestMethod -Uri "http://localhost:8000/"
    Write-Host "✅ 서버가 정상 작동 중입니다!" -ForegroundColor Green
    Write-Host "사용 가능한 엔드포인트: $($response.endpoints.Count)개" -ForegroundColor White
} catch {
    Write-Host "❌ 서버에 연결할 수 없습니다. 서버가 실행 중인지 확인하세요." -ForegroundColor Red
    Write-Host "서버 실행 명령: uv run uvicorn main:app --host 0.0.0.0 --port 8000" -ForegroundColor Yellow
    exit 1
}

Write-Host ""
Write-Host "🧪 에러 엔드포인트 테스트를 시작합니다..." -ForegroundColor Yellow

# 1. 랜덤 에러 테스트
Write-Host ""
Write-Host "1️⃣ 랜덤 에러 테스트 (/random-error)" -ForegroundColor Cyan
for ($i = 1; $i -le 3; $i++) {
    try {
        $response = Invoke-RestMethod -Uri "http://localhost:8000/random-error"
        Write-Host "   시도 $i : ✅ 성공 - $($response.message)" -ForegroundColor Green
    } catch {
        Write-Host "   시도 $i : ❌ 에러 발생 (예상됨) - HTTP $($_.Exception.Response.StatusCode)" -ForegroundColor Red
    }
}

# 2. 0으로 나누기 에러 테스트
Write-Host ""
Write-Host "2️⃣ 0으로 나누기 에러 테스트 (/divide)" -ForegroundColor Cyan
try {
    $response = Invoke-RestMethod -Uri "http://localhost:8000/divide"
    Write-Host "   ❓ 예상과 다름: 에러가 발생하지 않았습니다." -ForegroundColor Yellow
} catch {
    Write-Host "   ✅ 예상된 에러 발생: HTTP $($_.Exception.Response.StatusCode)" -ForegroundColor Green
}

# 3. 데이터베이스 에러 테스트
Write-Host ""
Write-Host "3️⃣ 데이터베이스 연결 에러 테스트 (/database-error)" -ForegroundColor Cyan
try {
    $response = Invoke-RestMethod -Uri "http://localhost:8000/database-error"
    Write-Host "   ❓ 예상과 다름: 에러가 발생하지 않았습니다." -ForegroundColor Yellow
} catch {
    Write-Host "   ✅ 예상된 DB 에러 발생: HTTP $($_.Exception.Response.StatusCode)" -ForegroundColor Green
}

# 4. 인증 에러 테스트
Write-Host ""
Write-Host "4️⃣ 인증 에러 테스트 (/auth-error)" -ForegroundColor Cyan
try {
    $response = Invoke-RestMethod -Uri "http://localhost:8000/auth-error"
    Write-Host "   ❓ 예상과 다름: 에러가 발생하지 않았습니다." -ForegroundColor Yellow
} catch {
    Write-Host "   ✅ 예상된 인증 에러 발생: HTTP $($_.Exception.Response.StatusCode)" -ForegroundColor Green
}

# 5. 타임아웃 에러 테스트 (여러 번 시도)
Write-Host ""
Write-Host "5️⃣ 타임아웃 에러 테스트 (/timeout)" -ForegroundColor Cyan
for ($i = 1; $i -le 3; $i++) {
    try {
        $response = Invoke-RestMethod -Uri "http://localhost:8000/timeout"
        Write-Host "   시도 $i : ✅ 성공 - $($response.message)" -ForegroundColor Green
    } catch {
        Write-Host "   시도 $i : ❌ 타임아웃 에러 발생 - HTTP $($_.Exception.Response.StatusCode)" -ForegroundColor Red
    }
}

# 6. 유효성 검사 에러 테스트 (POST)
Write-Host ""
Write-Host "6️⃣ 유효성 검사 에러 테스트 (POST /validation-error)" -ForegroundColor Cyan

# 잘못된 데이터로 테스트
$invalidBody = @{
    name = "error"
    age = -5
    email = "invalid-email"
} | ConvertTo-Json

try {
    $response = Invoke-RestMethod -Uri "http://localhost:8000/validation-error" -Method POST -Body $invalidBody -ContentType "application/json"
    Write-Host "   ❓ 예상과 다름: 유효성 검사를 통과했습니다." -ForegroundColor Yellow
} catch {
    Write-Host "   ✅ 예상된 유효성 검사 에러 발생: HTTP $($_.Exception.Response.StatusCode)" -ForegroundColor Green
}

# 올바른 데이터로 테스트
$validBody = @{
    name = "테스트유저"
    age = 25
    email = "test@example.com"
} | ConvertTo-Json

try {
    $response = Invoke-RestMethod -Uri "http://localhost:8000/validation-error" -Method POST -Body $validBody -ContentType "application/json"
    Write-Host "   ✅ 올바른 데이터 처리 성공: $($response.message)" -ForegroundColor Green
} catch {
    Write-Host "   ❌ 올바른 데이터인데 에러 발생: HTTP $($_.Exception.Response.StatusCode)" -ForegroundColor Red
}

# 7. 계산 API 테스트 (POST)
Write-Host ""
Write-Host "7️⃣ 계산 API 테스트 (POST /calculate)" -ForegroundColor Cyan

# 0으로 나누기 테스트
$divideByZero = @{
    a = 10
    b = 0
    operation = "/"
} | ConvertTo-Json

try {
    $response = Invoke-RestMethod -Uri "http://localhost:8000/calculate" -Method POST -Body $divideByZero -ContentType "application/json"
    Write-Host "   ❓ 예상과 다름: 0으로 나누기가 성공했습니다." -ForegroundColor Yellow
} catch {
    Write-Host "   ✅ 예상된 0으로 나누기 에러 발생: HTTP $($_.Exception.Response.StatusCode)" -ForegroundColor Green
}

# 정상적인 계산 테스트
$normalCalc = @{
    a = 10
    b = 5
    operation = "+"
} | ConvertTo-Json

try {
    $response = Invoke-RestMethod -Uri "http://localhost:8000/calculate" -Method POST -Body $normalCalc -ContentType "application/json"
    Write-Host "   ✅ 정상적인 계산 성공: $($response.calculation) = $($response.result)" -ForegroundColor Green
} catch {
    Write-Host "   ❌ 정상적인 계산인데 에러 발생: HTTP $($_.Exception.Response.StatusCode)" -ForegroundColor Red
}

# 8. 헬스체크 테스트
Write-Host ""
Write-Host "8️⃣ 헬스체크 테스트 (/health)" -ForegroundColor Cyan
for ($i = 1; $i -le 5; $i++) {
    try {
        $response = Invoke-RestMethod -Uri "http://localhost:8000/health"
        Write-Host "   시도 $i : ✅ 건강함 - $($response.status)" -ForegroundColor Green
    } catch {
        Write-Host "   시도 $i : ❌ 시스템 문제 발생 - HTTP $($_.Exception.Response.StatusCode)" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "🎉 모든 테스트가 완료되었습니다!" -ForegroundColor Yellow
Write-Host ""
Write-Host "📋 GitHub 이슈 등록 제안:" -ForegroundColor Cyan
Write-Host "  • '[BUG] API 호출 시 간헐적으로 500 에러 발생'" -ForegroundColor White
Write-Host "  • '[BUG] 0으로 나누기 에러 처리 개선 필요'" -ForegroundColor White
Write-Host "  • '[FEATURE] 에러 로깅 시스템 추가 요청'" -ForegroundColor White
Write-Host "  • '[QUESTION] 타임아웃 에러는 언제 발생하나요?'" -ForegroundColor White
Write-Host ""
Write-Host "🌐 API 문서 확인: http://localhost:8000/docs" -ForegroundColor Green