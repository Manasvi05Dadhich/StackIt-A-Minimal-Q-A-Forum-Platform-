from fastapi import APIRouter
from database import cursor

router = APIRouter()

@router.get("/test-db")
def test_db():
    cursor.execute("SELECT 1 + 1 AS result")
    return {"db_status": "connected", "result": cursor.fetchone()}
