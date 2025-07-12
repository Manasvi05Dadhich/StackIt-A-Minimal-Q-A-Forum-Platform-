import pymysql
from pymysql.cursors import DictCursor

conn = pymysql.connect(
    host="sql12.freesqldatabase.com",
    user="sql12789609",
    password="bzAi83qvxw", 
    database="sql12789609",
    port=3306,
    cursorclass=DictCursor
)

cursor = conn.cursor()
