from fastapi import APIRouter, HTTPException
from schema import AnswerCreate, AcceptAnswerRequest
from database import get_connection

router = APIRouter()

@router.post("/")
def create_answer(answer: AnswerCreate):
    conn = get_connection()
    cursor = conn.cursor()

    # For now, hardcoding user_id = 1
    cursor.execute("SELECT id FROM questions WHERE id = %s", (answer.question_id,))
    if not cursor.fetchone():
        raise HTTPException(status_code=404, detail="Question not found")

    cursor.execute("INSERT INTO answers (question_id, user_id, content) VALUES (%s, %s, %s)",
                   (answer.question_id, 1, answer.content))
    return {"message": "Answer posted successfully"}

@router.get("/question/{question_id}")
def get_answers_for_question(question_id: int):
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM answers WHERE question_id = %s", (question_id,))
    return {"answers": cursor.fetchall()}

@router.put("/accept")
def accept_answer(req: AcceptAnswerRequest):
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute("UPDATE answers SET is_accepted = TRUE WHERE id = %s", (req.answer_id,))
    if cursor.rowcount == 0:
        raise HTTPException(status_code=404, detail="Answer not found")
    return {"message": "Answer accepted"}
