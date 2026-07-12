-- phpMyAdmin SQL Dump
-- version 5.2.3
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Jul 11, 2026 at 07:20 AM
-- Server version: 8.0.30
-- PHP Version: 8.4.23

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `uangku-tes1`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_ringkasan_akun` (IN `p_id_akun` INT)   BEGIN
    SELECT 
        a.nama_akun,
        SUM(CASE WHEN t.tipe_transaksi = 'Pemasukan' THEN t.jumlah ELSE 0 END) AS total_pemasukan,
        SUM(CASE WHEN t.tipe_transaksi = 'Pengeluaran' THEN t.jumlah ELSE 0 END) AS total_pengeluaran
    FROM transaksi t
    JOIN akun a ON t.id_akun = a.id_akun
    WHERE t.id_akun = p_id_akun
    GROUP BY a.nama_akun;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_transaksi_per_kategori` (IN `p_id_kategori` INT)   BEGIN
    SELECT
        t.id_transaksi,
        k.nama_kategori,
        t.tanggal,
        t.tipe_transaksi,
        t.jumlah,
        t.keterangan
    FROM transaksi t
    JOIN kategori k ON t.id_kategori = k.id_kategori
    WHERE t.id_kategori = p_id_kategori
    ORDER BY t.tanggal;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_transaksi_per_user` (IN `p_id_user` INT)   BEGIN
    SELECT
        t.id_transaksi,
        u.nama_user,
        a.nama_akun,
        k.nama_kategori,
        t.tanggal,
        t.tipe_transaksi,
        t.jumlah,
        t.keterangan
    FROM transaksi t
    JOIN user u ON t.id_user = u.id_user
    JOIN akun a ON t.id_akun = a.id_akun
    JOIN kategori k ON t.id_kategori = k.id_kategori
    WHERE t.id_user = p_id_user
    ORDER BY t.tanggal;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `akun`
--

CREATE TABLE `akun` (
  `ID_AKUN` int NOT NULL,
  `ID_USER` int NOT NULL,
  `NAMA_AKUN` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `TIPE_AKUN` varchar(15) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `SALDO_AWAL` int DEFAULT NULL,
  `SALDO_SEKARANG` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `akun`
--

INSERT INTO `akun` (`ID_AKUN`, `ID_USER`, `NAMA_AKUN`, `TIPE_AKUN`, `SALDO_AWAL`, `SALDO_SEKARANG`) VALUES
(1, 1, 'Dompet', 'Cash', 100000, 752000),
(2, 1, 'Mandiri', 'Debit', 300000, 5133000),
(3, 2, 'Shopee-Pay', 'E-Money', 500000, 1605000);

-- --------------------------------------------------------

--
-- Table structure for table `audit_log`
--

CREATE TABLE `audit_log` (
  `ID_LOG` int NOT NULL,
  `ID_TRANSAKSI` int DEFAULT NULL,
  `AKSI` varchar(10) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `DATA_LAMA` text COLLATE utf8mb4_general_ci,
  `DATA_BARU` text COLLATE utf8mb4_general_ci,
  `TIMESTAMP` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `audit_log`
--

INSERT INTO `audit_log` (`ID_LOG`, `ID_TRANSAKSI`, `AKSI`, `DATA_LAMA`, `DATA_BARU`, `TIMESTAMP`) VALUES
(1, 36, 'insert', NULL, 'user=root@localhost, akun=1, kategori=1, sub=null, tanggal=2025-12-21, tipe=Pemasukan, jumlah=100000', '2025-12-21 08:01:19'),
(2, 3, 'update', 'user=root@localhost, akun=2, tipe=Pemasukan, jumlah=2000000', 'akun=2, tipe=Pemasukan, jumlah=2000000', '2025-12-21 10:09:42'),
(7, 36, 'update', 'user=root@localhost, akun=1, tipe=Pemasukan, jumlah=100000', 'akun=1, tipe=Pemasukan, jumlah=100004', '2025-12-21 12:41:02'),
(8, 36, 'update', 'user=root@localhost, akun=1, tipe=Pemasukan, jumlah=100004', 'akun=2, tipe=Pemasukan, jumlah=100000', '2025-12-21 12:41:25'),
(12, 42, 'insert', NULL, 'user=root@localhost, akun=1, kategori=5, sub=1, tanggal=2025-12-21, tipe=Pengeluaran, jumlah=50000', '2025-12-21 12:54:17'),
(14, 42, 'update', 'user=root@localhost, akun=1, tipe=Pengeluaran, jumlah=50000', 'akun=1, tipe=Pengeluaran, jumlah=55000', '2025-12-21 12:57:31'),
(17, 44, 'insert', NULL, 'user=root@localhost, akun=3, kategori=2, sub=null, tanggal=2025-12-19, tipe=Pemasukan, jumlah=1500000', '2025-12-21 13:06:13'),
(18, 44, 'update', 'user=root@localhost, akun=3, tipe=Pemasukan, jumlah=1500000', 'akun=3, tipe=Pemasukan, jumlah=1300000', '2025-12-21 13:06:27'),
(30, 47, 'insert', NULL, 'user=root@localhost, akun=2, kategori=1, sub=null, tanggal=2025-12-21, tipe=Pemasukan, jumlah=100000', '2025-12-23 09:00:44'),
(32, NULL, 'insert', NULL, 'user=root@localhost, akun=2, kategori=1, sub=null, tanggal=2025-12-21, tipe=Pemasukan, jumlah=100000', '2025-12-23 09:06:59'),
(33, NULL, 'delete', 'user=root@localhost, akun=2, kategori=1, sub=null, tanggal=2025-12-21, tipe=Pemasukan, jumlah=100000', NULL, '2025-12-23 09:07:08'),
(34, 47, 'update', 'user=root@localhost, akun=2, tipe=Pemasukan, jumlah=100000', 'akun=1, tipe=Pemasukan, jumlah=100000', '2025-12-23 09:34:17'),
(35, NULL, 'insert', NULL, 'user=root@localhost, akun=1, kategori=1, sub=null, tanggal=2025-12-24, tipe=Pemasukkan, jumlah=50000', '2025-12-24 05:56:49'),
(36, NULL, 'delete', 'user=root@localhost, akun=1, kategori=1, sub=null, tanggal=2025-12-24, tipe=Pemasukkan, jumlah=50000', NULL, '2025-12-24 06:03:50'),
(37, 47, 'update', 'user=root@localhost, akun=1, tipe=Pemasukan, jumlah=100000', 'akun=1, tipe=Pemasukan, jumlah=100000', '2025-12-24 06:10:04'),
(38, 47, 'update', 'user=root@localhost, akun=1, tipe=Pemasukan, jumlah=100000', 'akun=1, tipe=Pemasukan, jumlah=200000', '2025-12-24 06:15:20'),
(39, NULL, 'insert', NULL, 'user=root@localhost, akun=3, kategori=1, sub=null, tanggal=2025-12-28, tipe=Pemasukkan, jumlah=50000', '2025-12-28 04:09:18'),
(40, NULL, 'delete', 'user=root@localhost, akun=3, kategori=1, sub=null, tanggal=2025-12-28, tipe=Pemasukkan, jumlah=50000', NULL, '2025-12-28 04:10:05'),
(41, 47, 'update', 'user=root@localhost, akun=1, tipe=Pemasukan, jumlah=200000', 'akun=1, tipe=Pemasukan, jumlah=300000', '2025-12-28 04:10:44');

-- --------------------------------------------------------

--
-- Table structure for table `cache`
--

CREATE TABLE `cache` (
  `key` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `value` mediumtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `expiration` bigint NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `cache_locks`
--

CREATE TABLE `cache_locks` (
  `key` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `owner` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `expiration` bigint NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `diberi_transaksi_tag`
--

CREATE TABLE `diberi_transaksi_tag` (
  `ID_TAG` int NOT NULL,
  `ID_TRANSAKSI` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `diberi_transaksi_tag`
--

INSERT INTO `diberi_transaksi_tag` (`ID_TAG`, `ID_TRANSAKSI`) VALUES
(4, 21),
(2, 22),
(14, 22),
(3, 23),
(8, 23),
(8, 24),
(18, 24),
(2, 25),
(4, 25),
(4, 26),
(17, 26),
(2, 27),
(5, 27),
(4, 28),
(10, 28),
(11, 29),
(19, 29),
(20, 29),
(16, 30),
(2, 31),
(10, 31),
(11, 32),
(13, 32),
(2, 33),
(9, 33),
(2, 34),
(14, 34),
(8, 35),
(12, 35),
(18, 35),
(4, 42),
(3, 44);

-- --------------------------------------------------------

--
-- Table structure for table `failed_jobs`
--

CREATE TABLE `failed_jobs` (
  `id` bigint UNSIGNED NOT NULL,
  `uuid` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `connection` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `queue` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `exception` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `jobs`
--

CREATE TABLE `jobs` (
  `id` bigint UNSIGNED NOT NULL,
  `queue` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `attempts` smallint UNSIGNED NOT NULL,
  `reserved_at` int UNSIGNED DEFAULT NULL,
  `available_at` int UNSIGNED NOT NULL,
  `created_at` int UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `job_batches`
--

CREATE TABLE `job_batches` (
  `id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `total_jobs` int NOT NULL,
  `pending_jobs` int NOT NULL,
  `failed_jobs` int NOT NULL,
  `failed_job_ids` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `options` mediumtext COLLATE utf8mb4_unicode_ci,
  `cancelled_at` int DEFAULT NULL,
  `created_at` int NOT NULL,
  `finished_at` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `kategori`
