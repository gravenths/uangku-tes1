<?php

namespace Tests\Unit;

use App\Models\Akun;
use App\Models\AuditLog;
use App\Models\Kategori;
use App\Models\Transaksi;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class TransaksiObserverTest extends TestCase
{
    use RefreshDatabase;

    // -------------------------------------------------------------------------
    // Helpers
    // -------------------------------------------------------------------------

    private function createUser(): User
    {
        return User::factory()->create();
    }

    private function createAkun(User $user, int $saldoAwal): Akun
    {
        return Akun::create([
            'user_id'        => $user->id,
            'nama_akun'      => 'Dompet',
            'tipe_akun'      => 'Cash',
            'saldo_awal'     => $saldoAwal,
            'saldo_sekarang' => $saldoAwal,
        ]);
    }

    private function createKategori(string $tipe): Kategori
    {
        return Kategori::create([
            'nama_kategori'  => 'Kategori ' . $tipe,
            'tipe_transaksi' => $tipe,
        ]);
    }

    // -------------------------------------------------------------------------
    // Tests
    // -------------------------------------------------------------------------

    public function test_saldo_bertambah_saat_transaksi_pemasukan_dibuat(): void
    {
        $user      = $this->createUser();
        $akun      = $this->createAkun($user, 100_000);
        $kategori  = $this->createKategori('Pemasukan');

        $this->actingAs($user);

        Transaksi::create([
            'user_id'        => $user->id,
            'akun_id'        => $akun->id,
            'kategori_id'    => $kategori->id,
            'tanggal'        => now()->toDateString(),
            'tipe_transaksi' => 'Pemasukan',
            'jumlah'         => 50_000,
        ]);

        $this->assertEquals(150_000, $akun->fresh()->saldo_sekarang);
    }

    public function test_saldo_berkurang_saat_transaksi_pengeluaran_dibuat(): void
    {
        $user     = $this->createUser();
        $akun     = $this->createAkun($user, 200_000);
        $kategori = $this->createKategori('Pengeluaran');

        $this->actingAs($user);

        Transaksi::create([
            'user_id'        => $user->id,
            'akun_id'        => $akun->id,
            'kategori_id'    => $kategori->id,
            'tanggal'        => now()->toDateString(),
            'tipe_transaksi' => 'Pengeluaran',
            'jumlah'         => 80_000,
        ]);

        $this->assertEquals(120_000, $akun->fresh()->saldo_sekarang);
    }

    public function test_audit_log_dibuat_saat_transaksi_baru(): void
    {
        $user     = $this->createUser();
        $akun     = $this->createAkun($user, 100_000);
        $kategori = $this->createKategori('Pemasukan');

        $this->actingAs($user);

        $transaksi = Transaksi::create([
            'user_id'        => $user->id,
            'akun_id'        => $akun->id,
            'kategori_id'    => $kategori->id,
            'tanggal'        => now()->toDateString(),
            'tipe_transaksi' => 'Pemasukan',
            'jumlah'         => 30_000,
        ]);

        $log = AuditLog::where('transaksi_id', $transaksi->id)->get();

        $this->assertCount(1, $log);
        $this->assertEquals('insert', $log->first()->aksi);
        $this->assertNull($log->first()->data_lama);
        $this->assertNotNull($log->first()->data_baru);
    }

    public function test_saldo_diperbarui_saat_transaksi_diubah(): void
    {
        $user     = $this->createUser();
        $akun     = $this->createAkun($user, 500_000);
        $kategori = $this->createKategori('Pengeluaran');

        $this->actingAs($user);

        // Buat transaksi pengeluaran 100.000 → saldo = 400.000
        $transaksi = Transaksi::create([
            'user_id'        => $user->id,
            'akun_id'        => $akun->id,
            'kategori_id'    => $kategori->id,
            'tanggal'        => now()->toDateString(),
            'tipe_transaksi' => 'Pengeluaran',
            'jumlah'         => 100_000,
        ]);

        $this->assertEquals(400_000, $akun->fresh()->saldo_sekarang);

        // Update jumlah menjadi 200.000 → reverse 100k (saldo 500k), terapkan 200k → saldo 300k
        $transaksi->update(['jumlah' => 200_000]);

        $this->assertEquals(300_000, $akun->fresh()->saldo_sekarang);
    }

    public function test_saldo_dikembalikan_saat_transaksi_dihapus(): void
    {
        $user     = $this->createUser();
        $akun     = $this->createAkun($user, 300_000);
        $kategori = $this->createKategori('Pemasukan');

        $this->actingAs($user);

        $transaksi = Transaksi::create([
            'user_id'        => $user->id,
            'akun_id'        => $akun->id,
            'kategori_id'    => $kategori->id,
            'tanggal'        => now()->toDateString(),
            'tipe_transaksi' => 'Pemasukan',
            'jumlah'         => 75_000,
        ]);

        $this->assertEquals(375_000, $akun->fresh()->saldo_sekarang);

        $transaksi->delete();

        $this->assertEquals(300_000, $akun->fresh()->saldo_sekarang);
    }

    public function test_audit_log_dibuat_saat_transaksi_diubah(): void
    {
        $user     = $this->createUser();
        $akun     = $this->createAkun($user, 500_000);
        $kategori = $this->createKategori('Pengeluaran');

        $this->actingAs($user);

        $transaksi = Transaksi::create([
            'user_id'        => $user->id,
            'akun_id'        => $akun->id,
            'kategori_id'    => $kategori->id,
            'tanggal'        => now()->toDateString(),
            'tipe_transaksi' => 'Pengeluaran',
            'jumlah'         => 50_000,
        ]);

        $transaksi->update(['jumlah' => 90_000]);

        $updateLog = AuditLog::where('transaksi_id', $transaksi->id)
            ->where('aksi', 'update')
            ->first();

        $this->assertNotNull($updateLog);
        $this->assertEquals('update', $updateLog->aksi);
        $this->assertNotNull($updateLog->data_lama);
        $this->assertNotNull($updateLog->data_baru);
        $this->assertEquals(50_000, $updateLog->data_lama['jumlah']);
        $this->assertEquals(90_000, $updateLog->data_baru['jumlah']);
    }

    public function test_audit_log_dibuat_saat_transaksi_dihapus(): void
    {
        $user     = $this->createUser();
        $akun     = $this->createAkun($user, 200_000);
        $kategori = $this->createKategori('Pengeluaran');

        $this->actingAs($user);

        $transaksi = Transaksi::create([
            'user_id'        => $user->id,
            'akun_id'        => $akun->id,
            'kategori_id'    => $kategori->id,
            'tanggal'        => now()->toDateString(),
            'tipe_transaksi' => 'Pengeluaran',
            'jumlah'         => 40_000,
        ]);

        $transaksiId = $transaksi->id;
        $transaksi->delete();

        // Setelah delete, FK transaksi_id di audit_log di-set NULL (nullOnDelete),
        // sehingga query berdasarkan user_id + aksi.
        $deleteLog = AuditLog::where('user_id', $user->id)
            ->where('aksi', 'delete')
            ->first();

        $this->assertNotNull($deleteLog);
        $this->assertEquals('delete', $deleteLog->aksi);
        $this->assertNotNull($deleteLog->data_lama);
        $this->assertNull($deleteLog->data_baru);
        $this->assertEquals('Pengeluaran', $deleteLog->data_lama['tipe_transaksi']);
        $this->assertEquals(40_000, $deleteLog->data_lama['jumlah']);
    }

    public function test_saldo_diperbarui_saat_pindah_akun(): void
    {
        $user      = $this->createUser();
        $akunA     = $this->createAkun($user, 500_000);
        $akunB     = $this->createAkun($user, 200_000);
        $kategori  = $this->createKategori('Pengeluaran');

        $this->actingAs($user);

        // Buat transaksi pengeluaran 100.000 di akun A → saldo A = 400.000
        $transaksi = Transaksi::create([
            'user_id'        => $user->id,
            'akun_id'        => $akunA->id,
            'kategori_id'    => $kategori->id,
            'tanggal'        => now()->toDateString(),
            'tipe_transaksi' => 'Pengeluaran',
            'jumlah'         => 100_000,
        ]);

        $this->assertEquals(400_000, $akunA->fresh()->saldo_sekarang);
        $this->assertEquals(200_000, $akunB->fresh()->saldo_sekarang);

        // Pindah ke akun B → akun A kembali ke 500k, akun B dikurangi 100k → 100k
        $transaksi->update(['akun_id' => $akunB->id]);

        $this->assertEquals(500_000, $akunA->fresh()->saldo_sekarang);
        $this->assertEquals(100_000, $akunB->fresh()->saldo_sekarang);
    }
}
