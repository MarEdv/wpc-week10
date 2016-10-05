## Weekly Programming Challenge #10

Jamis Buck publishes programming challenges on his blog at 
https://medium.com/@jamis/. This is my submission for week 10. This time it's
all about socket programming. I solved Normal Mode, which is a simple protocol for sending a request/response between a client and a server. The message sent is simply reversed to start with.

## Build, run and test
This time I use ```stack``` for project management. Make sure ```stack``` and ```stack-run``` is installed and in your ```PATH```.

There are no tests so far :(

Build: 
```
stack build
```
Run server: 
```
stack run server <port>
```
Run client: 
```
stack run client <host> <port>
```