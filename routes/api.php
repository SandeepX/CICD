<?php

use App\Http\Controllers\HealthCheckController;
use App\Http\Controllers\Api\PostController;
use Illuminate\Support\Facades\Route;

Route::get('/health', [HealthCheckController::class, 'index']);
Route::get('/health/detailed', [HealthCheckController::class, 'detailed']);

Route::apiResource('posts', PostController::class);
