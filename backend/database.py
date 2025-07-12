import mysql.connector
from mysql.connector import Error

# Database configuration
DB_CONFIG = {
    'host': 'localhost',
    'user': 'root',
    'password': '',
    'database': 'stackit'
}

def get_connection():
    try:
        conn = mysql.connector.connect(**DB_CONFIG)
        return conn
    except Error as e:
        print(f"Error connecting to database: {e}")
        return None

# Legacy connection for backward compatibility
try:
    conn = mysql.connector.connect(**DB_CONFIG)
    cursor = conn.cursor(dictionary=True)
    print("Database connected successfully")
except Error as e:
    print(f"Error connecting to database: {e}")
    conn = None
    cursor = None 