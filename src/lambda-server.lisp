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

(defparameter *route-map* `(("/" . ,'root-handler)))

(defun request-handler (env)
  (let ((content-type (getf env :content-type))
        (path (getf env :path-info))
        (method (getf env :request-method)))
    (progn
      (unless content-type
        (setf content-type "text/html; charset=utf-8"))
      (let ((handler (assoc path *route-map* :test #'string=)))
        (if handler
            `(200 (:content-type ,content-type) ,(list (funcall (cdr handler))))
            `(404 (:content-type ,content-type) ,(list (funcall #'404-handler))))))))


(defun start ()
  (unless *server-handler*
    (setf *server-handler*
          (clack:clackup
           'request-handler
           :server :woo
           :worker-num 4))))

(defun stop ()
  (let ((is-stopped (when *server-handler*
                      (clack:stop *server-handler*))))
    (when is-stopped
      (setf *server-handler* nil))))
