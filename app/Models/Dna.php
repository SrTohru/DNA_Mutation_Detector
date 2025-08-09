<?php
namespace App\Models;

use MongoDB\Laravel\Eloquent\Model; 

class Dna extends Model
{
    protected $connection = 'mongodb';
    protected $collection = 'dnas';
    protected $fillable = ['dna','mutation','hash'];
    protected $casts = [
        'dna' => 'array',
        'mutation' => 'boolean',
    ];
    public $timestamps = true;
}