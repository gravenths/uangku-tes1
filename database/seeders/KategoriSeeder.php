<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class KategoriSeeder extends Seeder
{
    public function run(): void
    {
        DB::table('kategori')->insert([
            ['id' => 1, 'nama_kategori' => 'Gaji',                  'tipe_transaksi' => 'Pemasukan',   'created_at' => now(), 'updated_at' => now()],
            ['id' => 2, 'nama_kategori' => 'Bonus',                 'tipe_transaksi' => 'Pemasukan',   'created_at' => now(), 'updated_at' => now()],
            ['id' => 3, 'nama_kategori' => 'Hadiah',                'tipe_transaksi' => 'Pemasukan',   'created_at' => now(), 'updated_at' => now()],
            ['id' => 4, 'nama_kategori' => 'Lainnya (Pemasukan)',   'tipe_transaksi' => 'Pemasukan',   'created_at' => now(), 'updated_at' => now()],
            ['id' => 5, 'nama_kategori' => 'Makanan & Minuman',     'tipe_transaksi' => 'Pengeluaran', 'created_at' => now(), 'updated_at' => now()],
            ['id' => 6, 'nama_kategori' => 'Transportasi',          'tipe_transaksi' => 'Pengeluaran', 'created_at' => now(), 'updated_at' => now()],
            ['id' => 7, 'nama_kategori' => 'Pakaian',               'tipe_transaksi' => 'Pengeluaran', 'created_at' => now(), 'updated_at' => now()],
            ['id' => 8, 'nama_kategori' => 'Pendidikan',            'tipe_transaksi' => 'Pengeluaran', 'created_at' => now(), 'updated_at' => now()],
            ['id' => 9, 'nama_kategori' => 'Lainnya (Pengeluaran)', 'tipe_transaksi' => 'Pengeluaran', 'created_at' => now(), 'updated_at' => now()],
        ]);
    }
}
