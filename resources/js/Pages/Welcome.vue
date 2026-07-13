<script setup>
import { Head } from '@inertiajs/vue3'
</script>

<template>
  <Head title="Selamat Datang" />

  <div class="min-h-screen flex flex-col items-center justify-center bg-gradient-to-br from-gray-900 via-gray-800 to-gray-900 text-white">
    <div class="text-center space-y-6">
      <div class="flex items-center justify-center space-x-3">
        <div class="w-12 h-12 bg-emerald-500 rounded-xl flex items-center justify-center text-2xl font-bold shadow-lg shadow-emerald-500/30">
          U
        </div>
        <h1 class="text-5xl font-bold tracking-tight">
          Uang<span class="text-emerald-400">Ku</span>
        </h1>
      </div>

      <p class="text-gray-400 text-lg max-w-md">
        Aplikasi Manajemen Keuangan Pribadi
      </p>

      <div class="flex items-center space-x-2 text-emerald-400">
        <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 20 20">
          <path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd" />
        </svg>
        <span class="text-sm font-medium">Inertia + Vue 3 — Setup Berhasil</span>
      </div>

      <div class="pt-4 flex flex-wrap justify-center gap-3 text-xs text-gray-500">
        <span class="px-3 py-1 bg-gray-800 rounded-full">Laravel 13</span>
        <span class="px-3 py-1 bg-gray-800 rounded-full">Vue 3</span>
        <span class="px-3 py-1 bg-gray-800 rounded-full">Inertia.js</span>
        <span class="px-3 py-1 bg-gray-800 rounded-full">Tailwind v4</span>
        <span class="px-3 py-1 bg-gray-800 rounded-full">Sanctum</span>
      </div>
    </div>
  </div>
</template>
