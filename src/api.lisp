(in-package :cl-user)

(defpackage lambda-server.api
  (:use :cl)
  (:shadowing-import-from :ningle/app
                          :*request*
                          :*response*
                          :*session*
                          :*context*)
  (:import-from :lambda-server.util :remove-at-positions)
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

(defun add-response-header (name value)
  (setf (lack.response:response-headers *response*)
        (append (lack.response:response-headers *response*)
                (list (intern-symbol name :keyword t) value))))

(defun set-response-header (name value)
  (let ((pos (position (intern-symbol name :keyword t) (lack.response:response-headers *response*))))
    (let ((headers (lack.response:response-headers *response*)))
      (when pos
        (setf headers
              (remove-at-positions `(,pos ,(1+ pos)) headers)))
      (setf (lack.response:response-headers *response*)
            (append headers
                    (list (intern-symbol name :keyword t) value))))))

(defun get-header (name)
  (gethash name (lack.request:request-headers *request*)))

(defun get-request-env ()
  (lack.request:request-env *request*))

(defun get-request-uri ()
  (lack.request:request-uri *request*))

(defun get-request-method ()
  (lack.request:request-method *request*))

(defun get-request-content ()
  (lack.request:request-content *request*))

(defun get-request-cookies ()
  (lack.request:request-cookies *request*))

(defun get-request-raw-body ()
  (lack.request:request-raw-body *request*))

(defun get-request-path-info ()
  (lack.request:request-path-info *request*))

(defun get-request-parameters ()
  (lack.request:request-parameters *request*))

(defun get-request-uri-scheme ()
  (lack.request:request-uri-scheme *request*))

(defun get-request-remote-addr ()
  (lack.request:request-remote-addr *request*))

(defun get-request-remote-port ()
  (lack.request:request-remote-port *request*))

(defun get-request-script-name ()
  (lack.request:request-script-name *request*))

(defun get-request-server-name ()
  (lack.request:request-server-name *request*))

(defun get-request-server-port ()
  (lack.request:request-server-port *request*))

(defun get-request-content-type ()
  (lack.request:request-content-type *request*))

(defun get-request-query-string ()
  (lack.request:request-query-string *request*))

(defun get-request-content-length ()
  (lack.request:request-content-length *request*))

(defun get-request-body-parameters ()
  (lack.request:request-body-parameters *request*))

(defun get-request-server-protocol ()
  (lack.request:request-server-protocol *request*))

(defun get-request-query-parameters ()
  (lack.request:request-query-parameters *request*))

(defmacro append-web-context-root (url)
  (let ((normalized-url (string-right-trim "/" url)))
    `(concatenate 'string "/" (symbol-value (intern-symbol "*web-context-root*")) ,normalized-url)))

(defmacro defroute ((string-url-rule &rest args &key method identifier regexp &allow-other-keys) &body body)
  (let ((gparams (gensym))
        (parameter-names (get-parameter-names string-url-rule)))
    `(setf (ningle:route lambda-server:*server* (append-web-context-root ,string-url-rule) ,@args)
           #'(lambda (,gparams)
               (flet ((,(intern-symbol "add-response-header") (n v) (funcall #'add-response-header n v))
                      (,(intern-symbol "set-response-header") (n v) (funcall #'set-response-header n v))
                      (,(intern-symbol "get-header") (n) (funcall #'get-header n))
                      (,(intern-symbol "get-env") () (funcall #'get-request-env))
                      (,(intern-symbol "get-uri") () (funcall #'get-request-uri))
                      (,(intern-symbol "get-method") () (funcall #'get-request-method))
                      (,(intern-symbol "get-content") () (funcall #'get-request-content))
                      (,(intern-symbol "get-cookies") () (funcall #'get-request-cookies))
                      (,(intern-symbol "get-raw-body") () (funcall #'get-request-raw-body))
                      (,(intern-symbol "get-path-info") () (funcall #'get-request-path-info))
                      (,(intern-symbol "get-parameters") () (funcall #'get-request-parameters))
                      (,(intern-symbol "get-uri-scheme") () (funcall #'get-request-uri-scheme))
                      (,(intern-symbol "get-remote-addr") () (funcall #'get-request-remote-addr))
                      (,(intern-symbol "get-remote-port") () (funcall #'get-request-remote-port))
                      (,(intern-symbol "get-script-name") () (funcall #'get-request-script-name))
                      (,(intern-symbol "get-server-name") () (funcall #'get-request-server-name))
                      (,(intern-symbol "get-server-port") () (funcall #'get-request-server-port))
                      (,(intern-symbol "get-content-type") () (funcall #'get-request-content-type))
                      (,(intern-symbol "get-query-string") () (funcall #'get-request-query-string))
                      (,(intern-symbol "get-content-length") () (funcall #'get-request-content-length))
                      (,(intern-symbol "get-body-parameters") () (funcall #'get-request-body-parameters))
                      (,(intern-symbol "get-server-protocol") () (funcall #'get-request-server-protocol))
                      (,(intern-symbol "get-query-parameters") () (funcall #'get-request-query-parameters)))
                 (let ((,(intern-symbol "wildcard-parameters") (cdr (assoc :splat ,gparams)))
                       (,(intern-symbol "regexp-parameters") (cdr (assoc :captures ,gparams)))
                       ,@(mapcar
                          #'(lambda (p)
                              `,(list
                                 (intern-symbol (subseq p 1))
                                 `(cdr (assoc ,(intern-symbol (subseq p 1) :keyword t) ,gparams))))
                          parameter-names))
                   (declare (ignorable ,(intern-symbol "wildcard-parameters")
                                       ,(intern-symbol "regexp-parameters")
                                       ,@(when parameter-names
                                           (mapcar
                                            #'(lambda (p)
                                                (intern-symbol (subseq p 1)))
                                            parameter-names))))
                   ,@body))))))
