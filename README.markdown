# Lambda-Server

lambda-serve is a common lisp application server. It aims to separate server application login/code. Separate applications, which are located under $SERVER_ROOT/applications folder, will be loaded to server and published to their own context-roots.

Sample application can be found as a separate repository, lambda-server-console.

## Installation & Usage

* Open terminal
* Go into the root directory of the project
* Run common lisp compiler (e.g. sbcl)
* Run (asdf:load-asd "lambda-server.asd")
* Run (ql:quickload :lambda-server)
* Run (lambda-server:start)

Server will be started on port 5000.
