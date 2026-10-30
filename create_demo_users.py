"""Run once after importing database/schema.sql to create staff login accounts."""
from werkzeug.security import generate_password_hash
from app import get_db_connection

accounts = [
    ("admin", "Admin@123", "admin", None),
    ("driver1", "Driver@123", "driver", 1),
    ("driver2", "Driver@123", "driver", 2),
]

conn = get_db_connection()
try:
    cur = conn.cursor()
    for username, password, role, ambulance_id in accounts:
        cur.execute("""
            INSERT INTO users (username, password_hash, role, ambulance_id)
            VALUES (%s, %s, %s, %s)
            ON DUPLICATE KEY UPDATE password_hash=VALUES(password_hash),
              role=VALUES(role), ambulance_id=VALUES(ambulance_id), is_active=1
        """, (username, generate_password_hash(password), role, ambulance_id))
    conn.commit()
    print("Staff users created/updated.")
    print("Admin: admin / Admin@123")
    print("Driver: driver1 / Driver@123")
finally:
    cur.close()
    conn.close()
