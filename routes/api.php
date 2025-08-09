<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\DnaController;

Route::post('/mutation', [DnaController::class, 'hasMutation']);
Route::get('/stats', [DnaController::class, 'stats']);
Route::get('/list', [DnaController::class, 'list']);
