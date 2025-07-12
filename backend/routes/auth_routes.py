from fastapi import APIRouter, HTTPException
from pydantic import BaseModel
from passlib.hash import bcrypt
import jwt
from datetime import datetime, timedelta
from database import cursor, conn

router = APIRouter()
SECRET_KEY = "stackit-secret"

# ✅ Pydantic models
class UserSignup(BaseModel):
    name: str
    email: str
    password: str

class UserLogin(BaseModel):
    email: str
    password: str

# ✅ Create JWT token
def create_token(user_id: int):
    payload = {
        "sub": user_id,
        "exp": datetime.utcnow() + timedelta(days=1),
        "iat": datetime.utcnow()
    }
    return jwt.encode(payload, SECRET_KEY, algorithm="HS256")

# ✅ Decode JWT token
def decode_token(token: str):
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=["HS256"])
        return payload["sub"]
    except jwt.ExpiredSignatureError:
        return None
    except jwt.InvalidTokenError:
        return None

# ✅ Signup route
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

# ✅ Login route
@router.post("/login")
def login(user: UserLogin):
    cursor.execute("SELECT id, password FROM users WHERE email = %s", (user.email,))
    row = cursor.fetchone()
    if not row or not bcrypt.verify(user.password, row["password"]):
        raise HTTPException(status_code=401, detail="Invalid credentials")

    token = create_token(row["id"])
    return {"token": token}
