<?php

namespace App\Observers;

use App\Models\Akun;
use App\Models\AuditLog;
use App\Models\Transaksi;
use Illuminate\Support\Facades\DB;

class TransaksiObserver
{
    /**
     * Kolom transaksi yang disimpan di audit log.
     */
    private function auditFields(Transaksi $transaksi): array
    {
        return [
            'user_id'         => $transaksi->user_id,
            'akun_id'         => $transaksi->akun_id,
            'kategori_id'     => $transaksi->kategori_id,
            'sub_kategori_id' => $transaksi->sub_kategori_id,
            'tanggal'         => $transaksi->tanggal?->toDateString(),
            'tipe_transaksi'  => $transaksi->tipe_transaksi,
            'jumlah'          => $transaksi->jumlah,
            'keterangan'      => $transaksi->keterangan,
        ];
    }

    public function created(Transaksi $transaksi): void
    {
        DB::transaction(function () use ($transaksi) {
            $akun = Akun::lockForUpdate()->findOrFail($transaksi->akun_id);

            if ($transaksi->tipe_transaksi === 'Pemasukan') {
                $akun->saldo_sekarang += $transaksi->jumlah;
            } else {
                $akun->saldo_sekarang -= $transaksi->jumlah;
            }

            $akun->save();

            AuditLog::create([
                'transaksi_id' => $transaksi->id,
                'user_id'      => auth()->id(),
                'aksi'         => 'insert',
                'data_lama'    => null,
                'data_baru'    => $this->auditFields($transaksi),
            ]);
        });
    }

    public function updated(Transaksi $transaksi): void
    {
        DB::transaction(function () use ($transaksi) {
            $akunIdLama = $transaksi->getOriginal('akun_id');
            $akunIdBaru = $transaksi->akun_id;

            $tipeLama   = $transaksi->getOriginal('tipe_transaksi');
            $tipeBaru   = $transaksi->tipe_transaksi;

            $jumlahLama = (int) $transaksi->getOriginal('jumlah');
            $jumlahBaru = (int) $transaksi->jumlah;

            if ($akunIdLama === $akunIdBaru) {
                // Akun sama — satu lock
                $akun = Akun::lockForUpdate()->findOrFail($akunIdBaru);

                // Reverse efek lama
                if ($tipeLama === 'Pemasukan') {
                    $akun->saldo_sekarang -= $jumlahLama;
                } else {
                    $akun->saldo_sekarang += $jumlahLama;
                }

                // Terapkan efek baru
                if ($tipeBaru === 'Pemasukan') {
                    $akun->saldo_sekarang += $jumlahBaru;
                } else {
                    $akun->saldo_sekarang -= $jumlahBaru;
                }

                $akun->save();
            } else {
                // Akun berbeda — lock keduanya (urutan id kecil dulu untuk menghindari deadlock)
                $ids = collect([$akunIdLama, $akunIdBaru])->sort()->values();

                $akunA = Akun::lockForUpdate()->findOrFail($ids[0]);
                $akunB = Akun::lockForUpdate()->findOrFail($ids[1]);

                $akunLama = ($akunA->id === $akunIdLama) ? $akunA : $akunB;
                $akunBaru = ($akunA->id === $akunIdBaru) ? $akunA : $akunB;

                // Reverse efek di akun lama
                if ($tipeLama === 'Pemasukan') {
                    $akunLama->saldo_sekarang -= $jumlahLama;
                } else {
                    $akunLama->saldo_sekarang += $jumlahLama;
                }

                // Terapkan efek di akun baru
                if ($tipeBaru === 'Pemasukan') {
                    $akunBaru->saldo_sekarang += $jumlahBaru;
                } else {
                    $akunBaru->saldo_sekarang -= $jumlahBaru;
                }

                $akunLama->save();
                $akunBaru->save();
            }

            // Bangun data_lama dari nilai original sebelum update
            $dataLama = [
                'user_id'         => $transaksi->getOriginal('user_id'),
                'akun_id'         => $akunIdLama,
                'kategori_id'     => $transaksi->getOriginal('kategori_id'),
                'sub_kategori_id' => $transaksi->getOriginal('sub_kategori_id'),
                'tanggal'         => $transaksi->getOriginal('tanggal'),
                'tipe_transaksi'  => $tipeLama,
                'jumlah'          => $jumlahLama,
                'keterangan'      => $transaksi->getOriginal('keterangan'),
            ];

            AuditLog::create([
                'transaksi_id' => $transaksi->id,
                'user_id'      => auth()->id(),
                'aksi'         => 'update',
                'data_lama'    => $dataLama,
                'data_baru'    => $this->auditFields($transaksi),
            ]);
        });
    }

    /**
     * Gunakan `deleting` (sebelum baris dihapus) agar FK audit_log.transaksi_id
     * masih valid saat AuditLog di-insert.
     */
    public function deleting(Transaksi $transaksi): void
    {
        DB::transaction(function () use ($transaksi) {
            $akun = Akun::lockForUpdate()->findOrFail($transaksi->akun_id);

            if ($transaksi->tipe_transaksi === 'Pemasukan') {
                $akun->saldo_sekarang -= $transaksi->jumlah;
            } else {
                $akun->saldo_sekarang += $transaksi->jumlah;
            }

            $akun->save();

            AuditLog::create([
                'transaksi_id' => $transaksi->id,
                'user_id'      => auth()->id(),
                'aksi'         => 'delete',
                'data_lama'    => $this->auditFields($transaksi),
                'data_baru'    => null,
            ]);
        });
    }
}
