import "dart:js" as js;

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
    
    Player player = new Player(new RGB(100, 100, 100), 10, 100);
    SliderAI sliderai = new SliderAI(player);
    
    DivElement registerScreen = new DivElement();
    DivElement redSlider = new DivElement();
    DivElement greenSlider = new DivElement();
    DivElement blueSlider = new DivElement();
    DivElement playerElement = player.getElement(register: true);
    
    redSlider.setAttribute("id", "redslider");
    greenSlider.setAttribute("id", "greenslider");
    blueSlider.setAttribute("id", "blueslider");
    
    registerScreen.setAttribute("class", "layout center");
    registerScreen.style.setProperty("background-color", "#009AFF");
    
    registerScreen.append(playerElement);
    registerScreen.append(redSlider);
    registerScreen.append(greenSlider);
    registerScreen.append(blueSlider);
    gwh.addElement(registerScreen);
    
    js.context.callMethod("\$", ["#redslider"]).callMethod('slider', [new js.JsObject.jsify({
      "range": "max",
      "min": 0,
      "max": 255,
      "value": 100,
      "slide": new js.JsFunction.withThis(new CallbackFunction(sliderai.slideRed))
    })]);
    
    js.context.callMethod("\$", ["#greenslider"]).callMethod('slider', [new js.JsObject.jsify({
      "range": "max",
      "min": 0,
      "max": 255,
      "value": 100,
      "slide": new js.JsFunction.withThis(new CallbackFunction(sliderai.slideGreen))
    })]);

    js.context.callMethod("\$", ["#blueslider"]).callMethod('slider', [new js.JsObject.jsify({
      "range": "max",
      "min": 0,
      "max": 255,
      "value": 100,
      "slide": new js.JsFunction.withThis(new CallbackFunction(sliderai.slideBlue))
    })]);
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
  
  DivElement getElement({showcase: false, register: false}){
    DivElement player = new DivElement();
    
    player.setAttribute("class", "player"+((showcase) ? " showcase" : "")+((register) ? " register": ""));
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

class CallbackFunction implements Function{
  final Function f;
  
  CallbackFunction(this.f);
  
  call() => throw new StateError("There should always be at least 1 parameter");
  
  noSuchMethod(Invocation invocation){
    Function.apply(f, invocation.positionalArguments);
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

class SliderAI{
  Player p;
  
  SliderAI(Player p){
    this.p = p;
  }
  
  void slide(String type, int value){
    RGB rgb = p.getRGB();
    
    switch(type){
      case "red":
        rgb.setRed(value);
        p.setRGB(rgb);
        break;
      case "blue":
        rgb.setBlue(value);
        p.setRGB(rgb);
        break;
      case "green":
        rgb.setGreen(value);
        p.setRGB(rgb);
        break;
    }
    
    querySelector("[class='player register']").style.setProperty("background-color", "rgb("+rgb.toString()+")");
  }
  
  void slideRed(DivElement div, js.JsObject event, js.JsObject ui){
    slide("red", ui['value']);
  }
  
  void slideBlue(DivElement div, js.JsObject event, js.JsObject ui){
    slide("blue", ui['value']);
  }
  
  void slideGreen(DivElement div, js.JsObject event, js.JsObject ui){
    slide("green", ui['value']);
  }
}
