(in-package :cl-user)

(defpackage lambda-server.config
  (:use :cl)
  (:export :*server-root-path*
           :*configuration-path*
           :*applications-path*
           :*library-path*
           :*templates-path*))

(in-package :lambda-server.config)

(defparameter *server-root-path* (merge-pathnames "lambda-server/" (user-homedir-pathname)))
(defparameter *configuration-path* (merge-pathnames "config/" *server-root-path*))
(defparameter *applications-path* (merge-pathnames "applications/" *server-root-path*))
(defparameter *library-path* (merge-pathnames "lib/" *server-root-path*))
(defparameter *templates-path* (merge-pathnames "templates/" *server-root-path*))
