Funzione main(): La funzione main() è il punto di ingresso dell'applicazione Flutter. Si chiama runApp() con un'istanza del widget MyApp, che rappresenta l'applicazione principale.

Classe Cronometro: Questa classe contiene una configurazione statica per un intervallo di tempo (millisInterval) e una variabile statica cron che rappresenta uno stream periodico che emette eventi a intervalli di tempo specifici, utilizzato come tick per la misurazione del tempo. La funzione restart() può essere chiamata per riavviare lo stream.

Classe _MyHomePageState: Questa è la classe di stato per MyHomePage. Gestisce la logica principale dell'applicazione. Contiene le variabili che tengono traccia del tempo trascorso in ore, minuti , secondi e decimi di secondi. Inoltre controlla la ruota per la visualizzazione dei secondi, che si inverte ogni volta che ne passa uno intero.

Metodo startCron(): Questo metodo avvia il cronometro. Crea un nuovo oggetto Cronometro e avvia un listener per lo stream nella classe Cronometro. Ogni volta che viene emesso un evento dallo stream, il tempo viene aggiornato e l'indicatore circolare percentuale cambia di conseguenza.

Metodo stopCron(): Questo metodo arresta il cronometro e visualizza il tempo trascorso nell'exTime.

Metodo pauseCron(): Questo metodo mette in pausa il cronometro.

Metodo build(): Questo metodo costruisce l'interfaccia utente dell'app. Mostra l'indicatore circolare percentuale, il tempo trascorso e i pulsanti di pausa, avvio e arresto.

Metodi getMainC() e getSecondC(): Questi metodi restituiscono i colori per l'indicatore circolare percentuale in base al tempo trascorso.

In generale, il codice crea un'applicazione Flutter che funge da cronometro. Quando si preme il pulsante "Play", il cronometro inizia a contare il tempo, mostrando un indicatore circolare percentuale. È possibile mettere in pausa e arrestare il cronometro utilizzando i pulsanti corrispondenti. Il tempo trascorso viene visualizzato sopra l'indicatore circolare.
