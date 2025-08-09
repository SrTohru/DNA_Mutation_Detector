# DnaMutationDetectorFrontend

This project was generated using [Angular CLI](https://github.com/angular/angular-cli) version 20.1.5.

## Development server

To start a local development server, run:

```bash
ng serve
```

# Proyecto Detector de Mutaciones de ADN

Este proyecto consta de dos partes:

1. **Backend (Laravel + MongoDB)**  
   Proporciona la API para detectar mutaciones en cadenas de ADN y guardar el historial en base de datos.
   Endpoints principales:
   - POST /mutation → Recibe una matriz NxN de ADN y responde si tiene mutación.
   - GET /stats → Devuelve estadísticas de mutaciones detectadas y no detectadas.
   - GET /list → Lista las últimas 10 verificaciones realizadas con su ADN, resultado y fecha.

2. **Frontend (Angular)**  
   Interfaz web que consume los servicios del backend:
   - Muestra las estadísticas en el encabezado.
   - Permite ingresar una cadena de ADN para verificar si tiene mutación.
   - Muestra en tabla las últimas 10 verificaciones.

## Ejemplos de uso API

Detectar mutación:
curl -X POST "https://wise-kingfisher-1srtohrus-a8b5aca5.koyeb.app/mutation" \
-H "Content-Type: application/json" \
-d '{"dna":["ATGCGA","CAGTGC","TTATGT","AGAAGG","CCCCTA","TCACTG"]}'

Ver estadísticas:
curl "https://wise-kingfisher-1srtohrus-a8b5aca5.koyeb.app/stats"

Listado últimas peticiones:
curl "https://wise-kingfisher-1srtohrus-a8b5aca5.koyeb.app/list"

## Ejemplos de ADN
Mutado: ATGCGA,CAGTGC,TTATGT,AGAAGG,CCCCTA,TCACTG  
No mutado: ATGCGA,CAGTGC,TTATTT,AGACGG,GCGTCA,TCACTG



Angular CLI does not come with an end-to-end testing framework by default. You can choose one that suits your needs.

## Additional Resources

For more information on using the Angular CLI, including detailed command references, visit the [Angular CLI Overview and Command Reference](https://angular.dev/tools/cli) page.
