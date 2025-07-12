# models.py (complete)
from sqlalchemy import Column, Integer, String, Text, ForeignKey, Table, DateTime, Boolean, func
from sqlalchemy.orm import relationship
from database import Base

question_tags = Table(
    "question_tags",
    Base.metadata,
    Column("question_id", Integer, ForeignKey("questions.id")),
    Column("tag_id", Integer, ForeignKey("tags.id"))
)

class Question(Base):
    __tablename__ = "questions"
    id = Column(Integer, primary_key=True, index=True)
    title = Column(String(255), nullable=False)
    description = Column(Text, nullable=False)
    user_id = Column(Integer, ForeignKey("users.id"))
    created_at = Column(DateTime, default=func.now())
    tags = relationship("Tag", secondary=question_tags, back_populates="questions")

class Tag(Base):
    __tablename__ = "tags"
    id = Column(Integer, primary_key=True, index=True)
    name = Column(String(50), unique=True)
    questions = relationship("Question", secondary=question_tags, back_populates="tags")

class Answer(Base):
    __tablename__ = "answers"
    id = Column(Integer, primary_key=True, index=True)
    content = Column(Text, nullable=False)
    question_id = Column(Integer, ForeignKey("questions.id"))
    user_id = Column(Integer, ForeignKey("users.id"))
    created_at = Column(DateTime, default=func.now())
    is_accepted = Column(Boolean, default=False)
