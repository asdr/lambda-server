(in-package :cl-user)
(defpackage lambda-server.container
  (:use :cl :lambda-server.util)
  (:export :load-application
           :load-all-applications))

(in-package :lambda-server.container)

(defparameter *applications* nil)

(defun load-application (application-path)
  (progn
    (let* ((name (car (last (pathname-directory application-path))))
           (asd-path (merge-pathnames application-path (concatenate 'string name ".asd"))))
      (handler-case
          (when (cl-fad:file-exists-p asd-path)
            (asdf:load-asd asd-path)
            (ql:quickload (make-symbol name))
            (format t "Application ~a is successfully loaded.~%~%" name)
            t)
        (error (c)
          (format t "~a~%~%" c)
          nil)))))

(defun load-all-applications ()
  (let ((application-directory-list (cl-fad:list-directory lambda-server.config:*applications-path*)))
    (dolist (application-directory application-directory-list)
      (let ((application-path (cl-fad:directory-pathname-p application-directory)))
        (when application-path
          (load-application application-path))))
    t))
