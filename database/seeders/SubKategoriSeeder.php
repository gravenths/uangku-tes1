<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class SubKategoriSeeder extends Seeder
{
    public function run(): void
    {
        DB::table('sub_kategori')->insert([
            ['id' => 1, 'kategori_id' => 5, 'nama_sub' => 'Bahan makanan', 'created_at' => now(), 'updated_at' => now()],
            ['id' => 2, 'kategori_id' => 5, 'nama_sub' => 'Jajanan',       'created_at' => now(), 'updated_at' => now()],
            ['id' => 3, 'kategori_id' => 5, 'nama_sub' => 'Makan diluar',  'created_at' => now(), 'updated_at' => now()],
            ['id' => 4, 'kategori_id' => 6, 'nama_sub' => 'Bensin',        'created_at' => now(), 'updated_at' => now()],
            ['id' => 5, 'kategori_id' => 6, 'nama_sub' => 'Parkir',        'created_at' => now(), 'updated_at' => now()],
            ['id' => 6, 'kategori_id' => 7, 'nama_sub' => 'Baju baru',     'created_at' => now(), 'updated_at' => now()],
            ['id' => 7, 'kategori_id' => 7, 'nama_sub' => 'Laundry',       'created_at' => now(), 'updated_at' => now()],
        ]);
    }
}
