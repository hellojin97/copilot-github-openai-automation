from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import random
import time
from typing import Optional

app = FastAPI(
    title="🐛 Bug Generator API",
    description="의도적으로 다양한 에러를 발생시키는 FastAPI 애플리케이션입니다. GitHub 이슈 등록 테스트용입니다.",
    version="1.0.0"
)

class UserRequest(BaseModel):
    name: str
    age: Optional[int] = None
    email: Optional[str] = None

class CalculationRequest(BaseModel):
    a: float
    b: float
    operation: str

@app.get("/")
async def root():
    """기본 엔드포인트 - 정상 작동"""
    return {
        "message": "🐛 Bug Generator API에 오신 것을 환영합니다!",
        "endpoints": {
            "/random-error": "랜덤한 에러 발생",
            "/divide": "0으로 나누기 에러",
            "/timeout": "타임아웃 에러 시뮬레이션",
            "/database-error": "데이터베이스 연결 에러",
            "/validation-error": "유효성 검사 에러",
            "/auth-error": "인증 에러",
            "/memory-error": "메모리 부족 에러",
            "/calculate": "계산 API (POST)"
        }
    }

@app.get("/random-error")
async def random_error():
    """랜덤하게 다양한 에러를 발생시킵니다"""
    errors = [
        lambda: (_ for _ in ()).throw(ValueError("예상치 못한 값 오류가 발생했습니다!")),
        lambda: (_ for _ in ()).throw(TypeError("타입 오류: 호환되지 않는 데이터 타입입니다!")),
        lambda: (_ for _ in ()).throw(KeyError("필수 키를 찾을 수 없습니다: 'important_key'")),
        lambda: (_ for _ in ()).throw(IndexError("리스트 인덱스가 범위를 벗어났습니다!")),
        lambda: (_ for _ in ()).throw(AttributeError("'NoneType' 객체에 'nonexistent_attribute' 속성이 없습니다!")),
    ]
    
    # 30% 확률로 성공, 70% 확률로 에러
    if random.random() < 0.3:
        return {"message": "🍀 운이 좋으시네요! 이번에는 성공했습니다."}
    
    # 랜덤한 에러 발생
    error_func = random.choice(errors)
    error_func()

@app.get("/divide")
async def divide_by_zero():
    """의도적으로 0으로 나누기 에러를 발생시킵니다"""
    try:
        result = 10 / 0
        return {"result": result}
    except ZeroDivisionError as e:
        raise HTTPException(
            status_code=500,
            detail=f"🔥 치명적인 수학 오류: {str(e)} - 0으로 나누기는 불가능합니다!"
        )

@app.get("/timeout")
async def timeout_simulation():
    """타임아웃 에러를 시뮬레이션합니다"""
    # 50% 확률로 긴 대기 시간
    if random.random() < 0.5:
        raise HTTPException(
            status_code=408,
            detail="⏰ 요청 시간 초과: 서버가 응답하지 않습니다. 네트워크 연결을 확인해주세요."
        )
    
    # 짧은 대기 후 성공
    time.sleep(0.1)
    return {"message": "✅ 성공적으로 처리되었습니다."}

@app.get("/database-error")
async def database_error():
    """데이터베이스 연결 에러를 시뮬레이션합니다"""
    raise HTTPException(
        status_code=503,
        detail="💾 데이터베이스 연결 실패: 'users' 테이블에 접근할 수 없습니다. DB 서버가 다운되었을 수 있습니다."
    )

@app.post("/validation-error")
async def validation_error(user: UserRequest):
    """유효성 검사 에러를 발생시킵니다"""
    if user.age and user.age < 0:
        raise HTTPException(
            status_code=422,
            detail="🚫 유효성 검사 실패: 나이는 음수일 수 없습니다."
        )
    
    if user.email and "@" not in user.email:
        raise HTTPException(
            status_code=422,
            detail="📧 유효성 검사 실패: 올바른 이메일 형식이 아닙니다."
        )
    
    if user.name.lower() == "error":
        raise HTTPException(
            status_code=400,
            detail="⚠️ 금지된 사용자명: 'error'는 시스템 예약어입니다."
        )
    
    return {"message": f"✅ 사용자 '{user.name}' 등록이 완료되었습니다."}

@app.get("/auth-error")
async def auth_error():
    """인증 에러를 발생시킵니다"""
    raise HTTPException(
        status_code=401,
        detail="🔐 인증 실패: 유효하지 않은 토큰입니다. 다시 로그인해주세요."
    )

@app.get("/memory-error")
async def memory_error():
    """메모리 부족 에러를 시뮬레이션합니다"""
    raise HTTPException(
        status_code=507,
        detail="🧠 메모리 부족: 서버 메모리가 부족하여 요청을 처리할 수 없습니다."
    )

@app.post("/calculate")
async def calculate(calc: CalculationRequest):
    """계산 API - 다양한 에러 케이스 포함"""
    
    if calc.operation not in ["+", "-", "*", "/"]:
        raise HTTPException(
            status_code=400,
            detail=f"🧮 지원하지 않는 연산자: '{calc.operation}'. 사용 가능한 연산자: +, -, *, /"
        )
    
    try:
        if calc.operation == "+":
            result = calc.a + calc.b
        elif calc.operation == "-":
            result = calc.a - calc.b
        elif calc.operation == "*":
            result = calc.a * calc.b
        elif calc.operation == "/":
            if calc.b == 0:
                raise HTTPException(
                    status_code=400,
                    detail="🚫 0으로 나누기 오류: 분모가 0일 수 없습니다."
                )
            result = calc.a / calc.b
        
        # 매우 큰 수의 경우 에러
        if abs(result) > 1e10:
            raise HTTPException(
                status_code=413,
                detail="📊 계산 결과가 너무 큽니다. 더 작은 수를 사용해주세요."
            )
        
        return {
            "calculation": f"{calc.a} {calc.operation} {calc.b}",
            "result": result,
            "status": "success"
        }
        
    except Exception as e:
        raise HTTPException(
            status_code=500,
            detail=f"⚡ 계산 중 예상치 못한 오류가 발생했습니다: {str(e)}"
        )

@app.get("/health")
async def health_check():
    """헬스체크 엔드포인트"""
    # 80% 확률로 건강, 20% 확률로 문제
    if random.random() < 0.8:
        return {
            "status": "healthy",
            "message": "💚 모든 시스템이 정상 작동 중입니다.",
            "timestamp": time.time()
        }
    else:
        raise HTTPException(
            status_code=503,
            detail="❤️‍🩹 시스템 상태 불량: 일부 서비스에 문제가 있습니다."
        )

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)