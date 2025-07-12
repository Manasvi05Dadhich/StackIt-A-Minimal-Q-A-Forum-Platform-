from fastapi import APIRouter, HTTPException, Depends
from schema import QuestionCreate
from database import get_connection

router = APIRouter()

@router.post("/")
def create_question(question: QuestionCreate):
    conn = get_connection()
    cursor = conn.cursor()

    # For now, hardcoding user_id = 1
    cursor.execute("INSERT INTO questions (user_id, title, description) VALUES (%s, %s, %s)",
                   (1, question.title, question.description))
    question_id = cursor.lastrowid

    for tag in question.tags:
        cursor.execute("SELECT id FROM tags WHERE name = %s", (tag,))
        tag_row = cursor.fetchone()
        if tag_row:
            tag_id = tag_row['id']
        else:
            cursor.execute("INSERT INTO tags (name) VALUES (%s)", (tag,))
            tag_id = cursor.lastrowid
        cursor.execute("INSERT INTO question_tags (question_id, tag_id) VALUES (%s, %s)", (question_id, tag_id))

    return {"message": "Question created", "question_id": question_id}


@router.get("/")
def get_all_questions():
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM questions")
    questions = cursor.fetchall()
    return {"questions": questions}


@router.get("/{question_id}")
def get_question_by_id(question_id: int):
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM questions WHERE id = %s", (question_id,))
    question = cursor.fetchone()
    if not question:
        raise HTTPException(status_code=404, detail="Question not found")
    return question
