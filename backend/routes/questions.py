from flask import Blueprint, jsonify
from utils.database import cursor

questions_bp = Blueprint('questions_bp', __name__)

@questions_bp.route('/questions', methods=['GET'])
def get_questions():
    cursor.execute("SELECT * FROM questions ORDER BY created_at DESC")
    questions = cursor.fetchall()
    return jsonify(questions), 200

@questions_bp.route('/questions/<int:question_id>', methods=['GET'])
def get_question_detail(question_id):
    cursor.execute("SELECT * FROM questions WHERE id = %s", (question_id,))
    question = cursor.fetchone()

    cursor.execute("SELECT * FROM answers WHERE question_id = %s ORDER BY created_at ASC", (question_id,))
    answers = cursor.fetchall()

    return jsonify({
        "question": question,
        "answers": answers
    }), 200
