import mysql.connector

# Step 1: Connect to the database
try:
    db = mysql.connector.connect(
        host="localhost",
        port=3306,
        user="root",
        password="Him@nshu12",
        database="stackit"
    )
    print("✅ Connected to the MySQL database!")
except mysql.connector.Error as err:
    print("❌ Connection failed:", err)
    exit()

cursor = db.cursor()

# Step 2: Create a test table (if not already exists)
cursor.execute("""
CREATE TABLE IF NOT EXISTS test_users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100)
)
""")
print("✅ Table created or already exists.")

# Step 3: Insert sample data
insert_query = "INSERT INTO test_users (name, email) VALUES (%s, %s)"
cursor.execute(insert_query, ("Tanu", "tanu@example.com"))
db.commit()
print(f"✅ {cursor.rowcount} row inserted.")

# Step 4: Read and display data
cursor.execute("SELECT * FROM test_users")
rows = cursor.fetchall()
print("📋 Records:")
for row in rows:
    print(row)

# Step 5: Cleanup
cursor.close()
db.close()
print("🔒 Connection closed.")
