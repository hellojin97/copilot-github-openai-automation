# FastAPI Bug Generator Test Script

Write-Host "Bug Generator API Test Starting..." -ForegroundColor Yellow
Write-Host ""

# Check server status
Write-Host "Checking server connection..." -ForegroundColor Cyan
try {
    $response = Invoke-RestMethod -Uri "http://localhost:8000/"
    Write-Host "Server is running successfully!" -ForegroundColor Green
    Write-Host "Available endpoints: $($response.endpoints.Count)" -ForegroundColor White
} catch {
    Write-Host "Cannot connect to server. Please check if server is running." -ForegroundColor Red
    Write-Host "Run server with: uv run uvicorn main:app --host 0.0.0.0 --port 8000" -ForegroundColor Yellow
    exit 1
}

Write-Host ""
Write-Host "Starting error endpoint tests..." -ForegroundColor Yellow

# 1. Random error test
Write-Host ""
Write-Host "1. Random Error Test (/random-error)" -ForegroundColor Cyan
for ($i = 1; $i -le 3; $i++) {
    try {
        $response = Invoke-RestMethod -Uri "http://localhost:8000/random-error"
        Write-Host "   Try $i : Success - $($response.message)" -ForegroundColor Green
    } catch {
        Write-Host "   Try $i : Error occurred (expected) - HTTP $($_.Exception.Response.StatusCode)" -ForegroundColor Red
    }
}

# 2. Divide by zero test
Write-Host ""
Write-Host "2. Divide by Zero Test (/divide)" -ForegroundColor Cyan
try {
    $response = Invoke-RestMethod -Uri "http://localhost:8000/divide"
    Write-Host "   Unexpected: No error occurred." -ForegroundColor Yellow
} catch {
    Write-Host "   Expected error occurred: HTTP $($_.Exception.Response.StatusCode)" -ForegroundColor Green
}

# 3. Database error test
Write-Host ""
Write-Host "3. Database Error Test (/database-error)" -ForegroundColor Cyan
try {
    $response = Invoke-RestMethod -Uri "http://localhost:8000/database-error"
    Write-Host "   Unexpected: No error occurred." -ForegroundColor Yellow
} catch {
    Write-Host "   Expected DB error occurred: HTTP $($_.Exception.Response.StatusCode)" -ForegroundColor Green
}

# 4. Auth error test
Write-Host ""
Write-Host "4. Auth Error Test (/auth-error)" -ForegroundColor Cyan
try {
    $response = Invoke-RestMethod -Uri "http://localhost:8000/auth-error"
    Write-Host "   Unexpected: No error occurred." -ForegroundColor Yellow
} catch {
    Write-Host "   Expected auth error occurred: HTTP $($_.Exception.Response.StatusCode)" -ForegroundColor Green
}

# 5. Timeout error test
Write-Host ""
Write-Host "5. Timeout Error Test (/timeout)" -ForegroundColor Cyan
for ($i = 1; $i -le 3; $i++) {
    try {
        $response = Invoke-RestMethod -Uri "http://localhost:8000/timeout"
        Write-Host "   Try $i : Success - $($response.message)" -ForegroundColor Green
    } catch {
        Write-Host "   Try $i : Timeout error occurred - HTTP $($_.Exception.Response.StatusCode)" -ForegroundColor Red
    }
}

# 6. Validation error test (POST)
Write-Host ""
Write-Host "6. Validation Error Test (POST /validation-error)" -ForegroundColor Cyan

# Test with invalid data
$invalidBody = @{
    name = "error"
    age = -5
    email = "invalid-email"
} | ConvertTo-Json

try {
    $response = Invoke-RestMethod -Uri "http://localhost:8000/validation-error" -Method POST -Body $invalidBody -ContentType "application/json"
    Write-Host "   Unexpected: Validation passed." -ForegroundColor Yellow
} catch {
    Write-Host "   Expected validation error occurred: HTTP $($_.Exception.Response.StatusCode)" -ForegroundColor Green
}

# Test with valid data
$validBody = @{
    name = "testuser"
    age = 25
    email = "test@example.com"
} | ConvertTo-Json

try {
    $response = Invoke-RestMethod -Uri "http://localhost:8000/validation-error" -Method POST -Body $validBody -ContentType "application/json"
    Write-Host "   Valid data processed successfully: $($response.message)" -ForegroundColor Green
} catch {
    Write-Host "   Error with valid data: HTTP $($_.Exception.Response.StatusCode)" -ForegroundColor Red
}

# 7. Calculate API test (POST)
Write-Host ""
Write-Host "7. Calculate API Test (POST /calculate)" -ForegroundColor Cyan

# Test divide by zero
$divideByZero = @{
    a = 10
    b = 0
    operation = "/"
} | ConvertTo-Json

try {
    $response = Invoke-RestMethod -Uri "http://localhost:8000/calculate" -Method POST -Body $divideByZero -ContentType "application/json"
    Write-Host "   Unexpected: Divide by zero succeeded." -ForegroundColor Yellow
} catch {
    Write-Host "   Expected divide by zero error: HTTP $($_.Exception.Response.StatusCode)" -ForegroundColor Green
}

# Test normal calculation
$normalCalc = @{
    a = 10
    b = 5
    operation = "+"
} | ConvertTo-Json

try {
    $response = Invoke-RestMethod -Uri "http://localhost:8000/calculate" -Method POST -Body $normalCalc -ContentType "application/json"
    Write-Host "   Normal calculation success: $($response.calculation) = $($response.result)" -ForegroundColor Green
} catch {
    Write-Host "   Error with normal calculation: HTTP $($_.Exception.Response.StatusCode)" -ForegroundColor Red
}

# 8. Health check test
Write-Host ""
Write-Host "8. Health Check Test (/health)" -ForegroundColor Cyan
for ($i = 1; $i -le 5; $i++) {
    try {
        $response = Invoke-RestMethod -Uri "http://localhost:8000/health"
        Write-Host "   Try $i : Healthy - $($response.status)" -ForegroundColor Green
    } catch {
        Write-Host "   Try $i : System issue - HTTP $($_.Exception.Response.StatusCode)" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "All tests completed!" -ForegroundColor Yellow
Write-Host ""
Write-Host "GitHub Issue Suggestions:" -ForegroundColor Cyan
Write-Host "  * '[BUG] API returns 500 error intermittently'" -ForegroundColor White
Write-Host "  * '[BUG] Divide by zero error handling needs improvement'" -ForegroundColor White
Write-Host "  * '[FEATURE] Add error logging system'" -ForegroundColor White
Write-Host "  * '[QUESTION] When does timeout error occur?'" -ForegroundColor White
Write-Host ""
Write-Host "API Documentation: http://localhost:8000/docs" -ForegroundColor Green