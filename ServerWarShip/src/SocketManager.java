import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.Socket;
import java.net.SocketException;

public class SocketManager implements Runnable {
    private Socket socket;
    private BufferedReader bf;
    private PrintWriter out ;
    private Lobby lobby;
    private int nPlayer;
    public SocketManager(Socket socket){
        this.socket = socket;
    }

    @Override
    public void run() {
        lobby = Server.getLobby();
        nPlayer = lobby.join(this);
        try {
            bf = new BufferedReader(new InputStreamReader(socket.getInputStream()));
            out = new PrintWriter(socket.getOutputStream(), true);
            while (true){
                String msg = receiveMsg();
                if(msg==null  || msg.equals( "disconnesso") || !socket.isConnected() || socket.isClosed()){
                    socket.close();
                    lobby.exit();
                    break;
                }
                lobby.treatMsg(nPlayer,msg);
            }
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }

    public void sendMsg(String n){
        out.println(n);
    }

    private String receiveMsg() throws IOException {
        try {
            return bf.readLine();
        }catch (SocketException se){
            return "disconnesso";
        }
    }
}
