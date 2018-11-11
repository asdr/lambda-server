(in-package :cl-user)

(defpackage lambda-server.util
  (:use :cl)
  (:export :return-nil
           :return-true
           :trim
           :remove-at-positions))

(in-package :lambda-server.util)

(defun return-nil (&rest arguments)
  nil)

(defun return-true (&rest arguments)
  t)

(defun trim (string)
  (string-trim '(#\Space #\Tab) string))

(defun remove-at-positions (lpositions l)
  ;; (format t "postions: ~a~%" lpositions)
  (let ((index 0)
        (len (length l))
        (lreverse (reverse l))
        lres)
    (dolist (el lreverse lres)
      (unless (member (- len index 1) lpositions)
        (push el lres))
      (incf index))))
