<?php

namespace App\Models;

use Database\Factories\TransaksiFactory;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Transaksi extends Model
{
    /** @use HasFactory<TransaksiFactory> */
    use HasFactory;

    protected $table = 'transaksi';

    protected $fillable = [
        'user_id',
        'akun_id',
        'kategori_id',
        'sub_kategori_id',
        'tanggal',
        'tipe_transaksi',
        'jumlah',
        'keterangan',
    ];

    protected function casts(): array
    {
        return [
            'tanggal' => 'date',
            'jumlah'  => 'integer',
        ];
    }

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    public function akun(): BelongsTo
    {
        return $this->belongsTo(Akun::class);
    }

    public function kategori(): BelongsTo
    {
        return $this->belongsTo(Kategori::class);
    }

    public function subKategori(): BelongsTo
    {
        return $this->belongsTo(SubKategori::class, 'sub_kategori_id');
    }

    public function tags(): BelongsToMany
    {
        return $this->belongsToMany(Tag::class, 'transaksi_tag');
    }

    public function auditLog(): HasMany
    {
        return $this->hasMany(AuditLog::class);
    }

    public function scopeForUser($query, int $userId)
    {
        return $query->where('user_id', $userId);
    }

    public function scopeFilter($query, array $filters)
    {
        if (!empty($filters['akun_id'])) {
            $query->where('akun_id', $filters['akun_id']);
        }

        if (!empty($filters['kategori_id'])) {
            $query->where('kategori_id', $filters['kategori_id']);
        }

        if (!empty($filters['tipe_transaksi'])) {
            $query->where('tipe_transaksi', $filters['tipe_transaksi']);
        }

        if (!empty($filters['tanggal_dari'])) {
            $query->whereDate('tanggal', '>=', $filters['tanggal_dari']);
        }

        if (!empty($filters['tanggal_sampai'])) {
            $query->whereDate('tanggal', '<=', $filters['tanggal_sampai']);
        }

        if (!empty($filters['tag_id'])) {
            $query->whereHas('tags', fn ($q) => $q->where('tags.id', $filters['tag_id']));
        }

        if (!empty($filters['search'])) {
            $query->where('keterangan', 'like', '%' . $filters['search'] . '%');
        }

        return $query;
    }
}
