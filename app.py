from flask import Flask, render_template, request, redirect, url_for, session, flash
from flask_mysqldb import MySQL
from functools import wraps
import os
from werkzeug.utils import secure_filename
from flask_wtf import FlaskForm
from wtforms import StringField, PasswordField, SubmitField, TextAreaField, SelectField, FileField, URLField
from wtforms.validators import DataRequired, Length, ValidationError, URL, Optional, Regexp
import bcrypt
from slugify import slugify
from PIL import Image
import re
import unicodedata
from flask_wtf.csrf import CSRFProtect
import logging 

logging.basicConfig(level=logging.DEBUG,  
                    format='%(asctime)s - %(levelname)s - %(message)s')

def slugify(text):
    """Generates an ASCII-only slug."""
    text = unicodedata.normalize('NFKD', text).encode(
        'ascii', 'ignore').decode('ascii')
    text = re.sub(r'[^\w\s-]', '', text).strip().lower()
    text = re.sub(r'[-\s]+', '-', text)
    text = text.replace(' ', '-')  
    text = text.replace('&', 'dan')  
    return text


app = Flask(__name__)
csrf = CSRFProtect(app)

app.config['MYSQL_HOST'] = 'localhost'
app.config['MYSQL_USER'] = 'root'
app.config['MYSQL_PASSWORD'] = ''
app.config['MYSQL_DB'] = 'disbudparr'
app.config['MYSQL_CURSORCLASS'] = 'DictCursor'

mysql = MySQL(app)

app.secret_key = os.urandom(24)

UPLOAD_FOLDER = 'static/uploads/destination_images'
THUMBNAIL_FOLDER = 'static/uploads/destination_thumbnails'
ALLOWED_EXTENSIONS = {'png', 'jpg', 'jpeg', 'gif'}
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER
app.config['THUMBNAIL_FOLDER'] = THUMBNAIL_FOLDER
app.config['MAX_CONTENT_LENGTH'] = 16 * 1024 * 1024
os.makedirs(UPLOAD_FOLDER, exist_ok=True)
os.makedirs(THUMBNAIL_FOLDER, exist_ok=True)

def allowed_file(filename):
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

def create_thumbnail(filepath, maxsize=(200, 200)):
    try:
        img = Image.open(filepath)
        img.thumbnail(maxsize)
        thumbnail_filepath = filepath.replace(app.config['UPLOAD_FOLDER'],
                                              app.config['THUMBNAIL_FOLDER'])

        os.makedirs(os.path.dirname(thumbnail_filepath), exist_ok=True)

        img.save(thumbnail_filepath)
        return thumbnail_filepath.replace('static', '')

    except Exception as e:
        print(f"Error creating thumbnail: {e}")
        return None


# Form
class DestinationForm(FlaskForm):
    nama = StringField('Nama Destinasi', validators=[DataRequired(), Length(max=255)])
    slug = StringField('slug', validators=[DataRequired(), Length(max=255)])
    deskripsi_singkat = TextAreaField('Deskripsi Singkat', validators=[DataRequired()])
    deskripsi_lengkap = TextAreaField('Deskripsi Lengkap', validators=[DataRequired()])
    tipe = SelectField('Tipe', choices=[('aplikasi', 'Aplikasi'), ('penerbitan', 'Penerbitan'),('seni pertunjukan', 'Seni Pertunjukan'), ('periklanan', 'Periklanan'),('arsitektur', 'Arsitektur'), ('televisi dan radio', 'Televisi dan Radio'),
                                        ('desain komunikasi visual', 'Desain Komunikasi Visual'), ('fotografi', 'Fotografi'),('film, animasi, dan video', 'Film, Animasi, dan Video'), ('kuliner', 'Kuliner'),('fesyen', 'Fesyen'), ('desain product', 'Desain Product'),
                                        ('seni rupa', 'Seni Rupa'), ('musik', 'Musik'),('desain interior', 'Desain Interior'), ('kriya', 'Kriya'),('pengembang permainan', 'Pengembang Permainan')],
                        validators=[DataRequired()])
    lokasi = StringField('Lokasi', validators=[DataRequired()])
    kontak = StringField('Kontak')
    status = SelectField('Status', choices=[('aktif', 'Aktif'), ('tidak_aktif', 'Tidak Aktif')],
                          validators=[DataRequired()])
    gambar = FileField('Gambar')
    map_embed_url = URLField('URL Embed Google Maps', validators=[URL()])
    nomor_telepon = StringField('Nomor Telepon', validators=[Optional(), Regexp(r'^\d+$', message="Nomor telepon harus berupa angka.")])
    submit = SubmitField('Simpan')

