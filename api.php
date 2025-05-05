<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\AplikasiController;
use App\Http\Controllers\Api\UserAplikasiController;
use App\Http\Controllers\Api\EventAplikasiController;
use App\Http\Controllers\Api\KamarController;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| is assigned the "api" middleware group. Enjoy building your API!
|
*/

// UserAolikasi routes
Route::post('register', [UserAplikasiController::class, 'register']);
Route::post('login', [UserAplikasiController::class, 'login']);

Route::middleware('auth:sanctum')->group(function () {
    Route::get('profile', [UserAplikasiController::class, 'getProfile']);
    Route::post('logout', [UserAplikasiController::class, 'logout']);
    Route::put('profile/update', [UserAplikasiController::class, 'updateProfile']);
});

// Event routes
Route::middleware('auth:sanctum')->group(function () {
    Route::get('events', [EventAplikasiController::class, 'index']);
    Route::get('events/{id}', [EventAplikasiController::class, 'show']);
    Route::post('events', [EventAplikasiController::class, 'store']);
    Route::put('events/{id}', [EventAplikasiController::class, 'update']);
    Route::delete('events/{id}', [EventAplikasiController::class, 'destroy']);
});

// Kamar routes
Route::middleware('auth:sanctum')->group(function () {
    Route::get('kamar', [KamarController::class, 'index']);
    Route::get('kamar/{id}', [KamarController::class, 'show']);
    Route::post('kamar', [KamarController::class, 'store']);
    Route::put('kamar/{id}', [KamarController::class, 'update']);
    Route::delete('kamar/{id}', [KamarController::class, 'destroy']);
});

// Application routes
Route::prefix('aplikasi')->group(function () {
    Route::get('/beranda', [AplikasiController::class, 'getBeranda']);
    Route::get('/event', [AplikasiController::class, 'getEvent']);
    Route::get('/fasilitas', [AplikasiController::class, 'getFasilitas']);
});