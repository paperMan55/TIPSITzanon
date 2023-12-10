
public class Lobby {
    private int joined;
    public SocketManager[] players;
    public boolean[] ready;
    public Lobby(){
        joined = 0;
        players = new SocketManager[2];
        ready = new boolean[]{false, false};
    }

    public int join(SocketManager pl){
        players[joined] = pl;
        joined++;
        return joined - 1;
    }
    public boolean canJoin(){
        return joined<2;
    }
    private void forwardOther(int p, String msg){
        players[(p+1)%2].sendMsg(msg);
    }
    public void treatMsg(int sourceNum, String msg){
        String command = msg.substring(0,3);
        String value = msg.substring(3);
        System.out.println(" <---- "+msg+ "  from "+sourceNum);
        switch (command){
            case "RDY":  //player is ready
                ready[sourceNum] = true;
                if(ready[0]&&ready[1]){
                    players[0].sendMsg("LGO1"); //dice di partire 1, quindi inizia lui
                    players[1].sendMsg("LGO0"); //fa andare ma la prima mossa la fa l'altro
                }
                break;
            case "EXT":
                exit();
                break;
            default:
                forwardOther(sourceNum,msg);
        }
    }
    public void exit(){
        try {
            System.out.println("uscito qualcuno");
            players[0].sendMsg("EXT");
            players[1].sendMsg("EXT");
        }catch (Exception e){
            System.out.println("ops");
        }
        Server.removeLobby(this);
    }
}
