(in-package :cl-user)

(defpackage lambda-server.api
  (:use :cl)
  (:export :defroute
           :append-application-to-url))

(in-package :lambda-server.api)

(defun get-parameter-names (string-url-rule)
  (remove-duplicates
   (cl-ppcre:all-matches-as-strings ":[A-Za-z0-9]+" string-url-rule)
   :test #'equal))

(defmacro append-web-context-root (url)
  (let ((normalized-url (string-right-trim "/" url)))
    `(concatenate 'string "/" (symbol-value (intern (string-upcase "*web-context-root*"))) ,normalized-url)))

(defmacro defroute ((string-url-rule &rest args &key method identifier regexp &allow-other-keys) &body body)
  (let ((params (gensym))
        (parameter-names (get-parameter-names string-url-rule)))
    `(setf (ningle:route lambda-server:*server* (append-web-context-root ,string-url-rule) ,@args)
           #'(lambda (,params)
               (let ,(mapcar
                      #'(lambda (p)
                          `,(list
                             (intern (string-upcase (subseq p 1) ))
                             `(cdr (assoc ,(intern (string-upcase (subseq p 1)) :keyword) ,params))))
                      parameter-names)
                 ,@body)))))
