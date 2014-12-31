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
    
    Player player = new Player("", new RGB(100, 100, 100), 10, 100);
    RegisterTextAI registertextai = new RegisterTextAI(player);
    SliderAI sliderai = new SliderAI(player);
    
    DivElement registerScreen = new DivElement();
    DivElement redSlider = new DivElement();
    DivElement greenSlider = new DivElement();
    DivElement blueSlider = new DivElement();
    DivElement playerElement = player.getElement(register: true);
    
    InputElement username = new InputElement();
    InputElement password = new InputElement();
    
    username.setAttribute("class", "registername");
    username.setAttribute("id", "username");
    username.setAttribute("type", "text");
    username.setAttribute("maxlength", "20");
    
    password.setAttribute("class", "registername");
    password.setAttribute("id", "password");
    password.setAttribute("type", "password");
    
    redSlider.setAttribute("id", "redslider");
    greenSlider.setAttribute("id", "greenslider");
    blueSlider.setAttribute("id", "blueslider");
    
    registerScreen.setAttribute("class", "layout center");
    registerScreen.style.setProperty("background-color", "#009AFF");
    
    registerScreen.append(playerElement);
    registerScreen.append(redSlider);
    registerScreen.append(greenSlider);
    registerScreen.append(blueSlider);
    registerScreen.append(username);
    registerScreen.append(password);
    gwh.addElement(registerScreen);
    
    js.context.callMethod("\$", ["#username"]).callMethod("change", [new js.JsFunction.withThis(new CallbackFunction(registertextai.usernameChange))]);
    
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
  //for us
  PlayerMath playermath = new PlayerMath();
  DivElement player;
  SpanElement nameElement;
  bool showcase, register;
  
  String name;
  RGB rgb;
  num x, y;
  
  Player(String name, RGB rgb, num x, num y){
    this.name = name;
    this.rgb = rgb;
    this.x = x;
    this.y = y;
  }
  
  void setStyles(DivElement player, SpanElement nameElement, bool showcase, bool register){
    player.setAttribute("class", "player"+((showcase) ? " showcase" : "")+((register) ? " register": ""));
    player.style.setProperty("background-color", "rgb("+rgb.toString()+")");
    player.style.setProperty("left", x.toString()+"px");
    player.style.setProperty("top", y.toString()+"px");
    
    nameElement.setAttribute("class", "name"+((showcase) ? " showcase" : "")+((register) ? " register": ""));
    nameElement.style.setProperty("left", playermath.getLeftFromElement(player).toString()+"px");
    nameElement.style.setProperty("top", playermath.getTopFromElement(player).toString()+"px");
    nameElement.text = this.name;
  }
  
  void setXY(num x, num y){
    this.x = x;
    this.y = y;
    this.setStyles(player, nameElement, showcase, register);
  }
  
  void setName(String name){
    this.name = name;
    this.setStyles(player, nameElement, showcase, register);
  }
  
  void setRGB(RGB rgb){
    this.rgb = rgb;
    this.setStyles(player, nameElement, showcase, register);
  }
  
  DivElement getElement({showcase: false, register: false}){
    DivElement body = new DivElement();
    DivElement player = new DivElement();
    SpanElement nameElement = new SpanElement();
    
    this.setStyles(player, nameElement, showcase, register);
    
    body.append(player);
    body.append(nameElement);
    
    this.showcase = showcase;
    this.register = register;
    this.player = player;
    this.nameElement = nameElement;
    
    return body;
  }
  
  String getName(){
    return this.name;
  }
  
  RGB getRGB(){
    return this.rgb;
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

class RegisterTextAI{
  Player p;
  
  RegisterTextAI(Player p){
    this.p = p;
  }
  
  Player getPlayer(){
    return this.p;
  }
  
  void usernameChange(InputElement input, js.JsObject arg){
    print(input.value);
    this.p.setName(input.value);
  }
}

class SliderAI{
  Player p;
  
  SliderAI(Player p){
    this.p = p;
  }
  
  Player getPlayer(){
    return this.p;
  }
  
  void slide(String type, int value){
    RGB rgb = p.getRGB();
    
    switch(type){
      case "red":
        rgb.setRed(value);
        this.p.setRGB(rgb);
        break;
      case "blue":
        rgb.setBlue(value);
        this.p.setRGB(rgb);
        break;
      case "green":
        rgb.setGreen(value);
        this.p.setRGB(rgb);
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

class PlayerMath{
  num getTopFromElement(DivElement player){
    num height;
    
    if(player.getAttribute("class") == "player showcase")
      height = 200;
    else if(player.getAttribute("class") == "player register")
      return 710;
    else
      height = 50;
    
    return num.parse(player.style.getPropertyValue("top").substring(0, 2)) + height;
  }
  
  num getLeftFromElement(DivElement player){
    if(player.getAttribute("class") == "player showcase")
      return num.parse(player.style.getPropertyValue("left").substring(0, 3)) + 65;
    else if(player.getAttribute("class") == "player register")
      return 260;
    else
      return num.parse(player.style.getPropertyValue("left").substring(0, 3));
  }
}