class UlasanForm(FlaskForm):
    nama_pengguna = StringField('Nama Anda', validators=[Optional(), Length(max=255)])
    teks_ulasan = TextAreaField('Ulasan Anda', validators=[DataRequired(), Length(max=500)])
    submit = SubmitField('Kirim Ulasan')

class DeleteDestinationForm(FlaskForm):
    submit = SubmitField('Delete')

# Formulir Login
class LoginForm(FlaskForm):
    username = StringField('Username', validators=[DataRequired()])
    password = PasswordField('Password', validators=[DataRequired()])
    submit = SubmitField('Login')
    
class ProductForm(FlaskForm):
    nama = StringField('Nama Produk', validators=[DataRequired()])
    deskripsi = TextAreaField('Deskripsi', validators=[DataRequired()])
    harga = StringField('Harga', validators=[DataRequired()])
    gambar = FileField('Gambar')
    submit = SubmitField('Simpan')

# Fungsi untuk Memeriksa Login Admin
def is_logged_in(f):
    @wraps(f)
    def wrap(*args, **kwargs):
        if 'logged_in' in session:
            return f(*args, **kwargs)
        else:
            flash('Anda harus login untuk mengakses halaman ini.', 'danger')
            return redirect(url_for('login'))

    return wrap

@app.route('/login', methods=['GET', 'POST'])
def login():
    form = LoginForm()

    if form.validate_on_submit():
        username = form.username.data
        password = form.password.data

        cur = mysql.connection.cursor()
        try:
            # Ambil data admin (username dan password_hash)
            result = cur.execute("SELECT username, password_hash FROM admin WHERE username = %s", [username])

            if result > 0:
                data = cur.fetchone()
                stored_username = data['username']
                password_hash = data['password_hash']

                if bcrypt.checkpw(password.encode('utf-8'), password_hash.encode('utf-8')):
                    # Login Berhasil
                    session['logged_in'] = True
                    session['username'] = stored_username
                    flash('Login berhasil!', 'success')
                    return redirect(url_for('admin_dashboard'))
                else:
                    flash('Password tidak cocok.', 'danger')
                    return render_template('login.html', form=form)
            else:
                flash('Username tidak ditemukan.', 'danger')
                return render_template('login.html', form=form)

        except Exception as e:
            print(f"Terjadi kesalahan saat login: {e}")
            flash(f"Terjadi kesalahan: {e}", 'danger')
            return render_template('login.html', form=form)
        finally:
            cur.close()

    # Jika request GET atau login gagal, render halaman login dengan form
    return render_template('login.html', form=form)


# Rute Logout
@app.route('/logout')
@is_logged_in
def logout():
    session.clear()
    flash('Anda telah berhasil logout.', 'success')
    return redirect(url_for('index'))


# Rute Dashboard Admin
@app.route('/admin/admin_dashboard')
@is_logged_in
def admin_dashboard():
    delete_form = DeleteDestinationForm()
    cur = mysql.connection.cursor()
    try:
        cur.execute("SELECT id_destinasi, nama, slug, gambar, deskripsi_singkat, tipe FROM destinasi")
        destinations_data = cur.fetchall()
    except Exception as e:
        flash(f"Terjadi kesalahan saat mengambil data destinasi: {e}", "danger")
        destinations_data = []  # Atur ke daftar kosong jika terjadi kesalahan
    finally:
        cur.close()
    return render_template('admin_dashboard.html', destinations_data=destinations_data, delete_form=delete_form, form=DestinationForm())

@app.route('/admin/destinations')
@is_logged_in
def admin_destinations():
    try:
        cur = mysql.connection.cursor()
        cur.execute(
            "SELECT id_destinasi, nama, slug, gambar, deskripsi_singkat FROM destinasi")
        destinations = cur.fetchall()
        cur.close()
        return render_template('admin_destinations.html', destinations=destinations)
    except Exception as e:
        flash(
            f"Terjadi kesalahan saat mengambil daftar destinasi: {e}", "danger")
        # or redirect
        return render_template('admin_destinations.html', destinations=[])

