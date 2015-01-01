library Load;

import "dart:io";
import "../sockets/SocketHandler.dart";

class Load{
  void onLoad(SocketHandler sh, WebSocket socket, List<String> args){
    sh.writeToSocket(socket, "loadsuccess");
  }
}