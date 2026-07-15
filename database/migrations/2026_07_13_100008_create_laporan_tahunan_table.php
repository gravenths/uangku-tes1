<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('laporan_tahunan', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->unsignedSmallInteger('tahun');
            $table->foreignId('user_id')->constrained('users')->cascadeOnDelete();
            $table->unsignedBigInteger('total_pemasukan')->default(0);
            $table->unsignedBigInteger('total_pengeluaran')->default(0);
            $table->bigInteger('saldo_akhir')->default(0);
            $table->timestamp('dibuat_pada')->useCurrent();

            $table->unique(['tahun', 'user_id']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('laporan_tahunan');
    }
};
