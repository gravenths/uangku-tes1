<?php

namespace App\Models;

use Database\Factories\AkunFactory;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Akun extends Model
{
    /** @use HasFactory<AkunFactory> */
    use HasFactory;

    protected $table = 'akun';

    protected $fillable = [
        'user_id',
        'nama_akun',
        'tipe_akun',
        'saldo_awal',
        'saldo_sekarang',
    ];

    protected function casts(): array
    {
        return [
            'saldo_awal'      => 'integer',
            'saldo_sekarang'  => 'integer',
        ];
    }

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    public function transaksi(): HasMany
    {
        return $this->hasMany(Transaksi::class);
    }

    public function scopeForUser($query, int $userId)
    {
        return $query->where('user_id', $userId);
    }
}
