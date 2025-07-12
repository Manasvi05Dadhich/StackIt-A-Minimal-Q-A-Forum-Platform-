from flask import Blueprint, jsonify
from utils.auth import jwt_required
from utils.database import cursor

user_bp = Blueprint('user_bp', __name__)

@user_bp.route('/me', methods=['GET'])
@jwt_required
def get_profile(user_id):
    cursor.execute("SELECT id, name, email FROM users WHERE id = %s", (user_id,))
    user = cursor.fetchone()
    if user:
        return jsonify(user), 200
    return jsonify({"error": "User not found"}), 404