@app.route('/admin/destinations/<string:id_destinasi>/detail')
@is_logged_in
def admin_destination_detail(id_destinasi):
    cur = mysql.connection.cursor()
    cur.execute("SELECT * FROM destinasi WHERE id_destinasi = %s",
                [id_destinasi])
    destination = cur.fetchone()

    if destination is None:
        flash('Destinasi tidak ditemukan', 'danger')
        return redirect(url_for('admin_destinations'))

    cur.execute("SELECT * FROM kerajinan WHERE id_destinasi = %s",
                [id_destinasi])
    barang = cur.fetchall()
    form = ProductForm()

    cur.close()
    return render_template('admin_destination_detail.html', destination=destination, barang=barang, form=form)

@app.route('/admin/add_destination', methods=['GET', 'POST'])
@is_logged_in
def add_destination():
    logging.info("Entering add_destination function")  # Log entry point
    form = DestinationForm(request.form)
    logging.debug(f"Form data: {form.data}")  # Log form data

    if request.method == 'POST':
        logging.info("Received POST request")  # Log POST request
        if form.validate():
            logging.info("Form is valid")  # Log form validation result
            nama = form.nama.data
            slug = form.slug.data
            deskripsi_singkat = form.deskripsi_singkat.data
            deskripsi_lengkap = form.deskripsi_lengkap.data
            tipe = form.tipe.data
            lokasi = form.lokasi.data
            kontak = form.kontak.data
            status = form.status.data
            map_embed_url = form.map_embed_url.data
            nomor_telepon = form.nomor_telepon

            # Handle image upload
            gambar_path = None  
            thumbnail_path = None

            if 'gambar' in request.files:
                gambar = request.files['gambar']
                if gambar and allowed_file(gambar.filename):
                    filename = secure_filename(gambar.filename)
                    filepath = os.path.join(app.config['UPLOAD_FOLDER'], filename)
                    try:
                        gambar.save(filepath)
                        gambar_path = os.path.join('uploads/destination_images/', filename)  
                        thumbnail_path = create_thumbnail(filepath)  # Buat thumbnail dan simpan path
                        if not thumbnail_path:
                            flash("Gagal membuat thumbnail", 'danger')
                            logging.warning("Failed to create thumbnail")  # Log thumbnail failure
                    except Exception as e:
                        flash(f"Gagal menyimpan gambar: {e}", 'danger')
                        logging.error(f"Failed to save image: {e}")  # Log image save failure
                        gambar_path = None
                else:
                    flash("Format gambar tidak diizinkan", 'danger')
                    logging.warning("Invalid image format")  # Log invalid image format

            cur = mysql.connection.cursor()
            try:
                logging.info("Executing database INSERT query")  # Log database insert
                cur.execute(
                    "INSERT INTO destinasi(nama, slug, gambar, deskripsi_singkat, deskripsi_lengkap, tipe, lokasi, kontak, status, map_embed_url, nomor_telepon) VALUES(%s, %s, %s, %s, %s, %s, %s, %s, %s, %s,%s)",
                    (nama, slug, gambar_path, deskripsi_singkat, deskripsi_lengkap, tipe, lokasi, kontak, status, map_embed_url, nomor_telepon))
                mysql.connection.commit()
                logging.info("Database INSERT query successful")  # Log insert success
                flash('Destinasi berhasil ditambahkan', 'success')
            except Exception as e:
                mysql.connection.rollback()
                flash(f'Terjadi kesalahan saat menambahkan destinasi: {e}', 'danger')
                logging.error(f"Error adding destination to database: {e}")  # Log database error
            finally:
                cur.close()

            logging.info("Redirecting to admin_dashboard")  # Log redirection
            return redirect(url_for('admin_dashboard'))
        else:
            logging.warning("Form validation failed")  # Log validation failure
            flash("Validasi form gagal. Periksa kembali isian Anda.", "danger")
            return render_template('add_destination.html', form=form)

    logging.info("Rendering add_destination.html template")  # Log template rendering
    return render_template('add_destination.html', form=form)