--

CREATE TABLE `kategori` (
  `ID_KATEGORI` int NOT NULL,
  `NAMA_KATEGORI` varchar(30) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `TIPE_TRANSAKSI` varchar(15) COLLATE utf8mb4_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `kategori`
--

INSERT INTO `kategori` (`ID_KATEGORI`, `NAMA_KATEGORI`, `TIPE_TRANSAKSI`) VALUES
(1, 'Gaji', 'Pemasukan'),
(2, 'Bonus', 'Pemasukan'),
(3, 'Hadiah', 'Pemasukan'),
(4, 'Lainnya (Pemasukan)', 'Pemasukan'),
(5, 'Makanan & Minuman', 'Pengeluaran'),
(6, 'Transportasi', 'Pengeluaran'),
(7, 'Pakaian', 'Pengeluaran'),
(8, 'Pendidikan', 'Pengeluaran'),
(9, 'Lainnya (Pengeluaran)', 'Pengeluaran');

-- --------------------------------------------------------

--
-- Table structure for table `laporan_tahunan`
--

CREATE TABLE `laporan_tahunan` (
  `tahun` int NOT NULL,
  `total_pemasukan` int DEFAULT NULL,
  `total_pengeluaran` int DEFAULT NULL,
  `saldo_akhir` int DEFAULT NULL,
  `dibuat_pada` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `migrations`
--

CREATE TABLE `migrations` (
  `id` int UNSIGNED NOT NULL,
  `migration` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '0001_01_01_000000_create_users_table', 1),
(2, '0001_01_01_000001_create_cache_table', 1),
(3, '0001_01_01_000002_create_jobs_table', 1);

-- --------------------------------------------------------

--
-- Table structure for table `password_reset_tokens`
--

CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `sessions`
--

CREATE TABLE `sessions` (
  `id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` bigint UNSIGNED DEFAULT NULL,
  `ip_address` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_agent` text COLLATE utf8mb4_unicode_ci,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_activity` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `sessions`
--

INSERT INTO `sessions` (`id`, `user_id`, `ip_address`, `user_agent`, `payload`, `last_activity`) VALUES
('Jlvvb1Alk9CQUn0bBxRTyQ2a1DRvblEtLjYlpKER', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'eyJfdG9rZW4iOiJjYVlJdTdoU0VISHRMenE2ZjJzdnRvTzg3am1xVHN3bkZmR3VSNWtCIiwiX3ByZXZpb3VzIjp7InVybCI6Imh0dHA6XC9cLzEyNy4wLjAuMTo4MDAwIiwicm91dGUiOm51bGx9LCJfZmxhc2giOnsib2xkIjpbXSwibmV3IjpbXX19', 1783667333);

-- --------------------------------------------------------

--
-- Table structure for table `sub_kategori`
--

CREATE TABLE `sub_kategori` (
  `ID_SUB` int NOT NULL,
  `ID_KATEGORI` int NOT NULL,
  `NAMA_SUB` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `sub_kategori`
--

INSERT INTO `sub_kategori` (`ID_SUB`, `ID_KATEGORI`, `NAMA_SUB`) VALUES
(1, 5, 'Bahan makanan'),
(2, 5, 'Jajanan'),
(3, 5, 'Makan diluar'),
(4, 6, 'Bensin'),
(5, 6, 'Parkir'),
(6, 7, 'Baju baru'),
(7, 7, 'Laundry');

-- --------------------------------------------------------

--
-- Table structure for table `tag`
--

CREATE TABLE `tag` (
  `ID_TAG` int NOT NULL,
  `NAMA_TAG` varchar(30) COLLATE utf8mb4_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tag`
--

INSERT INTO `tag` (`ID_TAG`, `NAMA_TAG`) VALUES
(1, 'Urgent'),
(2, 'Penting'),
(3, 'Tidak direncanakan'),
(4, 'Rutin'),
(5, 'Tabungan'),
(6, 'Investasi'),
(7, 'Darurat'),
(8, 'Hiburan'),
(9, 'Kesehatan'),
(10, 'Produktivitas'),
(11, 'Online'),
(12, 'Offline'),
(13, 'Marketplace'),
(14, 'Rumah'),
(15, 'Kantor'),
(16, 'Keluarga'),
(17, 'Sendiri'),
(18, 'Teman'),
(19, 'Promo'),
(20, 'Diskon');

-- --------------------------------------------------------

--
-- Table structure for table `transaksi`
--

CREATE TABLE `transaksi` (
  `ID_TRANSAKSI` int NOT NULL,
  `ID_USER` int NOT NULL,
  `ID_AKUN` int NOT NULL,
  `ID_KATEGORI` int NOT NULL,
  `ID_SUB` int DEFAULT NULL,
  `TANGGAL` date DEFAULT NULL,
  `TIPE_TRANSAKSI` varchar(15) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `JUMLAH` int DEFAULT NULL,
  `KETERANGAN` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `transaksi`
--

INSERT INTO `transaksi` (`ID_TRANSAKSI`, `ID_USER`, `ID_AKUN`, `ID_KATEGORI`, `ID_SUB`, `TANGGAL`, `TIPE_TRANSAKSI`, `JUMLAH`, `KETERANGAN`) VALUES
(3, 1, 2, 1, NULL, '2025-12-01', 'Pemasukan', 2000000, 'Gaji revisi'),
(4, 1, 2, 1, 1, '2025-12-10', 'Pemasukan', 100000, 'Test pemasukan kecil'),
(5, 1, 1, 5, 1, '2025-12-10', 'Pengeluaran', 20000, 'Test pengeluaran kecil'),
(21, 1, 2, 1, NULL, '2025-12-01', 'Pemasukan', 2500000, 'Gaji bulan Desember'),
(22, 1, 1, 5, 1, '2025-12-02', 'Pengeluaran', 55000, 'Belanja sayur + bahan dapur'),
(23, 1, 1, 5, 2, '2025-12-03', 'Pengeluaran', 18000, '-'),
(24, 1, 1, 5, 3, '2025-12-04', 'Pengeluaran', 45000, 'Dinner bareng teman'),
(25, 1, 1, 6, 4, '2025-12-05', 'Pengeluaran', 30000, '-'),
(26, 1, 1, 6, 5, '2025-12-06', 'Pengeluaran', 3000, 'Parkir harian'),
(27, 1, 2, 2, NULL, '2025-12-07', 'Pemasukan', 200000, 'Bonus proyek freelance'),
(28, 1, 1, 7, 7, '2025-12-08', 'Pengeluaran', 12000, '-'),
(29, 2, 3, 7, 6, '2025-12-09', 'Pengeluaran', 150000, 'Kaos & hoodie'),
(30, 1, 1, 3, NULL, '2025-12-10', 'Pemasukan', 500000, 'Hadiah dari keluarga'),
(31, 1, 2, 8, NULL, '2025-12-11', 'Pengeluaran', 67000, 'Beli buku mata kuliah'),
(32, 1, 1, 4, NULL, '2025-12-12', 'Pemasukan', 175000, 'Jual keyboard mechanical'),
(33, 1, 1, 9, NULL, '2025-12-13', 'Pengeluaran', 35000, 'Obat flu'),
(34, 2, 3, 9, NULL, '2025-12-14', 'Pengeluaran', 45000, 'Beli sabun, tisu, detergen'),
(35, 1, 1, 5, 3, '2025-12-15', 'Pengeluaran', 50000, 'Nongkrong malam minggu'),
(36, 1, 2, 1, NULL, '2025-12-21', 'Pemasukan', 100000, ''),
(42, 1, 1, 5, 1, '2025-12-21', 'Pengeluaran', 55000, ''),
(44, 2, 3, 2, NULL, '2025-12-19', 'Pemasukan', 1300000, ''),
(47, 1, 1, 1, NULL, '2025-12-21', 'Pemasukan', 300000, 'Tambahan akhir tahun');

--
-- Triggers `transaksi`
--
DELIMITER $$
CREATE TRIGGER `trg_transaksi_after_delete` AFTER DELETE ON `transaksi` FOR EACH ROW begin
    if old.tipe_transaksi = 'pemasukan' then
        update akun
        set saldo_sekarang = saldo_sekarang - old.jumlah
        where id_akun = old.id_akun;
    else
        update akun
        set saldo_sekarang = saldo_sekarang + old.jumlah
        where id_akun = old.id_akun;
    end if;
end
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_transaksi_after_insert` AFTER INSERT ON `transaksi` FOR EACH ROW begin
    insert into audit_log (id_transaksi, aksi, data_lama, data_baru)
    values (
        new.id_transaksi,
        'insert',
        null,
        concat(
            'user=', current_user(),
            ', akun=', new.id_akun,
            ', kategori=', new.id_kategori,
            ', sub=', ifnull(new.id_sub, 'null'),
            ', tanggal=', new.tanggal,
            ', tipe=', new.tipe_transaksi,
            ', jumlah=', new.jumlah
        )
    );

    if new.tipe_transaksi = 'pemasukan' then
        update akun
        set saldo_sekarang = saldo_sekarang + new.jumlah
        where id_akun = new.id_akun;
    else
        update akun
        set saldo_sekarang = saldo_sekarang - new.jumlah
        where id_akun = new.id_akun;
    end if;
end
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_transaksi_before_delete` BEFORE DELETE ON `transaksi` FOR EACH ROW begin
    insert into audit_log (id_transaksi, aksi, data_lama, data_baru)
    values (
        old.id_transaksi,
        'delete',
        concat(
            'user=', current_user(),
            ', akun=', old.id_akun,
            ', kategori=', old.id_kategori,
            ', sub=', ifnull(old.id_sub, 'null'),
            ', tanggal=', old.tanggal,
            ', tipe=', old.tipe_transaksi,
            ', jumlah=', old.jumlah
        ),
        null
    );
end
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_transaksi_before_update` BEFORE UPDATE ON `transaksi` FOR EACH ROW begin
    insert into audit_log (id_transaksi, aksi, data_lama, data_baru)
    values (
        old.id_transaksi,
        'update',
        concat(
            'user=', current_user(),
            ', akun=', old.id_akun,
            ', tipe=', old.tipe_transaksi,
            ', jumlah=', old.jumlah
        ),
        concat(
            'akun=', new.id_akun,
            ', tipe=', new.tipe_transaksi,
            ', jumlah=', new.jumlah
        )
    );

    if old.tipe_transaksi = 'pemasukan' then
        update akun set saldo_sekarang = saldo_sekarang - old.jumlah
        where id_akun = old.id_akun;
    else
        update akun set saldo_sekarang = saldo_sekarang + old.jumlah
        where id_akun = old.id_akun;
    end if;

    if new.tipe_transaksi = 'pemasukan' then
        update akun set saldo_sekarang = saldo_sekarang + new.jumlah
        where id_akun = new.id_akun;
    else
        update akun set saldo_sekarang = saldo_sekarang - new.jumlah
        where id_akun = new.id_akun;
    end if;
end
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `ID_USER` int NOT NULL,
  `NAMA_USER` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `PASSWORD` varchar(8) COLLATE utf8mb4_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`ID_USER`, `NAMA_USER`, `PASSWORD`) VALUES
(1, 'Aufa', '1234'),
(2, 'Karina', '5678');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `remember_token` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_transaksi_kategori`
-- (See below for the actual view)
--
CREATE TABLE `v_transaksi_kategori` (
`ID_TRANSAKSI` int
,`TANGGAL` date
,`NAMA_AKUN` varchar(50)
,`NAMA_KATEGORI` varchar(30)
,`TIPE_TRANSAKSI` varchar(15)
,`JUMLAH` int
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_transaksi_lengkap`
-- (See below for the actual view)
--
CREATE TABLE `v_transaksi_lengkap` (
`ID_TRANSAKSI` int
,`NAMA_USER` varchar(50)
,`NAMA_AKUN` varchar(50)
,`NAMA_KATEGORI` varchar(30)
,`NAMA_SUB` varchar(20)
,`TANGGAL` date
,`TIPE_TRANSAKSI` varchar(15)
,`JUMLAH` int
,`KETERANGAN` varchar(50)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_transaksi_user`
-- (See below for the actual view)
--
CREATE TABLE `v_transaksi_user` (
`NAMA_USER` varchar(50)
,`NAMA_AKUN` varchar(50)
,`NAMA_KATEGORI` varchar(30)
,`TANGGAL` date
,`TIPE_TRANSAKSI` varchar(15)
,`JUMLAH` int
,`KETERANGAN` varchar(50)
);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `akun`
--
ALTER TABLE `akun`
  ADD PRIMARY KEY (`ID_AKUN`),
  ADD KEY `FK_MEMILIKI` (`ID_USER`);

--
-- Indexes for table `audit_log`
--
ALTER TABLE `audit_log`
  ADD PRIMARY KEY (`ID_LOG`),
  ADD KEY `FK_DICATAT` (`ID_TRANSAKSI`);

--
-- Indexes for table `cache`
--
ALTER TABLE `cache`
  ADD PRIMARY KEY (`key`),
  ADD KEY `cache_expiration_index` (`expiration`);

--
-- Indexes for table `cache_locks`
--
ALTER TABLE `cache_locks`
  ADD PRIMARY KEY (`key`),
  ADD KEY `cache_locks_expiration_index` (`expiration`);

--
-- Indexes for table `diberi_transaksi_tag`
--
ALTER TABLE `diberi_transaksi_tag`
  ADD PRIMARY KEY (`ID_TAG`,`ID_TRANSAKSI`),
  ADD KEY `FK_DIBERI_TRANSAKSI_TAG2` (`ID_TRANSAKSI`);

--
-- Indexes for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`),
  ADD KEY `failed_jobs_connection_queue_failed_at_index` (`connection`,`queue`,`failed_at`);

--
-- Indexes for table `jobs`
--
ALTER TABLE `jobs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `jobs_queue_index` (`queue`);

--
-- Indexes for table `job_batches`
--
ALTER TABLE `job_batches`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `kategori`
--
ALTER TABLE `kategori`
  ADD PRIMARY KEY (`ID_KATEGORI`);

--
-- Indexes for table `laporan_tahunan`
--
ALTER TABLE `laporan_tahunan`
  ADD PRIMARY KEY (`tahun`);

--
-- Indexes for table `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `password_reset_tokens`
--
ALTER TABLE `password_reset_tokens`
  ADD PRIMARY KEY (`email`);

--
-- Indexes for table `sessions`
--
ALTER TABLE `sessions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sessions_user_id_index` (`user_id`),
  ADD KEY `sessions_last_activity_index` (`last_activity`);

--
-- Indexes for table `sub_kategori`
--
ALTER TABLE `sub_kategori`
  ADD PRIMARY KEY (`ID_SUB`),
  ADD KEY `FK_MEMPUNYAI` (`ID_KATEGORI`);

--
-- Indexes for table `tag`
--
ALTER TABLE `tag`
  ADD PRIMARY KEY (`ID_TAG`);

--
-- Indexes for table `transaksi`
--
ALTER TABLE `transaksi`
  ADD PRIMARY KEY (`ID_TRANSAKSI`),
  ADD KEY `FK_DIGUNAKAN` (`ID_AKUN`),
  ADD KEY `FK_DIGUNAKAN_OLEH` (`ID_KATEGORI`),
  ADD KEY `FK_DIPILIH_OLEH` (`ID_SUB`),
  ADD KEY `FK_MEMBUAT` (`ID_USER`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`ID_USER`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_email_unique` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `audit_log`
--
ALTER TABLE `audit_log`
  MODIFY `ID_LOG` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=42;

--
-- AUTO_INCREMENT for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `jobs`
--
ALTER TABLE `jobs`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `transaksi`
--
ALTER TABLE `transaksi`
  MODIFY `ID_TRANSAKSI` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=51;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

-- --------------------------------------------------------

--
-- Structure for view `v_transaksi_kategori`
--
DROP TABLE IF EXISTS `v_transaksi_kategori`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_transaksi_kategori`  AS SELECT `t`.`ID_TRANSAKSI` AS `ID_TRANSAKSI`, `t`.`TANGGAL` AS `TANGGAL`, `a`.`NAMA_AKUN` AS `NAMA_AKUN`, `k`.`NAMA_KATEGORI` AS `NAMA_KATEGORI`, `t`.`TIPE_TRANSAKSI` AS `TIPE_TRANSAKSI`, `t`.`JUMLAH` AS `JUMLAH` FROM ((`transaksi` `t` join `akun` `a` on((`t`.`ID_AKUN` = `a`.`ID_AKUN`))) join `kategori` `k` on((`t`.`ID_KATEGORI` = `k`.`ID_KATEGORI`))) ;

-- --------------------------------------------------------

--
-- Structure for view `v_transaksi_lengkap`
--
DROP TABLE IF EXISTS `v_transaksi_lengkap`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_transaksi_lengkap`  AS SELECT `t`.`ID_TRANSAKSI` AS `ID_TRANSAKSI`, `u`.`NAMA_USER` AS `NAMA_USER`, `a`.`NAMA_AKUN` AS `NAMA_AKUN`, `k`.`NAMA_KATEGORI` AS `NAMA_KATEGORI`, `sk`.`NAMA_SUB` AS `NAMA_SUB`, `t`.`TANGGAL` AS `TANGGAL`, `t`.`TIPE_TRANSAKSI` AS `TIPE_TRANSAKSI`, `t`.`JUMLAH` AS `JUMLAH`, `t`.`KETERANGAN` AS `KETERANGAN` FROM ((((`transaksi` `t` join `user` `u` on((`t`.`ID_USER` = `u`.`ID_USER`))) join `akun` `a` on((`t`.`ID_AKUN` = `a`.`ID_AKUN`))) join `kategori` `k` on((`t`.`ID_KATEGORI` = `k`.`ID_KATEGORI`))) left join `sub_kategori` `sk` on((`t`.`ID_SUB` = `sk`.`ID_SUB`))) ;

-- --------------------------------------------------------

--
-- Structure for view `v_transaksi_user`
--
DROP TABLE IF EXISTS `v_transaksi_user`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_transaksi_user`  AS SELECT `u`.`NAMA_USER` AS `NAMA_USER`, `a`.`NAMA_AKUN` AS `NAMA_AKUN`, `k`.`NAMA_KATEGORI` AS `NAMA_KATEGORI`, `t`.`TANGGAL` AS `TANGGAL`, `t`.`TIPE_TRANSAKSI` AS `TIPE_TRANSAKSI`, `t`.`JUMLAH` AS `JUMLAH`, `t`.`KETERANGAN` AS `KETERANGAN` FROM (((`transaksi` `t` join `user` `u` on((`t`.`ID_USER` = `u`.`ID_USER`))) join `akun` `a` on((`t`.`ID_AKUN` = `a`.`ID_AKUN`))) join `kategori` `k` on((`t`.`ID_KATEGORI` = `k`.`ID_KATEGORI`))) ;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `akun`
--
ALTER TABLE `akun`
  ADD CONSTRAINT `FK_MEMILIKI` FOREIGN KEY (`ID_USER`) REFERENCES `user` (`ID_USER`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `audit_log`
--
ALTER TABLE `audit_log`
  ADD CONSTRAINT `FK_DICATAT` FOREIGN KEY (`ID_TRANSAKSI`) REFERENCES `transaksi` (`ID_TRANSAKSI`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `diberi_transaksi_tag`
--
ALTER TABLE `diberi_transaksi_tag`
  ADD CONSTRAINT `FK_DIBERI_TRANSAKSI_TAG` FOREIGN KEY (`ID_TAG`) REFERENCES `tag` (`ID_TAG`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_DIBERI_TRANSAKSI_TAG2` FOREIGN KEY (`ID_TRANSAKSI`) REFERENCES `transaksi` (`ID_TRANSAKSI`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `sub_kategori`
--
ALTER TABLE `sub_kategori`
  ADD CONSTRAINT `FK_MEMPUNYAI` FOREIGN KEY (`ID_KATEGORI`) REFERENCES `kategori` (`ID_KATEGORI`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `transaksi`
--
ALTER TABLE `transaksi`
  ADD CONSTRAINT `FK_DIGUNAKAN` FOREIGN KEY (`ID_AKUN`) REFERENCES `akun` (`ID_AKUN`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_DIPILIH_OLEH` FOREIGN KEY (`ID_SUB`) REFERENCES `sub_kategori` (`ID_SUB`) ON DELETE CASCADE ON UPDATE CASCADE;

DELIMITER $$
--
-- Events
--
CREATE DEFINER=`root`@`localhost` EVENT `evt_laporan_keuangan_tahunan` ON SCHEDULE EVERY 1 YEAR STARTS '2026-01-01 00:00:00' ON COMPLETION NOT PRESERVE ENABLE DO BEGIN
    INSERT INTO laporan_tahunan (tahun, total_pemasukan, total_pengeluaran, saldo_akhir)
    SELECT
        YEAR(CURDATE()) - 1,
        SUM(CASE WHEN tipe_transaksi = 'Pemasukan' THEN jumlah ELSE 0 END),
        SUM(CASE WHEN tipe_transaksi = 'Pengeluaran' THEN jumlah ELSE 0 END),
        SUM(CASE
            WHEN tipe_transaksi = 'Pemasukan' THEN jumlah
            ELSE -jumlah
        END)
    FROM transaksi
    WHERE YEAR(tanggal) = YEAR(CURDATE()) - 1;
END$$

DELIMITER ;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
