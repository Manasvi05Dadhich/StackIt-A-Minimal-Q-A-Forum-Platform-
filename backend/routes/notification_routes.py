from flask import Blueprint, request, jsonify
from utils.auth import jwt_required
from utils.database import cursor, conn

notif_bp = Blueprint('notif_bp', __name__)

@notif_bp.route('/notifications', methods=['GET'])
@jwt_required
def get_notifications(user_id):
    cursor.execute("SELECT * FROM notifications WHERE user_id = %s ORDER BY created_at DESC", (user_id,))
    notifications = cursor.fetchall()
    return jsonify(notifications), 200

@notif_bp.route('/notifications', methods=['POST'])
@jwt_required
def create_notification(user_id):
    data = request.get_json()
    cursor.execute("INSERT INTO notifications (user_id, message) VALUES (%s, %s)", 
                   (data['user_id'], data['message']))
    conn.commit()
    return jsonify({"message": "Notification created"}), 201