@app.route('/admin/delete_destination/<string:id_destinasi>', methods=['POST'])
@is_logged_in
def delete_destination(id_destinasi):
    form = DeleteDestinationForm()
    if form.validate_on_submit():
        cur = mysql.connection.cursor()
        try:
            cur.execute(
                "DELETE FROM destinasi WHERE id_destinasi = %s", [id_destinasi])
            mysql.connection.commit()
            flash('Destinasi berhasil dihapus', 'success')
        except Exception as e:
            mysql.connection.rollback()
            flash(f'Terjadi kesalahan saat menghapus destinasi: {e}', 'danger')
        finally:
            cur.close()
    return redirect(url_for('admin_destinations'))

@app.route('/admin/edit_destination/<string:id_destinasi>', methods=['GET', 'POST'])
@is_logged_in
def edit_destination(id_destinasi):
    cur = mysql.connection.cursor()
    result = cur.execute(
        "SELECT nama, slug, deskripsi_singkat, deskripsi_lengkap, tipe, lokasi, kontak, status, gambar, map_embed_url, nomor_telepon FROM destinasi WHERE id_destinasi = %s",
        [id_destinasi])
    destination_data = cur.fetchone()
    cur.close()

    if result > 0:
        form = DestinationForm(data=destination_data)

        if request.method == 'POST' and form.validate():
            nama = form.nama.data
            slug = form.slug.data
            deskripsi_singkat = form.deskripsi_singkat.data
            deskripsi_lengkap = form.deskripsi_lengkap.data
            tipe = form.tipe.data
            lokasi = form.lokasi.data
            kontak = form.kontak.data
            status = form.status.data
            map_embed_url = form.map_embed_url.data
            nomor_telepon = form.nomor_telepon

            # Handle image upload
            if 'gambar' in request.files:
                file = request.files['gambar']
                if file and allowed_file(file.filename):
                    filename = secure_filename(file.filename)
                    filepath = os.path.join(app.config['UPLOAD_FOLDER'], filename)
                    file.save(filepath)
                    gambar_path = os.path.join('uploads/destination_images/', filename)  
                    thumbnail_path = create_thumbnail(filepath)  # Buat thumbnail dan simpan path
                    if not thumbnail_path:
                        flash("Gagal membuat thumbnail", 'danger')
                else:
                    flash("Format gambar tidak diizinkan", 'danger')
                    return render_template('edit_destination.html', form=form, destinations_data=[])

            else:
                gambar_path = destination_data['gambar']

            cur = mysql.connection.cursor()
            try:
                cur.execute("""
                    UPDATE destinasi
                    SET nama=%s, slug=%s, deskripsi_singkat=%s, deskripsi_lengkap=%s, tipe=%s, lokasi=%s, kontak=%s, status=%s, gambar=%s, map_embed_url=%s, nomor_telepon=%s
                    WHERE id_destinasi=%s
                """, (nama, slug, deskripsi_singkat, deskripsi_lengkap, tipe, lokasi, kontak, status, gambar_path, map_embed_url, nomor_telepon,
                            id_destinasi))
                mysql.connection.commit()
                flash('Destinasi berhasil diperbarui', 'success')
            except Exception as e:
                mysql.connection.rollback()
                flash(f'Terjadi kesalahan saat memperbarui destinasi: {e}', 'danger')
            finally:
                cur.close()

            return redirect(url_for('admin_destinations'))

        return render_template('edit_destination.html', form=form)
    else:
        flash('Destinasi tidak ditemukan', 'danger')
        return redirect(url_for('admin_destinations'))

@app.route('/admin/destinations/<string:id_destinasi>/add_product', methods=['POST'])
@is_logged_in
def add_product(id_destinasi):
    form = ProductForm()

    if form.validate_on_submit():
        nama = form.nama.data
        deskripsi = form.deskripsi.data
        harga = form.harga.data

        gambar_path = None
        if 'gambar' in request.files:
            gambar = request.files['gambar']
            if gambar and allowed_file(gambar.filename):
                filename = secure_filename(gambar.filename)
                filepath = os.path.join(app.config['UPLOAD_FOLDER'], filename)  # folder gambar produk terpisah
                gambar.save(filepath)
                gambar_path = os.path.join('uploads/produk/', filename)  

        cur = mysql.connection.cursor()
        try:
            cur.execute("INSERT INTO kerajinan (id_destinasi, nama, deskripsi, harga, gambar) VALUES (%s, %s, %s, %s, %s)",
                        (id_destinasi, nama, deskripsi, harga, gambar_path))
            mysql.connection.commit()
            flash('Produk berhasil ditambahkan', 'success')
        except Exception as e:
            mysql.connection.rollback()
            flash(f'Terjadi kesalahan saat menambahkan produk: {e}', 'danger')
        finally:
            cur.close()

    return redirect(url_for('admin_destination_detail', id_destinasi=id_destinasi))

