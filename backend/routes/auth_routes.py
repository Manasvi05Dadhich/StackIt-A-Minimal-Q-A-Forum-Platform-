from fastapi import APIRouter, HTTPException, Request
from pydantic import BaseModel
from passlib.hash import bcrypt
import jwt
from datetime import datetime, timedelta
from database import cursor, conn

router = APIRouter()
SECRET_KEY = "stackit-secret"

# User input schemas
class UserSignup(BaseModel):
    name: str
    email: str
    password: str

class UserLogin(BaseModel):
    email: str
    password: str

# JWT token creation
def create_token(user_id: int):
    payload = {
        "sub": user_id,
        "exp": datetime.utcnow() + timedelta(days=1),
        "iat": datetime.utcnow()
    }
    token = jwt.encode(payload, SECRET_KEY, algorithm="HS256")
    if isinstance(token, bytes):  # For Python 3.9+
        token = token.decode()
    return token

# JWT token decoding with debug prints
def decode_token(token: str):
    try:
        print("Decoding token:", token)  # Debug print
        payload = jwt.decode(token, SECRET_KEY, algorithms=["HS256"])
        print("Payload:", payload)       # Debug print
        return payload["sub"]
    except jwt.ExpiredSignatureError:
        print("Token expired")           # Debug print
        return None
    except jwt.InvalidTokenError as e:
        print("Invalid token:", e)       # Debug print
        return None

# Route: Sign up
@router.post("/signup")
def signup(user: UserSignup):
    cursor.execute("SELECT id FROM users WHERE email = %s", (user.email,))
    if cursor.fetchone():
        raise HTTPException(status_code=400, detail="Email already registered")

    hashed_pw = bcrypt.hash(user.password)
    cursor.execute("INSERT INTO users (name, email, password) VALUES (%s, %s, %s)",
                   (user.name, user.email, hashed_pw))
    conn.commit()
    return {"message": "User registered"}

# Route: Login
@router.post("/login")
def login(user: UserLogin):
    cursor.execute("SELECT id, password FROM users WHERE email = %s", (user.email,))
    row = cursor.fetchone()
    if not row:
        raise HTTPException(status_code=401, detail="Invalid credentials")

    # Using DictCursor, so row is a dictionary
    user_id, hashed_password = row["id"], row["password"]
    if not bcrypt.verify(user.password, hashed_password):
        raise HTTPException(status_code=401, detail="Invalid credentials")

    token = create_token(user_id)
    return {"token": token}

# Route: Test Auth (send token in header as "Authorization: Bearer <token>")
@router.get("/test-auth")
def test_auth(request: Request):
    token = request.headers.get("Authorization", "").replace("Bearer ", "")
    print("Received Token in Header:", token)  # Debug
    user_id = decode_token(token)
    if not user_id:
        raise HTTPException(status_code=401, detail="Unauthorized")
    return {"user_id": user_id}
