<?php
namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Services\MutationService;
use App\Models\Dna;
use MongoDB\Driver\Exception\BulkWriteException;

class DnaController extends Controller
{
    public function hasMutation(Request $request, MutationService $service)
    {
        $request->validate([
            'dna' => 'required|array|min:4',
            'dna.*' => ['required','string','regex:/^[ATCGatcg]+$/']
        ]);

        $dna = array_map('strtoupper', $request->input('dna'));
        $n = count($dna);
        foreach ($dna as $row) {
            if (strlen($row) !== $n) return response()->json(['error'=>'Matriz no NxN'], 422);
        }

        $hash = sha1(serialize($dna));
        $record = Dna::where('hash', $hash)->first();
        if ($record) {
            $hasMutation = (bool)$record->mutation;
        } else {
            $hasMutation = $service->hasMutation($dna);
            try {
                Dna::create(['dna'=>$dna,'mutation'=>$hasMutation,'hash'=>$hash]);
            } catch (BulkWriteException $e) {
                $existing = Dna::where('hash', $hash)->first();
                if ($existing) $hasMutation = (bool)$existing->mutation;
            }
        }

        return $hasMutation ? response()->json(['mutation'=>true], 200) : response()->json(['mutation'=>false], 403);
    }

    public function stats()
    {
        $mutations = Dna::where('mutation', true)->count();
        $noMutations = Dna::where('mutation', false)->count();

        $ratio = $noMutations > 0 ? round($mutations / $noMutations, 2) : null;

        return response()->json(['count_mutations'=>$mutations,'count_no_mutation'=>$noMutations,'ratio'=>$ratio]);
    }

    public function list()
    {
        $lastRequests = Dna::orderBy('created_at', 'desc')
            ->take(10)
            ->get(['dna', 'mutation', 'created_at'])
            ->map(function ($item) {
                return [
                    'date' => $item->created_at->format('Y-m-d H:i:s'),
                    'dna' => implode(',', $item->dna), // Convertimos array a cadena legible
                    'mutation' => $item->mutation ? 'Mutación' : 'No mutación'
                ];
            });

        return response()->json($lastRequests);
    }
}
