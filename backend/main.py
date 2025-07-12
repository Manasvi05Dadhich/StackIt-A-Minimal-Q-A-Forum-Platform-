from fastapi import FastAPI
from routes.questions import router as question_router
from routes.ans import router as answer_router
from routes.tags import router as tag_router
from routes.notification_routes import router as notif_router

app = FastAPI()

app.include_router(question_router, prefix="/questions", tags=["Questions"])
app.include_router(answer_router, prefix="/answers", tags=["Answers"])
app.include_router(tag_router, prefix="/tags", tags=["Tags"])
app.include_router(notif_router, prefix="/notifications", tags=["Notifications"])


