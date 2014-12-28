import "dart:html";

var gw = querySelector("#gameWindow");

void main(){
  WebSocket ws = new WebSocket("ws://localhost:8000/ws");
  GameWindowHandler gamewindow = new GameWindowHandler();
  gamewindow.clearAndMsg("Connecting.");
  
  ws.onOpen.listen((Event e){
    gamewindow.clearAndMsg("Connected.");
    ws.sendString("load");
  });
  
  ws.onMessage.listen((MessageEvent e){
    var packet = e.data.toString().split("%");
    
    switch(packet[0]){
      case "loadsuccess":
        gamewindow.clearAndMsg("Got OK from server. Loading assets...");
        break;
      default:
        print("Unknown packet received: "+packet);
    }
  });
  
  ws.onClose.listen((CloseEvent e){
    gamewindow.clearAndMsg("Lost connection.");
  });
}

class GameWindowHandler{
  void clearAndMsg(text){
    gw.innerHtml = "<h1 class='noticemsg'>$text</h1>";
  }
}