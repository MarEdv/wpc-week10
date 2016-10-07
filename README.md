## Weekly Programming Challenge #10

Jamis Buck publishes programming challenges on his blog at 
http://jamis.jamisbuck.org/2016/10/1/weekly-programming-challenge-10.html. This is my submission for week 10. This time it's
all about socket programming.

This time I use ```stack``` for project management. Make sure ```stack``` and ```stack-run``` is installed and in your ```PATH```.

There are no tests so far, since I did not find a good way to test the socket part of program (probably because I only told Google that I felt lucky).

### Normal Mode
I solved Normal Mode, which is a simple protocol for sending a request/response between a client and a server. The message sent is simply reversed to start with.

#### Build, run and test
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

### Hard Mode
I also wrote a very simple HTTP client able to send GET requests using HTTP version 1.0. It lists the status line, the headers and the contents like this:

```
Status line: HTTP/1.0 200 OK

Headers
Header1: value1
Header2: value2

Contents
======================================
The contents of the response!
======================================
```

#### Build, run and test
Build: 
```
stack build
```
Run server: 
```
stack run http-client <method> <host> <port> <path>
  method: GET
  host: simply the hostname, e.g., www.google.com
  port: the port, e.g., 80
  path: path to the resource, e.g., /index.html
```

### Lessons learned
- I struggled with ways of reading binary data and transforming between String and BinaryString, and between Int and Word32.
- Using ```stack``` is quite nice, even though the difference from pure cabal was not that apparent.
- Practiced working with the IO Monad.
- Experimented with handling command line arguments.