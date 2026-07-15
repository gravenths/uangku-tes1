<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;

class Tag extends Model
{
    protected $table = 'tag';

    protected $fillable = [
        'nama_tag',
    ];

    public function transaksi(): BelongsToMany
    {
        return $this->belongsToMany(Transaksi::class, 'transaksi_tag');
    }
}
