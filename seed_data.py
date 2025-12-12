import bcrypt
from flask import Flask
from flask_mysqldb import MySQL

app = Flask(__name__)

# Konfigurasi Database (Ganti dengan punya Anda!)
app.config['MYSQL_HOST'] = 'localhost'
app.config['MYSQL_USER'] = 'root'
app.config['MYSQL_PASSWORD'] = ''
app.config['MYSQL_DB'] = 'disbudpar'
app.config['MYSQL_CURSORCLASS'] = 'DictCursor'

mysql = MySQL(app)

def create_admin_user(username, password):
    # Hash password menggunakan bcrypt
    salt = bcrypt.gensalt()
    hashed_password = bcrypt.hashpw(password.encode('utf-8'), salt)

    # Simpan ke database
    cur = mysql.connection.cursor()
    try:
        cur.execute("INSERT INTO admin (username, password_hash, password_salt) VALUES (%s, %s, %s)",
                    (username, hashed_password.decode('utf-8'), salt.decode('utf-8')))
        mysql.connection.commit()
        print(f"User admin '{username}' berhasil dibuat.")
    except Exception as e:
        print(f"Error membuat user admin: {e}")
    finally:
        cur.close()

if __name__ == '__main__':
    with app.app_context():
        # Username dan Password Awal
        default_username = 'admin'
        default_password = 'DisbudparJaya'

        # Buat User Admin (jika belum ada)
        create_admin_user(default_username, default_password)