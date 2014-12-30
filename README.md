Xernia
======

Open world MMOCC written in Dart.

## NEVER PUT PULL REQUESTS ON MASTER UNLESS IT IS AN EMEMERGENCY FIX! ##
Always put your pull requests on a different branch. If you don't know the branch for you, ask in Issues.

## Where are the files? ##
**Server side** - dart/*
**Client side** - static/game.dart
Use dart2js to convert it over to Javascript and allow browser support.
**HTTPServer** - main.dart

## Important server side files ##
**dart/sockets/Airtower.dart**
Contains all data for incoming packets sent.
**dart/sockets/SocketHandler.dart**
Handles incoming sockets, and other related things.
