import java.io.*;
import java.net.ServerSocket;
import java.net.Socket;
import java.net.SocketException;
import java.util.*;

public class Server {
    static final int BASEPORT = 9889;
    private static ServerSocket sIn;
    private static ArrayList<SocketManager> clients;
    public static ArrayList<Lobby> lobbies;

    public static void main(String[] args) throws IOException, InterruptedException {

        sIn = new ServerSocket(BASEPORT);
        clients = new ArrayList<>();
        lobbies = new ArrayList<>();
        while (true){
            Socket tmp = sIn.accept();
            SocketManager sm = new SocketManager(tmp);
            clients.add(sm);
            new Thread(sm).start();
        }
    }

    public static Lobby getLobby(){
        int i = 0;
        for (Lobby l:lobbies) {
            if(l.canJoin()){
                System.out.println(" connecting client to Lobby "+i);
                return l;
            }
            i++;
        }
        Lobby lobby = new Lobby();
        lobbies.add(lobby);
        System.out.println(" creating lobby "+i);
        return lobby;
    }
    public static void removeLobby(Lobby l){
        lobbies.remove(l);
    }
}
