(in-package :cl-user)

;; configure for debug
(eval-when (:compile-toplevel :load-toplevel :execute)
  (declaim (optimize (debug 3))))


(defpackage lambda-server
  (:use :cl)
  (:export :start :stop))

(in-package :lambda-server)

(defparameter *server-handler* nil)

(defun root-handler ()
  "<h2>This is the root.</h2>")

(defun 404-handler ()
  "<h2>404 - Not Found</h2>")

(defvar *server* (make-instance 'ningle:app))

(defun start ()
  (unless *server-handler*
    (setf *server-handler*
          (clack:clackup
           *server*
           :server :woo
           :worker-num 4))))

(defun stop ()
  (let ((is-stopped (when *server-handler*
                      (clack:stop *server-handler*))))
    (when is-stopped
      (setf *server-handler* nil))))
