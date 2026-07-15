<?php

namespace Tests\Feature;

use App\Models\Akun;
use App\Models\AuditLog;
use App\Models\Kategori;
use App\Models\Tag;
use App\Models\Transaksi;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class ModelRelationTest extends TestCase
{
    use RefreshDatabase;

    // -------------------------------------------------------------------------
    // Helpers
    // -------------------------------------------------------------------------

    private function makeUser(): User
    {
        return User::factory()->create();
    }

    private function makeAkun(User $user): Akun
    {
        return Akun::create([
            'user_id'        => $user->id,
            'nama_akun'      => 'Tabungan',
            'tipe_akun'      => 'Debit',
            'saldo_awal'     => 1_000_000,
            'saldo_sekarang' => 1_000_000,
        ]);
    }

    private function makeKategori(): Kategori
    {
        return Kategori::create([
            'nama_kategori'  => 'Gaji',
            'tipe_transaksi' => 'Pemasukan',
        ]);
    }

    private function makeTransaksi(User $user, Akun $akun, Kategori $kategori): Transaksi
    {
        $this->actingAs($user);

        return Transaksi::create([
            'user_id'        => $user->id,
            'akun_id'        => $akun->id,
            'kategori_id'    => $kategori->id,
            'tanggal'        => now()->toDateString(),
            'tipe_transaksi' => 'Pemasukan',
            'jumlah'         => 500_000,
        ]);
    }

    // -------------------------------------------------------------------------
    // Tests
    // -------------------------------------------------------------------------

    public function test_user_has_many_akun(): void
    {
        $user = $this->makeUser();
        $this->makeAkun($user);
        $this->makeAkun($user);

        $this->assertCount(2, $user->akun);
        $this->assertInstanceOf(Akun::class, $user->akun->first());
    }

    public function test_akun_belongs_to_user(): void
    {
        $user = $this->makeUser();
        $akun = $this->makeAkun($user);

        $this->assertInstanceOf(User::class, $akun->user);
        $this->assertEquals($user->id, $akun->user->id);
    }

    public function test_transaksi_belongs_to_akun(): void
    {
        $user      = $this->makeUser();
        $akun      = $this->makeAkun($user);
        $kategori  = $this->makeKategori();
        $transaksi = $this->makeTransaksi($user, $akun, $kategori);

        $this->assertInstanceOf(Akun::class, $transaksi->akun);
        $this->assertEquals($akun->id, $transaksi->akun->id);
    }

    public function test_transaksi_has_tags_via_pivot(): void
    {
        $user      = $this->makeUser();
        $akun      = $this->makeAkun($user);
        $kategori  = $this->makeKategori();
        $transaksi = $this->makeTransaksi($user, $akun, $kategori);

        $tag1 = Tag::create(['nama_tag' => 'Bonus']);
        $tag2 = Tag::create(['nama_tag' => 'Rutin']);

        $transaksi->tags()->attach([$tag1->id, $tag2->id]);

        $this->assertCount(2, $transaksi->fresh()->tags);
        $this->assertInstanceOf(Tag::class, $transaksi->fresh()->tags->first());
    }

    public function test_kategori_has_many_sub_kategori(): void
    {
        $kategori = $this->makeKategori();

        \App\Models\SubKategori::create([
            'kategori_id' => $kategori->id,
            'nama_sub'    => 'Gaji Pokok',
        ]);

        \App\Models\SubKategori::create([
            'kategori_id' => $kategori->id,
            'nama_sub'    => 'Bonus',
        ]);

        $this->assertCount(2, $kategori->subKategori);
        $this->assertInstanceOf(\App\Models\SubKategori::class, $kategori->subKategori->first());
    }

    public function test_transaksi_has_audit_log(): void
    {
        $user      = $this->makeUser();
        $akun      = $this->makeAkun($user);
        $kategori  = $this->makeKategori();
        $transaksi = $this->makeTransaksi($user, $akun, $kategori);

        // Observer otomatis membuat AuditLog saat transaksi dibuat
        $this->assertCount(1, $transaksi->auditLog);
        $this->assertInstanceOf(AuditLog::class, $transaksi->auditLog->first());
        $this->assertEquals('insert', $transaksi->auditLog->first()->aksi);
    }
}
