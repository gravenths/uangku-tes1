<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('transaksi', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->foreignId('user_id')->constrained('users')->cascadeOnDelete();
            $table->foreignId('akun_id')->constrained('akun')->cascadeOnDelete();
            $table->foreignId('kategori_id')->constrained('kategori')->restrictOnDelete();
            $table->foreignId('sub_kategori_id')->nullable()->constrained('sub_kategori')->nullOnDelete();
            $table->date('tanggal');
            $table->enum('tipe_transaksi', ['Pemasukan', 'Pengeluaran']);
            $table->unsignedBigInteger('jumlah');
            $table->string('keterangan', 255)->nullable();
            $table->timestamps();

            $table->index(['user_id', 'tanggal']);
            $table->index(['akun_id', 'tanggal']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('transaksi');
    }
};
