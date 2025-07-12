from fastapi import APIRouter, HTTPException
from database import conn, cursor  # ✅ Use global DB connection

router = APIRouter()

@router.get("/")
def list_all_tags():
    cursor.execute("SELECT * FROM tags")
    return {"tags": cursor.fetchall()}

@router.get("/{tag_name}")
def get_questions_by_tag(tag_name: str):
    cursor.execute("SELECT id FROM tags WHERE name = %s", (tag_name,))
    tag = cursor.fetchone()

    if not tag:
        raise HTTPException(status_code=404, detail="Tag not found")

    tag_id = tag["id"]
    cursor.execute("""
        SELECT q.* FROM questions q
        JOIN question_tags qt ON q.id = qt.question_id
        WHERE qt.tag_id = %s
    """, (tag_id,))
    return {"questions": cursor.fetchall()}
