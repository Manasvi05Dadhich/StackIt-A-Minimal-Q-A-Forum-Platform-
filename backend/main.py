from fastapi import FastAPI
from pydantic import BaseModel
from typing import List

from routes.questions import router as question_router
from routes.ans import router as answer_router
from routes.tags import router as tag_router
from routes.notification_routes import router as notif_router
from routes.auth_routes import router as auth_router
from routes.user_routes import router as user_router
from routes import test

from fastapi.middleware.cors import CORSMiddleware

app = FastAPI()
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Adjust this in production
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Main routers
app.include_router(question_router, prefix="/questions", tags=["Questions"])
app.include_router(answer_router, prefix="/answers", tags=["Answers"])
app.include_router(tag_router, prefix="/tags", tags=["Tags"])
app.include_router(notif_router, prefix="/notifications", tags=["Notifications"])
app.include_router(auth_router, prefix="/auth", tags=["Auth"])
app.include_router(user_router, prefix="/users", tags=["Users"])
app.include_router(test.router)

# 🚨 Additional test POST endpoint (to avoid route conflict)
class Question(BaseModel):
    title: str
    description: str
    tags: List[str]

@app.post("/submit-question")  # New endpoint
async def post_question(q: Question):
    print("Received:", q)
    return {"message": "Question posted successfully"}
