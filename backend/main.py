from flask import Flask
from routes.auth_routes import auth_bp
from routes.user_routes import user_bp
from routes.notification_routes import notif_bp
from routes.questions import questions_bp

app = Flask(__name__)

app.register_blueprint(auth_bp)
app.register_blueprint(user_bp)
app.register_blueprint(notif_bp)
app.register_blueprint(questions_bp)

if __name__ == '__main__':
    app.run(debug=True)
