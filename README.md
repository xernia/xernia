Xernia
======

Open world MMOCC written in Dart.

## NEVER PUT PULL REQUESTS ON MASTER UNLESS IT IS AN EMEMERGENCY FIX! ##
Always put your pull requests on a different branch. If you don't know the branch for you, ask in Issues.

## Where are the files? ##
**Server side** - dart/* <br>
**Client side** - static/game.dart <br>
Use dart2js to convert it over to Javascript and allow browser support. <br>
**HTTPServer** - main.dart

## Important server side files ##
**dart/sockets/Airtower.dart** <br>
Contains all data for incoming packets sent. <br>
**dart/sockets/SocketHandler.dart** <br>
Handles incoming sockets, and other related things.
