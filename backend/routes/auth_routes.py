from flask import Blueprint, request, jsonify
from werkzeug.security import generate_password_hash, check_password_hash
from utils.database import cursor, conn
from utils.auth import encode_token

auth_bp = Blueprint('auth_bp', __name__)

@auth_bp.route('/auth/register', methods=['POST'])
def register():
    data = request.get_json()
    hashed_pw = generate_password_hash(data['password'])
    cursor.execute("INSERT INTO users (name, email, password) VALUES (%s, %s, %s)",
                   (data['name'], data['email'], hashed_pw))
    conn.commit()
    return jsonify({"message": "User registered successfully"}), 201

@auth_bp.route('/auth/login', methods=['POST'])
def login():
    data = request.get_json()
    cursor.execute("SELECT * FROM users WHERE email = %s", (data['email'],))
    user = cursor.fetchone()
    if not user or not check_password_hash(user['password'], data['password']):
        return jsonify({"error": "Invalid credentials"}), 401
    token = encode_token(user['id'])
    return jsonify({"token": token}), 200
