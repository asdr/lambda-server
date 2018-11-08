(in-package :cl-user)

(defpackage lambda-server.util
  (:use :cl)
  (:export :return-nil
           :return-true))

(in-package :lambda-server.util)

(defun return-nil (&rest arguments)
  nil)

(defun return-true (&rest arguments)
  t)
