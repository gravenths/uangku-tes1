<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('akun', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->foreignId('user_id')->constrained('users')->cascadeOnDelete();
            $table->string('nama_akun', 50);
            $table->enum('tipe_akun', ['Cash', 'Debit', 'Kredit', 'E-Money']);
            $table->unsignedBigInteger('saldo_awal')->default(0);
            $table->unsignedBigInteger('saldo_sekarang')->default(0);
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('akun');
    }
};
