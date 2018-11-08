#|
  This file is a part of lambda-server project.
|#

(defsystem "lambda-server-test"
  :defsystem-depends-on ("prove-asdf")
  :author ""
  :license ""
  :depends-on ("lambda-server"
               "prove")
  :components ((:module "tests"
                        :components ((:test-file "lambda-server"))))
  :description "Test system for lambda-server"
  :perform (test-op (op c) (symbol-call :prove-asdf :run-test-system c)))
