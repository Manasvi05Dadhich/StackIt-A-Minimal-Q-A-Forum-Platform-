from fastapi import APIRouter, HTTPException, Request
from schema import QuestionCreate
from database import conn, cursor
from routes.auth_routes import decode_token

router = APIRouter()

def get_user_id(request: Request):
    token = request.headers.get("Authorization", "")
    token = token.replace("Bearer ", "").strip()
    user_id = decode_token(token)
    if not user_id:
        raise HTTPException(status_code=401, detail="Unauthorized")
    return user_id

@router.post("/")
def create_question(request: Request, question: QuestionCreate):
    user_id = get_user_id(request)

    cursor.execute(
        "INSERT INTO questions (user_id, title, description) VALUES (%s, %s, %s)",
        (user_id, question.title, question.description)
    )
    question_id = cursor.lastrowid

    for tag in question.tags:
        cursor.execute("SELECT id FROM tags WHERE name = %s", (tag,))
        tag_row = cursor.fetchone()
        if tag_row:
            tag_id = tag_row['id']
        else:
            cursor.execute("INSERT INTO tags (name) VALUES (%s)", (tag,))
            tag_id = cursor.lastrowid

        cursor.execute(
            "INSERT INTO question_tags (question_id, tag_id) VALUES (%s, %s)",
            (question_id, tag_id)
        )

    conn.commit()
    return {"message": "Question created", "question_id": question_id}

@router.get("/")
def get_all_questions():
    cursor.execute("SELECT * FROM questions")
    questions = cursor.fetchall()
    return {"questions": questions}

@router.get("/{question_id}")
def get_question_by_id(question_id: int):
    cursor.execute("SELECT * FROM questions WHERE id = %s", (question_id,))
    question = cursor.fetchone()
    if not question:
        raise HTTPException(status_code=404, detail="Question not found")
    return question
