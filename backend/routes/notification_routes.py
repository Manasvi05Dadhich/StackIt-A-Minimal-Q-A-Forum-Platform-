from fastapi import APIRouter
from utils.database import get_connection

router = APIRouter()

@router.get("/")
def get_notifications():
    # Placeholder route for notifications
    return {"notifications": []}
