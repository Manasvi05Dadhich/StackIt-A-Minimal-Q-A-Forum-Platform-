from fastapi import APIRouter, Request, HTTPException
from database import cursor
from routes.auth_routes import decode_token

router = APIRouter()

@router.get("/")
def get_notifications(request: Request):
    token = request.headers.get("Authorization", "").replace("Bearer ", "")
    user_id = decode_token(token)
    if not user_id:
        raise HTTPException(status_code=401, detail="Unauthorized")

    cursor.execute("""
        SELECT a.content, q.title, a.created_at
        FROM answers a
        JOIN questions q ON q.id = a.question_id
        WHERE q.user_id = %s
        ORDER BY a.created_at DESC
        LIMIT 5
    """, (user_id,))
    new_answers = cursor.fetchall()

    cursor.execute("""
        SELECT a.content, q.title
        FROM answers a
        JOIN questions q ON q.id = a.question_id
        WHERE a.is_accepted = TRUE AND q.user_id = %s
    """, (user_id,))
    accepted_answers = cursor.fetchall()

    return {
        "new_answers": new_answers,
        "accepted_answers": accepted_answers
    }
