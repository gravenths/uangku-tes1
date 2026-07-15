<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Kategori extends Model
{
    protected $table = 'kategori';

    protected $fillable = [
        'nama_kategori',
        'tipe_transaksi',
    ];

    public function subKategori(): HasMany
    {
        return $this->hasMany(SubKategori::class);
    }

    public function transaksi(): HasMany
    {
        return $this->hasMany(Transaksi::class);
    }

    public function scopePemasukan($query)
    {
        return $query->where('tipe_transaksi', 'pemasukan');
    }

    public function scopePengeluaran($query)
    {
        return $query->where('tipe_transaksi', 'pengeluaran');
    }
}
