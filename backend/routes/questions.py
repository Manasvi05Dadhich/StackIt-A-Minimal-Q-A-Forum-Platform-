from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from schemas import QuestionCreate, AnswerCreate, AcceptAnswerRequest
from models import Question, Tag, Answer
from database import get_db

# TEMP mock
def get_current_user():
    class User:
        id = 1
    return User()

router = APIRouter()

@router.post("/questions")
def create_question(data: QuestionCreate, db: Session = Depends(get_db), current_user=Depends(get_current_user)):
    new_question = Question(
        title=data.title,
        description=data.description,
        user_id=current_user.id
    )
    tags_to_add = []
    for tag_name in data.tags:
        tag = db.query(Tag).filter(Tag.name == tag_name).first()
        if not tag:
            tag = Tag(name=tag_name)
            db.add(tag)
            db.commit()
            db.refresh(tag)
        tags_to_add.append(tag)

    new_question.tags = tags_to_add
    db.add(new_question)
    db.commit()
    db.refresh(new_question)
    return {"message": "Question created successfully", "question_id": new_question.id}

@router.post("/answers")
def post_answer(data: AnswerCreate, db: Session = Depends(get_db), current_user=Depends(get_current_user)):
    new_answer = Answer(
        content=data.content,
        question_id=data.question_id,
        user_id=current_user.id
    )
    db.add(new_answer)
    db.commit()
    db.refresh(new_answer)
    return {"message": "Answer submitted successfully", "answer_id": new_answer.id}

@router.post("/answers/accept")
def accept_answer(data: AcceptAnswerRequest, db: Session = Depends(get_db), current_user=Depends(get_current_user)):
    answer = db.query(Answer).filter(Answer.id == data.answer_id).first()

    if not answer:
        raise HTTPException(status_code=404, detail="Answer not found")

    question = db.query(Question).filter(Question.id == answer.question_id).first()
    if not question:
        raise HTTPException(status_code=404, detail="Question not found")

    if question.user_id != current_user.id:
        raise HTTPException(status_code=403, detail="You can only accept answers to your own question")

    # Mark all other answers as not accepted
    db.query(Answer).filter(Answer.question_id == question.id).update({Answer.is_accepted: False})

    # Mark this one as accepted
    answer.is_accepted = True
    db.commit()

    return {"message": "Answer marked as accepted ✅"}
