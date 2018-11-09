(in-package :cl-user)

(defpackage lambda-server.api
  (:use :cl)
  (:export :route))

(in-package :lambda-server.api)

(defun get-parameter-names (string-url-rule)
  (remove-duplicates
   (cl-ppcre:all-matches-as-strings ":[A-Za-z0-9]+" string-url-rule)
   :test #'equal))

(defmacro route ((string-url-rule &rest args &key method identifier regexp &allow-other-keys) &body body)
  (let ((params (gensym))
        (parameter-names (get-parameter-names string-url-rule)))
    `(setf (ningle:route lambda-server:*server* ,string-url-rule ,@args)
           #'(lambda (,params)
               (let ,(mapcar
                      #'(lambda (p)
                          `,(list
                             (intern (string-upcase (subseq p 1) ))
                             `(cdr (assoc ,(intern (string-upcase (subseq p 1)) :keyword) ,params))))
                      parameter-names)
                 ,@body)))))


;;; Example
#|

(lambda-server.api:route ("/hello/:name")
(format nil "<h2>Welcome ~a!</h2>" name))

|#
