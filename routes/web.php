<?php
use Illuminate\Support\Facades\Route;

Route::get('/prueba', function () {
    return 'Ruta de prueba funcionando';
});

Route::get('/', function () {
    return view('welcome');
});