@app.route('/admin/products/<string:id_kerajinan>/edit', methods=['GET', 'POST'])
@is_logged_in
def edit_product(id_kerajinan):
    form = ProductForm()
    cur = mysql.connection.cursor()

    # Ambil data produk dari database
    cur.execute("SELECT id_destinasi, nama, deskripsi, harga, gambar FROM kerajinan WHERE id_kerajinan = %s", [id_kerajinan])
    product_data = cur.fetchone()
    if product_data:
        form = ProductForm(data=product_data) # gunakan data produk untuk mengisi form

    if form.validate_on_submit():
        nama = form.nama.data
        deskripsi = form.deskripsi.data
        harga = form.harga.data

        gambar_path = product_data['gambar'] 

        if 'gambar' in request.files:
            gambar = request.files['gambar']
            if gambar and allowed_file(gambar.filename):
                filename = secure_filename(gambar.filename)
                filepath = os.path.join(app.config['UPLOAD_FOLDER'], filename)
                gambar.save(filepath)
                gambar_path = os.path.join('uploads/produk/', filename)  

        try:
            cur.execute("""
                UPDATE kerajinan
                SET nama=%s, deskripsi=%s, harga=%s, gambar=%s
                WHERE id_kerajinan=%s
            """, (nama, deskripsi, harga, gambar_path, id_kerajinan))
            mysql.connection.commit()
            flash('Produk berhasil diperbarui', 'success')
        except Exception as e:
            mysql.connection.rollback()
            flash(f'Terjadi kesalahan saat memperbarui produk: {e}', 'danger')
        finally:
            cur.close()

        return redirect(url_for('admin_destination_detail', id_destinasi=product_data['id_destinasi'])) #kembali ke detail destinasi

    return render_template('edit_product.html', form=form) # render form edit

@app.route('/admin/products/<string:id_kerajinan>/delete', methods=['POST'])
@is_logged_in
def delete_product(id_kerajinan):
    cur = mysql.connection.cursor()
    try:
        # Cari id_destinasi sebelum dihapus
        cur.execute("SELECT id_destinasi FROM kerajinan WHERE id_kerajinan = %s", [id_kerajinan])
        product_data = cur.fetchone()
        if product_data:
            id_destinasi = product_data['id_destinasi']

            # Hapus produk
            cur.execute("DELETE FROM kerajinan WHERE id_kerajinan = %s", [id_kerajinan])
            mysql.connection.commit()
            flash('Produk berhasil dihapus', 'success')
        else:
            flash('Produk tidak ditemukan', 'warning')

    except Exception as e:
        mysql.connection.rollback()
        flash(f'Terjadi kesalahan saat menghapus produk: {e}', 'danger')
    finally:
        cur.close()

    if product_data:
        return redirect(url_for('admin_destination_detail', id_destinasi=id_destinasi)) #Kembali ke halaman destinasi
    else:
        return redirect(url_for('admin_destinations')) 
    
