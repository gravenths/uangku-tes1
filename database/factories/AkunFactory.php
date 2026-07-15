<?php

namespace Database\Factories;

use App\Models\Akun;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends Factory<Akun>
 */
class AkunFactory extends Factory
{
    protected $model = Akun::class;

    public function definition(): array
    {
        $saldo = fake()->numberBetween(0, 5000) * 1000;

        return [
            'nama_akun'      => fake()->randomElement(['Dompet', 'BCA', 'BRI', 'Mandiri', 'GoPay', 'OVO', 'Dana', 'ShopeePay']),
            'tipe_akun'      => fake()->randomElement(['Cash', 'Debit', 'E-Money']),
            'saldo_awal'     => $saldo,
            'saldo_sekarang' => $saldo,
            // user_id diisi dari luar via state/create(['user_id' => ...])
        ];
    }
}
