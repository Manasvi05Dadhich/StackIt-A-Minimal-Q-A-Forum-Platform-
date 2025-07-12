from fastapi import APIRouter, HTTPException
from database import get_connection

router = APIRouter()

@router.get("/")
def list_all_tags():
    conn = get_connection()
    if not conn:
        raise HTTPException(status_code=500, detail="Database connection failed")
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT * FROM tags")
    return {"tags": cursor.fetchall()}

@router.get("/{tag_name}")
def get_questions_by_tag(tag_name: str):
    conn = get_connection()
    if not conn:
        raise HTTPException(status_code=500, detail="Database connection failed")
    cursor = conn.cursor(dictionary=True)

    cursor.execute("SELECT id FROM tags WHERE name = %s", (tag_name,))
    tag = cursor.fetchone()
    if not tag:
        raise HTTPException(status_code=404, detail="Tag not found")

    tag_id = tag[0] if isinstance(tag, tuple) else tag['id']
    cursor.execute("""
        SELECT q.* FROM questions q
        JOIN question_tags qt ON q.id = qt.question_id
        WHERE qt.tag_id = %s
    """, (tag_id,))  # type: ignore
    return {"questions": cursor.fetchall()}

