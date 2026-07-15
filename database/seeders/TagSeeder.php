<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class TagSeeder extends Seeder
{
    public function run(): void
    {
        DB::table('tag')->insert([
            ['id' =>  1, 'nama_tag' => 'Urgent',             'created_at' => now(), 'updated_at' => now()],
            ['id' =>  2, 'nama_tag' => 'Penting',            'created_at' => now(), 'updated_at' => now()],
            ['id' =>  3, 'nama_tag' => 'Tidak direncanakan', 'created_at' => now(), 'updated_at' => now()],
            ['id' =>  4, 'nama_tag' => 'Rutin',              'created_at' => now(), 'updated_at' => now()],
            ['id' =>  5, 'nama_tag' => 'Tabungan',           'created_at' => now(), 'updated_at' => now()],
            ['id' =>  6, 'nama_tag' => 'Investasi',          'created_at' => now(), 'updated_at' => now()],
            ['id' =>  7, 'nama_tag' => 'Darurat',            'created_at' => now(), 'updated_at' => now()],
            ['id' =>  8, 'nama_tag' => 'Hiburan',            'created_at' => now(), 'updated_at' => now()],
            ['id' =>  9, 'nama_tag' => 'Kesehatan',          'created_at' => now(), 'updated_at' => now()],
            ['id' => 10, 'nama_tag' => 'Produktivitas',      'created_at' => now(), 'updated_at' => now()],
            ['id' => 11, 'nama_tag' => 'Online',             'created_at' => now(), 'updated_at' => now()],
            ['id' => 12, 'nama_tag' => 'Offline',            'created_at' => now(), 'updated_at' => now()],
            ['id' => 13, 'nama_tag' => 'Marketplace',        'created_at' => now(), 'updated_at' => now()],
            ['id' => 14, 'nama_tag' => 'Rumah',              'created_at' => now(), 'updated_at' => now()],
            ['id' => 15, 'nama_tag' => 'Kantor',             'created_at' => now(), 'updated_at' => now()],
            ['id' => 16, 'nama_tag' => 'Keluarga',           'created_at' => now(), 'updated_at' => now()],
            ['id' => 17, 'nama_tag' => 'Sendiri',            'created_at' => now(), 'updated_at' => now()],
            ['id' => 18, 'nama_tag' => 'Teman',              'created_at' => now(), 'updated_at' => now()],
            ['id' => 19, 'nama_tag' => 'Promo',              'created_at' => now(), 'updated_at' => now()],
            ['id' => 20, 'nama_tag' => 'Diskon',             'created_at' => now(), 'updated_at' => now()],
        ]);
    }
}
