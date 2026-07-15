<?php

namespace Database\Factories;

use App\Models\Transaksi;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends Factory<Transaksi>
 */
class TransaksiFactory extends Factory
{
    protected $model = Transaksi::class;

    public function definition(): array
    {
        return [
            'user_id'         => 1,
            'akun_id'         => 1,
            'kategori_id'     => fake()->numberBetween(1, 9),
            'sub_kategori_id' => null,
            'tanggal'         => fake()->dateTimeBetween('-1 year', 'now')->format('Y-m-d'),
            'tipe_transaksi'  => fake()->randomElement(['Pemasukan', 'Pengeluaran']),
            'jumlah'          => fake()->numberBetween(1, 500) * 1000,
            'keterangan'      => fake()->optional()->sentence(),
        ];
    }
}
