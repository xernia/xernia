import "dart:html";

DivElement gw = querySelector("#gameWindow");

void main(){
  WebSocket ws = new WebSocket("ws://localhost:8000/ws");
  GameWindowHandler gamewindow = new GameWindowHandler();
  LayoutHandler layouthandler = new LayoutHandler(gamewindow);
  
  gamewindow.clearAndMsg("Connecting.");
  
  ws.onOpen.listen((Event e){
    gamewindow.clearAndMsg("Connected.");
    ws.sendString("load");
  });
  
  ws.onMessage.listen((MessageEvent e){
    var packet = e.data.toString().split("%");
    
    switch(packet[0]){
      case "loadsuccess":
        layouthandler.homeScreenLayout();
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
  void clear(){
    gw.innerHtml = "";
  }
  
  void clearAndMsg(String text){
    gw.innerHtml = "<h1 class='noticemsg'>$text</h1>";
  }
  
  void addElement(HtmlElement element){
    gw.append(element);
  }
}

class LayoutHandler{
  GameWindowHandler gwh;
  
  LayoutHandler(GameWindowHandler gwh){
    this.gwh = gwh;
  }
  
  void homeScreenLayout(){
    gwh.clear();
    
    DivElement homeScreen = new DivElement();
    ButtonElement play = new ButtonElement();
    ButtonElement register = new ButtonElement();
    play.setAttribute("class", "playbutton");
    play.innerHtml = "Play";
    register.setAttribute("class", "playbutton registerbutton");
    register.innerHtml = "Register";
    
    play.onClick.listen((MouseEvent e){
      this.loginScreenLayout();
    });
    
    register.onClick.listen((MouseEvent e){
      this.registerScreenLayout();
    });
    
    homeScreen.setAttribute("class", "layout center");
    homeScreen.style.setProperty("background-color", "#009AFF");
    
    homeScreen.innerHtml = "<img src='img/logo.png'>";
    homeScreen.append(play);
    homeScreen.innerHtml += "<br>";
    homeScreen.append(register);
    
    gwh.addElement(homeScreen);
    
    querySelector("[class='playbutton']").onClick.listen((MouseEvent e){
      play.click(); //hotfix
    });
    
    querySelector("[class='playbutton registerbutton']").onClick.listen((MouseEvent e){
      register.click(); //hotfix
    });
  }
  
  void loginScreenLayout(){
    gwh.clear();

    DivElement loginScreen = new DivElement();
    
    loginScreen.setAttribute("class", "layout center");
    loginScreen.style.setProperty("background-color", "#009AFF");
    
    gwh.addElement(loginScreen);
  }
  
  void registerScreenLayout(){
    gwh.clear();
    
    DivElement registerScreen = new DivElement();
    
    registerScreen.setAttribute("class", "layout center");
    registerScreen.style.setProperty("background-color", "#009AFF");
    
    gwh.addElement(registerScreen);
  }
}

class Player{
  
}