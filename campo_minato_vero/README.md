Il progetto consiste nell implementazione del famoso gioco "campo minato" con la possibilita di personalizzare le dimensioni del campo.

1. **Punto d'ingresso**: L'applicazione inizia eseguendo la funzione `main()`, che avvia l'app Flutter. Utilizza la libreria `flutter_phoenix` per gestire il riavvio del gioco quando l'utente preme il pulsante di ricarica. L'app principale è `MyApp`.

2. **Classe `MyApp`**: `MyApp` è un widget di stato (`StatefulWidget`) e rappresenta l'intera applicazione. Questa classe è responsabile della creazione e inizializzazione del campo di gioco e dove è possibile selezionare la dimensione del campo di gioco.

3. **Campo di Gioco**: Il campo di gioco è rappresentato dalla classe `Campo`, che è un widget di stato. `Campo` viene creato nel metodo `build` di `MyApp` e configurato con un'istanza di `CampoState`.

4. **Classe `CampoState`**: `CampoState` rappresenta lo stato del campo di gioco. Viene utilizzata per disporre le celle del campo minato in un layout personalizzato (`CustomMultiChildLayout`). La classe gestisce anche gli eventi di tocco e di lungo tocco sulle celle del campo, cosi da scoprire e posizionare le "bandiere".

5. **Layout personalizzato `_CascadeLayoutDelegate`**: Questa classe personalizzata è un delegato per il layout delle celle sul campo minato che rispetta le dimensioni che sono state impostate all inizio del gioco.

6. **Classe `CellProp`**: Questa classe rappresenta le proprietà di ciascuna cella nel campo minato. Gestisce se la cella è una bomba, se è stata segnata con una bandiera, se è stata vista e quante bombe sono nelle celle vicine.

7. **Classe `Buttons`**: Questa classe gestisce una mappa di celle (`buttonsProp`) e fornisce metodi per manipolare le celle. Questi metodi includono la visualizzazione di una cella, la marcatura di una cella con una bandiera e la gestione dell'apertura di celle vuote. La classe è utilizzata anche per ottenere il colore delle celle.

8. **Metodo `initNum()`**: Questo metodo inizializza il campo minato, assegnando casualmente le bombe alle celle e calcolando il numero di bombe nelle celle vicine.

Gli utenti possono aprire le celle e contrassegnarle con una bandiera per identificare le bombe. Quando una cella con una bomba viene aperta, il gioco viene perso. Quando tutte le celle senza bombe sono state aperte, il gioco viene vinto. Il progetto è strutturato in modo modulare, con classi separate per gestire le diverse funzionalità del gioco.
