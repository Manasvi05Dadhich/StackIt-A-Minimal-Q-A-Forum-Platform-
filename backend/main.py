from fastapi import FastAPI
from routes import questions

app = FastAPI()

app.include_router(questions.router)
