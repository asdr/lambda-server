#|
  This file is a part of lambda-server project.
|#

(defsystem "lambda-server"
  :version "0.1.0"
  :author "Serdar Gokcen"
  :license "BSD-3"
  :depends-on (:cl-ppcre
               :cl-fad
               :quicklisp
               :clack
               :ningle
               :woo)
  :components ((:module "src"
                        :components ((:file "util")
                                     (:file "configuration")
                                     (:file "api")
                                     (:file "lambda-server")
                                     (:file "container"))))
  :description "Application Server for Common Lisp Applications"
  :long-description  #.(read-file-string
                        (subpathname *load-pathname* "README.markdown"))
  :in-order-to ((test-op (test-op "lambda-server-test"))))
