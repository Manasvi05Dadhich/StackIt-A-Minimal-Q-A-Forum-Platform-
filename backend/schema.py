from pydantic import BaseModel
from typing import List

class QuestionCreate(BaseModel):
    title: str
    description: str
    tags: List[str]

class AnswerCreate(BaseModel):
    question_id: int
    content: str

class AcceptAnswerRequest(BaseModel):
    answer_id: int
