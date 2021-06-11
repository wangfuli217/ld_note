## Note implementative
- Il merge sort implementato ricorsivamente, andava in segmentation fault dopo circa 150.000 elementi processati, questo perche' finiva lo stack.
    
  Reimplementandolo iterativamente il problema e' stato risolto.
- Il quick sort con molti elementi uguali impiega molto piu' tempo perche' sbilancia la partizione degli elementi minori o uguali al pivot, andando nel caso peggiore quadratico. 
  
  Abbiamo quindi reimplementato l'algoritmo, suddividendo l'array in 3 partizioni:
    - Elementi minori al pivot
    - Elementi uguali al pivot
    - Elementi maggiori al pivot

  In questo modo tutti gli elementi ugulai al pivot si troveranno gia' nella loro posizione definitiva e le due restanti partizioni 
  non saranno piu sbilanciate come prima.
  
  Inoltre abbiamo notato che riordinando un array preordinato in odrinde decrescente, le partizioni venivano nuovamente sbilanciate,
  abbiamo quindi deciso di selezionare sempre come pivot l'elemento centrale dell'array invece del primo.


## Sorting times
| Sorting   | Integer time  | Float time    | Strings time  |
| --------- | ------------- | ------------- | ------------- |
| Selection | > 10 minutes  | > 10 minutes  | > 10 minutes  |
| Insertion | > 10 minutes  | > 10 minutes  | > 10 minutes  |
| Merge     | 10.07 seconds | 10.59 seconds | 12.04 seconds |
| Quick     | 9.31 seconds  | 10.61 seconds | 8.51 seconds |
| Heap      | 33.13 seconds | 28.31 seconds | 29.02 seconds |