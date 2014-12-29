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
  RGB rgb;
  num x, y;
  
  Player(RGB rgb, num x, num y){
    this.rgb = rgb;
    this.x = x;
    this.y = y;
  }
  
  void setXY(num x, num y){
    this.x = x;
    this.y = y;
  }
  
  void setRGB(rgb){
    this.rgb = rgb;
  }
  
  DivElement getElement(){
    DivElement player = new DivElement();
    
    player.setAttribute("class", "player");
    player.style.setProperty("background-color", "rgb("+rgb.toString()+")");
    player.style.setProperty("left", x.toString()+"px");
    player.style.setProperty("top", y.toString()+"px");
    
    return player;
  }
  
  RGB getRGB(){
    return rgb;
  }
  
  num getX(){
    return this.x;
  }
  
  num getY(){
    return this.y;
  }
}

class RGB{
  num r, g, b;
  
  RGB(num r, num g, num b){
    this.r = r;
    this.g = g;
    this.b = b;
  }
  
  void reset(num r, num g, num b){
    this.r = r;
    this.g = g;
    this.b = b;
  }
  
  @override
  String toString(){
    return r.toString() + ", " + g.toString() + ", " + b.toString();
  }
  
  void setRed(num r){
    this.r = r;
  }
  
  void setGreen(num g){
    this.g = g;
  }
  
  void setBlue(num b){
    this.b = b;
  }
  
  num getRed(){
    return this.r;
  }
  
  num getBlue(){
    return this.b;
  }
  
  num getGreen(){
    return this.g;
  }
}
