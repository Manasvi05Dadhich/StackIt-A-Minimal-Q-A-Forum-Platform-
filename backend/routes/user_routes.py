from fastapi import APIRouter, HTTPException, Request
from database import conn, cursor
from routes.auth_routes import decode_token

router = APIRouter()

def get_user_id(request: Request):
    token = request.headers.get("Authorization", "").replace("Bearer ", "")
    user_id = decode_token(token)
    if not user_id:
        raise HTTPException(status_code=401, detail="Unauthorized")
    return user_id

@router.get("/profile")
def get_current_user_profile(request: Request):
    user_id = get_user_id(request)

    cursor.execute("SELECT id, name, email, created_at FROM users WHERE id = %s", (user_id,))
    user = cursor.fetchone()
    
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    return user

@router.get("/{user_id}")
def get_user(user_id: int):
    cursor.execute("SELECT id, name, email, created_at FROM users WHERE id = %s", (user_id,))
    user = cursor.fetchone()
    
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    return user

@router.get("/{user_id}/questions")
def get_user_questions(user_id: int):
    cursor.execute("SELECT * FROM questions WHERE user_id = %s", (user_id,))
    questions = cursor.fetchall()
    return {"questions": questions}

@router.get("/{user_id}/answers")
def get_user_answers(user_id: int):
    cursor.execute("SELECT * FROM answers WHERE user_id = %s", (user_id,))
    answers = cursor.fetchall()
    return {"answers": answers}