@app.route('/destinasi/<string:slug>', methods=['GET', 'POST'])
def detail_destinasi(slug):
    ulasan_form = UlasanForm()
    try:
        cur = mysql.connection.cursor()
        query = """
            SELECT
                id_destinasi, nama, lokasi, deskripsi_singkat, deskripsi_lengkap, 
                gambar, slug, map_embed_url, nomor_telepon, tipe, kontak
            FROM
                destinasi
            WHERE
                slug = %s
        """
        cur.execute(query, (slug,))
        destinasi_detail = cur.fetchone()
        if destinasi_detail is None:
            flash('Destinasi tidak ditemukan', 'danger')
            return render_template('detail_destinasi.html', destinasi_detail=None, products=[], ulasan_form=ulasan_form, ulasan=[])

        # Ambil daftar produk terkait
        product_query = """
            SELECT
                id_kerajinan, nama, deskripsi, harga, gambar
            FROM
                kerajinan
            WHERE
                id_destinasi = %s
        """
        cur.execute(product_query, [destinasi_detail['id_destinasi']])
        products = cur.fetchall()
        logging.debug(f"Fetched products: {products}")

        if ulasan_form.validate_on_submit():
            nama_pengguna = ulasan_form.nama_pengguna.data or "Anonim"
            teks_ulasan = ulasan_form.teks_ulasan.data
            id_destinasi = destinasi_detail['id_destinasi']

            insert_query = """
                INSERT INTO ulasan (id_destinasi, nama_pengguna, teks_ulasan)
                VALUES (%s, %s, %s)
            """
            try:
                cur.execute(insert_query, (id_destinasi, nama_pengguna, teks_ulasan))
                mysql.connection.commit()
                flash('Ulasan Anda telah ditambahkan!', 'success')
            except Exception as e:
                flash(f'Terjadi kesalahan saat menambahkan ulasan: {e}', 'danger')
                mysql.connection.rollback()

            # Setelah mengirim ulasan, redirect ke halaman yang sama untuk memperbarui daftar ulasan
            return redirect(url_for('detail_destinasi', slug=slug))
        
        # Ambil daftar ulasan terkait
        ulasan_query = """
            SELECT
                id_ulasan, nama_pengguna, teks_ulasan, tanggal_ulasan
            FROM
                ulasan
            WHERE
                id_destinasi = %s
            ORDER BY
                tanggal_ulasan DESC
        """
        cur.execute(ulasan_query, [destinasi_detail['id_destinasi']])
        ulasan = cur.fetchall()

        cur.close()

        return render_template('detail_destinasi.html',
                               destinasi_detail=destinasi_detail, product=products, ulasan_form=ulasan_form, ulasan=ulasan)

    except Exception as e:
        print(f"Terjadi kesalahan: {e}")
        return render_template('detail_destinasi.html', destinasi_detail=None, products=[], ulasan_form=ulasan_form, ulasan=[])

# Rute untuk Menampilkan Daftar Destinasi Wisata
@app.route('/destinasi')
def destinasi_list():
    try:
        cur = mysql.connection.cursor()

        query = """
            SELECT
                id_destinasi,
                nama,
                lokasi,
                deskripsi_singkat,
                gambar,
                slug
            FROM
                destinasi
        """
        cur.execute(query)

        destinasi_list = cur.fetchall()
        cur.close()
        return render_template('destinasi.html', destinasi_list=destinasi_list)

    except Exception as e:
        print(f"Terjadi kesalahan: {e}")
        return render_template('destinasi.html', destinasi_list=[])

# Rute Utama
@app.route('/')
def index():
    try:
        cur = mysql.connection.cursor()

        query = """
            SELECT
                k.id_kerajinan,
                k.id_destinasi,
                k.nama,
                k.deskripsi,
                k.gambar,
                k.harga,
                d.slug  
            FROM
                kerajinan k
            JOIN
                destinasi d ON k.id_destinasi = d.id_destinasi  
            LIMIT 3
        """
        cur.execute(query)

        crafts = []  
        results = cur.fetchall()
        for row in results:
            craft = {
                'id_kerajinan': row['id_kerajinan'],
                'id_destinasi': row['id_destinasi'],
                'nama': row['nama'],
                'deskripsi': row['deskripsi'],
                'gambar': row['gambar'],
                'harga': row['harga'],
                'slug': row['slug']
            }
            crafts.append(craft)  

        cur.close()

        return render_template('index.html', crafts=crafts)

    except Exception as e:
        print(f"Terjadi kesalahan: {e}")
        return render_template('index.html', crafts=[])


# Rute Kontak
@app.route('/kontak', methods=['GET', 'POST'])
def kontak():
    if request.method == 'POST':
        nama = request.form['nama']
        email = request.form['email']
        pesan = request.form['pesan']

        if not nama or not email or not pesan:
            flash('Harap isi semua kolom.', 'danger')
            return render_template('kontak.html')

        cur = mysql.connection.cursor()
        try:
            cur.execute(
                "INSERT INTO kontak (nama, email, pesan) VALUES (%s, %s, %s)", (nama, email, pesan))
            mysql.connection.commit()
            flash('Pesan Anda telah terkirim!', 'success')
            return redirect(url_for('kontak'))
        except Exception as e:
            flash(f"Terjadi kesalahan saat mengirim pesan: {e}", 'danger')
            return render_template('kontak.html')
        finally:
            cur.close()

    return render_template('kontak.html')


# Rute About
@app.route('/about')
def about():
    return render_template('about.html')

if __name__ == '__main__':
    app.run(debug=True)