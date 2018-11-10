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

(defun intern-symbol (name &key keyword)
  (if keyword
      (intern (string-upcase name) :keyword)
      (intern (string-upcase name))))

(defmacro append-web-context-root (url)
  (let ((normalized-url (string-right-trim "/" url)))
    `(concatenate 'string "/" (symbol-value (intern-symbol "*web-context-root*")) ,normalized-url)))

(defmacro defroute ((string-url-rule &rest args &key method identifier regexp &allow-other-keys) &body body)
  (let ((gparams (gensym))
        (parameter-names (get-parameter-names string-url-rule)))
    `(setf (ningle:route lambda-server:*server* (append-web-context-root ,string-url-rule) ,@args)
           #'(lambda (,gparams)
               (let* ,(cons
                       `(,(intern-symbol "unnamed-parameter-list") (cdr (assoc :splat ,gparams)))
                       (mapcar
                        #'(lambda (p)
                            `,(list
                               (intern-symbol (subseq p 1))
                               `(cdr (assoc ,(intern-symbol (subseq p 1) :keyword t) ,gparams))))
                        parameter-names))
                 ,(when parameter-names
                    `(declare (ignorable ,@(mapcar
                                            #'(lambda (p)
                                                (intern-symbol (subseq p 1)))
                                            parameter-names))))
                 ,@body)))))
