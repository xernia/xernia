import "dart:io";
import "dart/sockets/SocketHandler.dart";

void main() {
  HttpServer.bind(InternetAddress.LOOPBACK_IP_V4, 8000).then((HttpServer server){
    print("Listening on localhost on "+server.port.toString());
    
    server.listen((HttpRequest request){
      var uri = request.uri.toString();
      
      if(request.uri.path == "/ws"){
        WebSocketTransformer.upgrade(request).then(new SocketHandler().handleSocket);
      }else if(uri == "/"){
          request.response.headers.contentType = ContentType.HTML;
          
          new File("static/taskbar.html").readAsString().then((String contents){
            request.response.write(contents);
            
            new File("static/index.html").readAsString().then((String contents){
              request.response.write(contents);
              request.response.close();
            });
          });
      }else if(uri == "/play"){
        request.response.headers.contentType = ContentType.HTML;
        
        new File("static/taskbar.html").readAsString().then((String contents){
          request.response.write(contents);
          
          new File("static/game.html").readAsString().then((String contents){
            request.response.write(contents);
            request.response.close();
          });
        });
      }else if(new RegExp("/packages/(.*)").hasMatch(uri)){
        new File(uri.substring(1)).exists().then((bool exists){
          if(!exists) return;
            new File(uri.substring(1)).readAsString().then((String contents){
              if(uri.substring(uri.length - 3, uri.length) == "css")
                request.response.headers.contentType = new ContentType("text", "css", charset: "utf-8");
              else{
                if(uri.substring(uri.length - 2, uri.length) == "js")
                 request.response.headers.contentType = new ContentType("application", "javascript", charset: "utf-8");
              };
              
              request.response.write(contents);
              request.response.close();
          });
        });
      }else if(new RegExp("/css/(.*)").hasMatch(uri)){
        new File("static/" + uri.substring(1)).exists().then((bool exists){
          if(!exists) return;
            new File("static/" + uri.substring(1)).readAsString().then((String contents){
              request.response.headers.contentType = new ContentType("text", "css", charset: "utf-8");
              request.response.write(contents);
              request.response.close();
          });
        });
      }else if(new RegExp("/dart/(.*)").hasMatch(uri)){
        new File("static/" + uri.substring(1)).exists().then((bool exists){
          if(!exists) return;
            new File("static/" + uri.substring(1)).readAsString().then((String contents){
              if(uri.substring(uri.length - 2, uri.length) == "js")
                request.response.headers.contentType = new ContentType("application", "javascript", charset: "utf-8");
              else
                request.response.headers.contentType = new ContentType("application", "dart");
              
              request.response.write(contents);
              request.response.close();
          });
        });
      }else if(new RegExp("/img/(.*)").hasMatch(uri)){
        new File("static/" + uri.substring(1)).exists().then((bool exists){
          if(!exists) return;
            new File("static/" + uri.substring(1)).readAsBytes().then((List<int> contents){
              request.response.headers.contentType = new ContentType("image", "png");
              request.response.add(contents);
              request.response.close();
          });
        });
      }else{
          request.response.statusCode = HttpStatus.NOT_FOUND;
          request.response.write("404 Not Found.");
          request.response.close();
      }
    });
  });
}