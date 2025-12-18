-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 29, 2025 at 08:58 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `disbudparr`
--

-- --------------------------------------------------------

--
-- Table structure for table `admin`
--

CREATE TABLE `admin` (
  `id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `password_salt` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `admin`
--

INSERT INTO `admin` (`id`, `username`, `password_hash`, `password_salt`) VALUES
(4, 'admin', '$2b$12$ca3./tomQw5L7hA6U75AE.VliYbzDcTesMD.23Zg3wKVf1LhWUjSm', '$2b$12$ca3./tomQw5L7hA6U75AE.');

-- --------------------------------------------------------

--
-- Table structure for table `destinasi`
--

CREATE TABLE `destinasi` (
  `id_destinasi` int(11) NOT NULL,
  `nama` varchar(255) NOT NULL,
  `slug` varchar(255) NOT NULL,
  `gambar` varchar(255) DEFAULT NULL,
  `deskripsi_singkat` text DEFAULT NULL,
  `deskripsi_lengkap` text DEFAULT NULL,
  `tipe` enum('Aplikasi','Penerbitan','Seni Pertunjukan','Periklanan','Arsitektur','Televisi dan Radio','Desain Komunikasi Visual','Fotografi','Film,Animasi dan Video','Kuliner','Fesyen','Desain Product','Seni Rupa','Musik','Desain Interior','Kriya','Pengembang Permainan') NOT NULL,
  `lokasi` varchar(255) DEFAULT NULL,
  `map_embed_url` text NOT NULL,
  `kontak` varchar(255) DEFAULT NULL,
  `nomor_telepon` varchar(50) NOT NULL,
  `status` enum('Aktif','Tidak Aktif') DEFAULT 'Aktif',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `destinasi`
--

INSERT INTO `destinasi` (`id_destinasi`, `nama`, `slug`, `gambar`, `deskripsi_singkat`, `deskripsi_lengkap`, `tipe`, `lokasi`, `map_embed_url`, `kontak`, `nomor_telepon`, `status`, `created_at`, `updated_at`) VALUES
(1, 'AFJ Gallery', 'afj-gallery', 'uploads/destination_images/afj.jpg', 'AFJ Gallery menyediakan jasa kerajinan tangan', 'Menyediakan jasa kerajinan tangan', 'Kriya', 'Desa Kembuan Satu, Kecamatan Tondano Utara, Kabupaten Minahasa', 'https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d15954.986936012037!2d124.88752216100694!3d1.3279581092026003!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x328713a0761779a5%3A0x6d28a9946b4de6cc!2sHutan%2C%20Kec.%20Hutan%2C%20Kabupaten%20Minahasa%2C%20Sulawesi%20Utara!5e0!3m2!1sid!2sid!4v1762863457830!5m2!1sid!2sid', 'Facebook: Stenni Kuron New', '', 'Aktif', '2025-10-31 09:45:47', '2025-11-11 21:47:38'),
(2, 'Lanny Taylor', 'lanny-taylor', 'uploads/destination_images/lt.jpg', 'Lanny Taylor merupakan tempat jahit yang profesional dan terpercaya.', 'Lanny Taylor merupakan tempat jahit yang profesional dan terpercaya, menyediakan jasa jahit pakaian dan modifikasi pakaian.', 'Fesyen', 'Kelurahan Luaan, Kecamatan Tondano Timur, Kabupaten Minahasa', 'https://www.google.com/maps/embed?pb=!1m14!1m12!1m3!1d498.59662854199894!2d124.915058544442!3d1.311563636205634!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!5e0!3m2!1sid!2sid!4v1762263768292!5m2!1sid!2sid', 'Nomor Telepon: 0831-4385-3138', '6283143853138', 'Aktif', '2025-11-04 05:49:14', '2025-11-11 21:49:14'),
(3, 'N Crafts', 'n-crafts', 'uploads/destination_images/nc.jpg', 'N Crafts merupakan usaha yang berfokus pada kerajinan Eceng Gondok dan Rajutan', 'Kerajinan Eceng Gondok dan Rajutan', 'Kriya', 'Desa Eris, Jaga 2, Kecamatan Eris, Kabupaten Minahasa', 'https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3988.901294669219!2d124.914868!3d1.2284575!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x32873f003c455951%3A0x23cd7824cc3e2bb5!2sPondok%20Eceng%20N%20Crafts!5e0!3m2!1sid!2sid!4v1762782186762!5m2!1sid!2sid', 'Facebook: N Crafts', '6285240698271', 'Aktif', '2025-11-10 13:44:26', '2025-11-11 21:49:30'),
(4, 'Silva Flanel', 'silva-flanel', 'uploads/destination_images/sf.jpg', 'Silva Flanel merupakan usaha yang berfokus pada kerajinan tangan kain flanel.', 'Silva Flanel merupakan usaha yang berfokus pada kerajinan tangan kain flanel.', 'Kriya', 'Taraitak, Kecamatan Langowan Utara, Kabupaten Minahasa', 'https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3989.0026159373897!2d124.8267525!3d1.1586036!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x328747000455761b%3A0xbc4c1d9204919c60!2sSilva%20Flanel!5e0!3m2!1sid!2sid!4v1762864175457!5m2!1sid!2sid', 'Facebook: Silva Flanel', '6282194211413', 'Aktif', '2025-11-11 13:39:13', '2025-11-14 13:39:12'),
(5, 'Filicya Bakery', 'filicya-bakery', 'uploads/destination_images/fb.jpg', 'Filicya Bakery merupakan suatu usaha yang menawarkan berbagai jenis kue kering, kue basah, dan roti yang lezat. ', 'Filicya Bakery merupakan suatu usaha yang menggunakan bahan-bahan berkualitas tinggi. Menawarkan berbagai jenis kue kering, kue basah, dan roti yang lezat.', 'Kuliner', 'Lingkungan 2, Kelurahan Wulauan, Kecamatan Tondano Utara.', 'https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3988.7730639393308!2d124.9217930747245!3d1.3115412986759991!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x328713d80668d2fb%3A0x92e21198283f9ebc!2sFilicya%20bakery!5e0!3m2!1sid!2sid!4v1762899673196!5m2!1sid!2sid', 'Facebook: Chici Tjia Pangkey', '6289531560607', 'Aktif', '2025-11-11 22:22:22', '2025-11-12 07:55:26'),
(6, 'Double A Kitchen', 'doublea-kitchen', 'uploads/destination_images/doublea.jpg', 'Double A Kitchen merupakan suatu usaha yang menawarkan berbagai jenis dessert, seperti Pudding, Brownies, buah, salad, dan lain-lain.\r\n', 'Double A Kitchen merupakan suatu usaha yang menawarkan berbagai jenis dessert, seperti Pudding, Brownies, buah, salad, dan lain-lain.\r\n', 'Kuliner', 'Taler, Kecamatan Tondano Timur, Kabupaten Minahasa.', 'https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3988.799641573166!2d124.9128781!3d1.294759!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x3287150019b14481%3A0x867fc09ccf2536cf!2sDoubleA%20kitchen!5e0!3m2!1sid!2sid!4v1762934317535!5m2!1sid!2sid', 'Facebook: Gabrela Velany Sumarauw', '6285656064353', 'Aktif', '2025-11-12 07:59:33', '2025-11-12 08:01:06'),
(8, 'Tjeria', 'tjeria', 'uploads/destination_images/tj.jpg', 'Tjeria merupakan suatu usaha yang menawarkan berbagai cemilan seperti keripik pisang, es teler, dan cendol.', 'Tjeria merupakan suatu usaha bidang kuliner yang menawarkan berbagai jenis cemilan seperti keripik pisang, es teler, cendol, dan lain-lain.', 'Kuliner', 'Kelurahan Ranowangko, Kecamatan Tondano Timur, Kabupaten Minahasa', 'https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3988.778140759708!2d124.91209597472447!3d1.308352198679231!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x3287153b1ca1682d%3A0xf24d0363672aa689!2s%22TJERIA%22%20HOME%20INDUSTRY!5e0!3m2!1sid!2sid!4v1763127924045!5m2!1sid!2sid', 'Facebook: Tjeria Produksi', '6285397648478', 'Aktif', '2025-11-14 13:49:36', '2025-11-21 02:30:59'),
(9, 'Jen\'s Bakery Shop', 'jens-bakery-shop', 'uploads/destination_images/jensbakery.jpeg', 'Jen\'s Bakery Shop merupakan usaha bidang kuliner yang menyajikan berbagai macam kue kering, kue basah, maupun kukis. ', 'Jen\'s Bakery Shop merupakan usaha bidang kuliner yang menyajikan berbagai macam kue kering, kue basah, maupun kukis. ', 'Kuliner', 'Kelurahan Rinegetan, Kecamatan Tondano Barat, Kabupaten Minahasa', 'https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d997.1983627002344!2d124.90954376952871!3d1.2986874999180782!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x32871461da78d74d%3A0xf06fbef5d9ec43e0!2s7WX6%2BF3%2C%20Tounkuramber%2C%20Kec.%20Tondano%20Bar.%2C%20Kabupaten%20Minahasa%2C%20Sulawesi%20Utara!5e0!3m2!1sid!2sid!4v1763528850392!5m2!1sid!2sid', 'Instagram: jennysbyingrid', '6282396729848', 'Aktif', '2025-11-19 05:08:25', '2025-11-21 02:32:40'),
(10, 'Uka Craft', 'uka-craft', 'uploads/destination_images/ukacraft.jpeg', 'Uka Craft merupakan sebuah usaha kerajinan yang berfokus pada pembuatan produk-produk berbahan dasar tempurung kelapa.', 'Uka Craft merupakan sebuah usaha kerajinan yang berfokus pada pembuatan produk-produk unik dan kreatif yang berbahan dasar tempurung kelapa.', 'Kriya', 'Desa Maumbi, Kecamatan Eris, Kabupaten Minahasa', 'https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d15955.88724317266!2d124.9777395!3d1.180279!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x32873b8bda5ce3ab%3A0xcc3c3b974c6a70c1!2sMaumbi%2C%20Kec.%20Eris%2C%20Kabupaten%20Minahasa%2C%20Sulawesi%20Utara!5e0!3m2!1sid!2sid!4v1763691515169!5m2!1sid!2sid', 'Facebook: Oma Uka', '62895340109785', 'Aktif', '2025-11-21 02:21:19', '2025-11-21 02:33:37'),
(11, 'Kedai Nomnom', 'kedai-nomnom', 'uploads/destination_images/kedainomnom.jpg', 'Kedai Nomnom adalah sebuah usaha bidang kuliner yang menawarkan berbagai jenis makanan dan minuman yang lezat.', 'Kedai Nomnom adalah sebuah usaha bidang kuliner yang menawarkan berbagai jenis makanan dan minuman yang lezat. Menu yang ditawarkan beragam, mulai dari lue pastry, minuman es, burger, dan berbagai makanan ringan dan berat lainnya.', 'Kuliner', 'Jalan Lembong, Lingkungan IV, Tataaran I, Kecamatan Tondano Selatan, Kabupaten Minahasa', 'https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3988.8089711206244!2d124.8846566!3d1.2888160999999942!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x32871500501c4bb7%3A0x67e0129835673ec7!2sKedai%20NomNom!5e0!3m2!1sid!2sid!4v1764247809189!5m2!1sid!2sid', 'Facebook: KedaiNomnom Tataaran', '6281349707878', 'Aktif', '2025-11-27 13:05:22', '2025-11-27 13:09:18');

-- --------------------------------------------------------

--
-- Table structure for table `kerajinan`
--

CREATE TABLE `kerajinan` (
  `id_kerajinan` int(11) NOT NULL,
  `id_destinasi` int(11) NOT NULL,
  `nama` varchar(255) NOT NULL,
  `deskripsi` text DEFAULT NULL,
  `harga` decimal(10,0) DEFAULT NULL,
  `gambar` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `kerajinan`
--

INSERT INTO `kerajinan` (`id_kerajinan`, `id_destinasi`, `nama`, `deskripsi`, `harga`, `gambar`) VALUES
(1, 2, 'Seragam Sekolah ', 'Menyediakan jasa menjahit seragam sekolah.', 0, 'uploads/produk/ss.jpg'),
(2, 2, 'Seragam Sekolah 2', 'Menyediakan jasa menjahit seragam sekolah.', 0, 'uploads/produk/ssb.jpg'),
(3, 3, 'Keranjang Enceng Gondok', 'Keranjang yang terbuat dari eceng gondok dapat dijadikan sebagai tempat penyimpanan berbagai barang. ', 0, 'uploads/produk/keranjang.jpg'),
(4, 3, 'Tempat Tisu Enceng Gondok', 'Tempat tisu yang terbuat dari anyaman eceng gondok.', 0, 'uploads/produk/tempatisu.jpg'),
(5, 3, 'Tas Eceng Gondok', 'Tas yang terbuat dari anyaman eceng gondok, sangat cocok untuk digunakan dalam kegiatan sehari-hari ataupun ke acara resmi.', 0, 'uploads/produk/tas.jpg'),
(6, 3, 'Tas Eceng Gondok', 'Tas yang terbuat dari anyaman eceng gondok, sangat cocok untuk digunakan dalam kegiatan sehari-hari ataupun ke acara resmi.', 0, 'uploads/produk/tas3.jpg'),
(7, 4, 'Taplak meja kain flanel', 'Taplak Meja yang terbuat dari kain flanel dapat membuat meja rumah anda menjadi lebih bagus.', 0, 'uploads/produk/taplakmeja.jpg'),
(8, 4, 'Bunga dada kain flanel', 'Bunga dada cantik dari kain flanel, dapat digunakan sebagai aksesoris fashion. ', 0, 'uploads/produk/bungadada.jpg'),
(9, 4, 'Hiasan Natal', 'Hiasan Natal yang cantik dari kain flanel, dapat digunakan sebagai hiasan pohon Natal, jendela, atau dinding. ', 0, 'uploads/produk/hiasanatal.jpg'),
(10, 4, 'Hiasan Natal', 'Hiasan Natal yang cantik dari kain flanel, dapat membuat suasana Natal Anda lebih meriah. Dapat digunakan sebagai hiasan pada meja tamu.', 0, 'uploads/produk/hiasanatalll.jpg'),
(11, 4, 'Tempat Tisu Kain Flanel', 'Tempat tisu yang praktis dan cantik dari kain flanel, dapat membuat ruangan Anda terlihat lebih rapi dan nyaman. Dapat digunakan di ruang tamu, kamar, atau kantor.', 0, 'uploads/produk/tempatisuflanel.jpg'),
(12, 4, 'Tempat Tisu Flanel Tema Natal', 'Tempat tisu dengan tema natal dari kain flanel, dapat membuat suasana natal anda semakin meriah. Dapat digunakan di ruang tamu, kamar, atau kantor.', 0, 'uploads/produk/tempatisunatal.jpg'),
(13, 4, 'Tempat Tisu Flanel Tema Natal', 'Tempat tisu dengan tema natal dari kain flanel, dapat membuat suasana natal anda semakin meriah. Dapat digunakan di ruang tamu, kamar, atau kantor.', 0, 'uploads/produk/tisutempat.jpg'),
(14, 2, 'Pakaian Pesta', 'Menyediakan jasa menjahit pakaian pesta.', 0, 'uploads/produk/dress.jpg'),
(15, 2, 'Pakaian Pesta', 'Menyediakan jasa menjahit pakaian pesta.', 0, 'uploads/produk/anotherdress.jpg'),
(16, 2, 'Pakaian Pesta', 'Menyediakan jasa menjahit pakaian pesta.', 0, 'uploads/produk/pakaiannpesta.jpeg'),
(17, 1, 'Piala Kayu', 'Piala kayu yang elegan dibuat dari kayu berkualitas tinggi. Sangat cocok diberikan sebagai penghargaan pada suatu lomba.', 0, 'uploads/produk/piala.jpg'),
(18, 1, 'Burung Manguni Kayu', 'Hiasan burung manguni yang terbuat dari kayu berkualitas tinggi. Sangat cocok digunakan sebagai dekorasi ruangan atau sebagai hadiah.', 0, 'uploads/produk/hiasan.jpg'),
(19, 5, 'Roll Cake', 'Kue ini memiliki tekstur yang lembut dan ringan, dengan rasa yang manis dan aroma yang harum. Roll cake biasanya disajikan sebagai cemilan.', 0, 'uploads/produk/rollcake.jpg'),
(20, 5, 'Roti Cokelat', 'Roti cokelat adalah jenis roti yang terbuat dari adonan roti yang diisi dengan isian cokelat yang lezat.', 0, 'uploads/produk/roti.jpg'),
(21, 5, 'Pie Susu', 'Pie susu adalah jenis pai yang terbuat dari kulit pai yang diisi dengan isian susu yang kental dan manis. ', 0, 'uploads/produk/piesusu.jpg'),
(22, 5, 'Pie Buah', 'Pie buah adalah jenis pai yang terbuat dari kulit pai yang diisi dengan isian buah segar yang lezat.', 0, 'uploads/produk/piebuah.jpg'),
(27, 6, 'Es Teler ', 'Es teler adalah es yang terbuat dari campuran buah-buahan seperti kelapa, nangka, dan alpukat. Es ini memiliki rasa yang manis dan segar, sehingga cocok dijadikan sebagai hidangan penutup yang menyegarkan.', 0, 'uploads/produk/esteler.jpg'),
(28, 6, 'Brownies', 'Brownies adalah kue yang terbuat dari cokelat, gula, telur, dan tepung. Brownies memiliki rasa yang manis sehingga sangat cocok untuk dijadikan sebagai hidangan penutup atau dinikmati dengan secangkir kopi.', 0, 'uploads/produk/Brownies.jpg'),
(29, 6, 'Klapertart', 'Klapertart adalah kue yang terbuat dari campuran kelapa. Kue ini memiliki rasa manis dan gurih dengan tekstur lembut, sehingga sangat cocok dijadikan sebagai hidangan penutup yang lezat.', 0, 'uploads/produk/klapertart.jpg'),
(30, 6, 'Pudding', 'Pudding adalah hidangan penutup yang terbuat dari campuran susu, gula, dan agar-agar. Pudding memiliki rasa yang manis dan tekstur yang lembut dan creamy. ', 0, 'uploads/produk/pudding.jpg'),
(31, 8, 'Es Cendol', 'Es cendol adalah minuman segar yang terbuat dari campuran santan, gula merah, dan cendol. Es ini memiliki rasa yang manis dan segar, dengan tekstur yang creamy dan lembut. Es cendol biasanya disajikan sebagai hidangan penutup.', 0, 'uploads/produk/escendol.jpg'),
(32, 8, 'Es Teler', 'Es teler adalah es krim yang terbuat dari campuran santan, gula, dan buah-buahan. Es ini memiliki rasa yang manis dan segar, dengan tekstur yang creamy dan lembut. Es teler sangat cocok disajikan sebagai hidangan penutup.', 0, 'uploads/produk/estelertj.jpg'),
(33, 8, 'Keripik Pisang Asin', 'Keripik pisang adalah camilan yang terbuat dari irisan pisang yang digoreng hingga kering dan renyah. Keripik ini bisa disajikan sebagai camilan yang lezat dan dapat dinikmati kapan saja.', 0, 'uploads/produk/keripikpisangasin.jpg'),
(34, 8, 'Keripik Pisang Balado', 'Keripik pisang adalah camilan yang terbuat dari irisan pisang yang digoreng hingga kering dan renyah. Keripik ini bisa disajikan sebagai camilan yang lezat dan dapat dinikmati kapan saja.', 0, 'uploads/produk/pisangbalado.jpg'),
(35, 8, 'Keripik Pisang Manis', 'Keripik pisang adalah camilan yang terbuat dari irisan pisang yang digoreng hingga kering dan renyah. Keripik ini bisa disajikan sebagai camilan yang lezat dan dapat dinikmati kapan saja.', 0, 'uploads/produk/pisangmanis.jpg'),
(36, 8, 'Keripik Talas', 'Keripik talas adalah camilan yang terbuat dari irisan talas yang digoreng hingga kering dan renyah. Keripik ini bisa disajikan sebagai camilan yang lezat dan dapat dinikmati kapan saja.', 0, 'uploads/produk/talas.jpg'),
(37, 9, 'Cornflakes', 'Kue cornflakes adalah kue yang terbuat dari cornflakes yang dicampur dengan telur dan mentega. Kue ini memiliki rasa yang manis dan tekstur yang renyah.', 0, 'uploads/produk/cornflakes.jpg'),
(38, 9, 'Dessert box', 'Kue ini memiliki rasa yang manis dan tekstur yang lembut.', 0, 'uploads/produk/dessertbox.jpg'),
(39, 9, 'Nastar', 'Nastar adalah kue yang terbuat dari tepung, gula, dan mentega, yang kemudian diisi dengan selai nanas.', 0, 'uploads/produk/nastar.jpg'),
(40, 9, 'Nutella Keju', 'Nutella keju adalah kue yang memiliki topping nutella  dan keju yang kemudian dipanggang hingga matang. Kue ini memiliki rasa yang manis dan gurih.', 0, 'uploads/produk/Nutelakeju.jpg'),
(41, 9, 'Ontbijtkoek ', 'Ontbijtkoek adalah kue khas Belanda yang kaya rempah di dalamnya. Warnanya coklat, dengan kacang almond atau kenari sebagai topingnya, serta rasa dan aroma dominannya adalah kayu manis', 0, 'uploads/produk/ontbijkoek.jpg'),
(42, 9, 'Kue Silverqueen', 'Kue ini memiliki rasa yang manis dan tekstur yang lembut.', 0, 'uploads/produk/silverqueen.jpg'),
(43, 9, 'Soft Butter Cookies', 'Soft butter cookies adalah kue yang terbuat dari campuran tepung, gula, dan mentega, yang kemudian dipanggang hingga matang', 0, 'uploads/produk/softbuttercookies.jpg'),
(44, 9, 'Sultana', 'Sultana merupakan kue sejenis nastar namun berbeda dibentuk dan ada tambahan kismis.', 0, 'uploads/produk/sultana.jpg'),
(45, 10, 'Bros Bunga Tempurung ', 'Bros bunga ini merupakan sebuah aksesoris yang terbuat dari tempurung kelapa.', 0, 'uploads/produk/brosbunga.jpg'),
(46, 10, 'Jepitan Rambut Tempurung', 'Sebuah aksesoris rambut yang stylish dan ramah lingkungan, terbuat dari tempurung kelapa yang kuat dan ringan. Jepitan rambut ini adalah pilihan sempurna bagi Anda yang ingin menambahkan sentuhan alam pada gaya rambut Anda. Dengan desain yang unik dan elegan, jepitan rambut ini akan membuat Anda terlihat lebih cantik dan percaya diri.', 0, 'uploads/produk/jepitanrambut.jpg'),
(47, 10, 'Kalung Anting Tempurung', 'Sebuah perhiasan yang unik dan berani, terbuat dari tempurung kelapa yang diukir dengan teliti. Kalung anting ini adalah perpaduan sempurna antara keindahan alam dan keahlian tangan manusia. Dengan desain yang unik dan elegan, kalung anting ini akan membuat Anda terlihat lebih cantik dan menarik.', 0, 'uploads/produk/kalunganting.jpg'),
(48, 10, 'Teko Tempurung', 'Sebuah teko yang unik dan fungsional, terbuat dari tempurung kelapa yang kuat dan ringan. Teko ini adalah pilihan sempurna bagi Anda yang ingin menambahkan sentuhan alam pada meja makan Anda.', 0, 'uploads/produk/tekotempurung.jpg'),
(49, 11, 'Bolen Coklat Keju', 'Bolen coklat keju adalah kue kering yang lezat dan manis, terbuat dari adonan yang renyah dan isi coklat yang meleleh.', 0, 'uploads/produk/bolencoklatkeju.jpg'),
(50, 11, 'Bolen Smoke Beef', 'Bolen smoke beef adalah kue kering yang unik dan lezat, terbuat dari adonan yang renyah dan isi smoke beef yang gurih. ', 0, 'uploads/produk/bolensmokebeef.jpg'),
(51, 11, 'Burger Ayam', 'Burger ayam adalah makanan yang lezat dan segar, terbuat dari daging ayam yang juicy dan roti yang lembut. ', 0, 'uploads/produk/burgerayam.jpg'),
(52, 11, 'Banana Crispy', 'Banana crispy adalah cemilan yang lezat dan renyah.', 0, 'uploads/produk/bananacrispy.jpg');

-- --------------------------------------------------------

--
-- Table structure for table `ulasan`
--

CREATE TABLE `ulasan` (
  `id_ulasan` int(11) NOT NULL,
  `id_destinasi` int(11) DEFAULT NULL,
  `nama_pengguna` varchar(255) DEFAULT NULL,
  `teks_ulasan` text DEFAULT NULL,
  `tanggal_ulasan` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `ulasan`
--

INSERT INTO `ulasan` (`id_ulasan`, `id_destinasi`, `nama_pengguna`, `teks_ulasan`, `tanggal_ulasan`) VALUES
(1, 2, 'Aurelia', 'Bagus', '2025-11-07 05:21:26');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admin`
--
ALTER TABLE `admin`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `destinasi`
--
ALTER TABLE `destinasi`
  ADD PRIMARY KEY (`id_destinasi`),
  ADD UNIQUE KEY `slug` (`slug`);

--
-- Indexes for table `kerajinan`
--
ALTER TABLE `kerajinan`
  ADD PRIMARY KEY (`id_kerajinan`),
  ADD KEY `id_destinasi` (`id_destinasi`);

--
-- Indexes for table `ulasan`
--
ALTER TABLE `ulasan`
  ADD PRIMARY KEY (`id_ulasan`),
  ADD KEY `id_destinasi` (`id_destinasi`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `admin`
--
ALTER TABLE `admin`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `destinasi`
--
ALTER TABLE `destinasi`
  MODIFY `id_destinasi` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `kerajinan`
--
ALTER TABLE `kerajinan`
  MODIFY `id_kerajinan` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=53;

--
-- AUTO_INCREMENT for table `ulasan`
--
ALTER TABLE `ulasan`
  MODIFY `id_ulasan` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `kerajinan`
--
ALTER TABLE `kerajinan`
  ADD CONSTRAINT `kerajinan_ibfk_1` FOREIGN KEY (`id_destinasi`) REFERENCES `destinasi` (`id_destinasi`);

--
-- Constraints for table `ulasan`
--
ALTER TABLE `ulasan`
  ADD CONSTRAINT `ulasan_ibfk_1` FOREIGN KEY (`id_destinasi`) REFERENCES `destinasi` (`id_destinasi`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
