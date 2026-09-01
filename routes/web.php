<?php

use Illuminate\Support\Facades\Route;

Route::get('/', function () {
    return view('welcome', [
        'name' => config('app.name'),
        'ci_cd' => true,
    ]);
});
