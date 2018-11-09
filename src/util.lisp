(in-package :cl-user)

(defpackage lambda-server.util
  (:use :cl)
  (:export :return-nil
           :return-true
           :trim))

(in-package :lambda-server.util)

(defun return-nil (&rest arguments)
  nil)

(defun return-true (&rest arguments)
  t)

(defun trim (string)
  (string-trim '(#\Space #\Tab) string))
