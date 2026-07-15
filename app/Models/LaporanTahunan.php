<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class LaporanTahunan extends Model
{
    protected $table = 'laporan_tahunan';

    public $timestamps = false;

    protected $fillable = [
        'tahun',
        'user_id',
        'total_pemasukan',
        'total_pengeluaran',
        'saldo_akhir',
    ];

    protected function casts(): array
    {
        return [
            'dibuat_pada' => 'datetime',
        ];
    }

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }
}
