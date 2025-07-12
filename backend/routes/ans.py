from fastapi import APIRouter, HTTPException, Request
from schema import AnswerCreate, AcceptAnswerRequest
from database import conn, cursor
from routes.auth_routes import decode_token

router = APIRouter()

def get_user_id(request: Request):
    token = request.headers.get("Authorization", "").replace("Bearer ", "")
    user_id = decode_token(token)
    if not user_id:
        raise HTTPException(status_code=401, detail="Unauthorized")
    return user_id

@router.post("/")
def create_answer(request: Request, answer: AnswerCreate):
    user_id = get_user_id(request)

    cursor.execute("SELECT id FROM questions WHERE id = %s", (answer.question_id,))
    if not cursor.fetchone():
        raise HTTPException(status_code=404, detail="Question not found")

    cursor.execute(
        "INSERT INTO answers (question_id, user_id, content) VALUES (%s, %s, %s)",
        (answer.question_id, user_id, answer.content)
    )
    conn.commit()
    return {"message": "Answer posted successfully"}

@router.get("/question/{question_id}")
def get_answers_for_question(question_id: int):
    cursor.execute("SELECT * FROM answers WHERE question_id = %s", (question_id,))
    answers = cursor.fetchall()
    return {"answers": answers}

@router.put("/accept")
def accept_answer(request: Request, req: AcceptAnswerRequest):
    user_id = get_user_id(request)

    # Validate that user owns the question
    cursor.execute("""
        SELECT q.user_id FROM answers a
        JOIN questions q ON a.question_id = q.id
        WHERE a.id = %s
    """, (req.answer_id,))
    row = cursor.fetchone()
    if not row or row['user_id'] != user_id:
        raise HTTPException(status_code=403, detail="Not authorized")

    cursor.execute("UPDATE answers SET is_accepted = TRUE WHERE id = %s", (req.answer_id,))
    if cursor.rowcount == 0:
        raise HTTPException(status_code=404, detail="Answer not found")

    conn.commit()
    return {"message": "Answer accepted"}
