import "dart:io";
import "Airtower.dart";

List<WebSocket> allSockets = new List<WebSocket>();

class SocketHandler{
  void handleSocket(WebSocket socket){
    print("Socket connected.");
    allSockets.add(socket);
    
    var listen = socket.listen((message){
      List<String> arr = message.toString().split("%");
      
      for(String i in AirtowerData.keys){
        if(arr.length == 0) return;
        
        if(arr[0] == i){
          print("Packet received: "+message.toString()); //dont print unless its a real packet
          arr.remove(i);
          AirtowerData[i](this, socket, arr);
        }
      }
    });
    
    listen.onDone((){
      allSockets.remove(socket);
      print("Socket disconnected. Close code: "+socket.closeCode.toString());
    });
  }
  
  void writeToSocket(WebSocket socket, String msg){
    print("Packet sent: "+msg);
    socket.add(msg);
  }
  
  void broadcast(List<WebSocket> sockets, String msg){
    print("Broadcasting packet: "+msg);
    
    for(WebSocket socket in sockets){
      socket.add(msg);
    }
    
    List<WebSocket> getAllConnectedSockets(){
      return allSockets;
    }
  }
}