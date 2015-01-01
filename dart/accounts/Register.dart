library Register;

import "dart:io";
import "../sockets/SocketHandler.dart";

class Register{
  void onRegister(SocketHandler sh, WebSocket socket, List<String> args){
    if(args.length == 5){
      var username = args[0];
      var password = args[1];
      var r = args[2];
      var g = args[3];
      var b = args[4];
      
      try{
        r = num.parse(r);
        g = num.parse(g);
        b = num.parse(b);
      }catch(e){
        sh.writeToSocket(socket, "error%Malformed RGB.");
        return;
      }
      
      
    }
  }
}