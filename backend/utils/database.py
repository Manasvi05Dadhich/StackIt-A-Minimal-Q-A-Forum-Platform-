import pymysql
from pymysql.cursors import DictCursor

conn = pymysql.connect(
    host='localhost',
    user='root',
    password='Him@nshu12',
    database='stackit',
    cursorclass=DictCursor,
    autocommit=True
)

cursor = conn.cursor()
