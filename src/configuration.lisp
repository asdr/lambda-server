(in-package :cl-user)

(defpackage lambda-server.config
  (:use :cl)
  (:import-from :lambda-server.util
                :trim)
  (:export :*server-root-path*
           :*configuration-path*
           :*applications-path*
           :*library-path*
           :*templates-path*
           :load-configuration-file
           :get-parameter))

(in-package :lambda-server.config)

(defvar +root-folder-name+ "lambda-server/")
(defvar +configuration-folder-name+ "config/")
(defvar +applications-folder-name+ "applications/")
(defvar +libraries-folder-name+ "lib/")
(defvar +templates-folder-name+ "templates/")
(defvar +config-filename+ "server.properties")

(defparameter *server-root-path* (merge-pathnames +root-folder-name+ (user-homedir-pathname)))
(defparameter *configuration-path* (merge-pathnames +configuration-folder-name+ *server-root-path*))
(defparameter *applications-path* (merge-pathnames +applications-folder-name+ *server-root-path*))
(defparameter *library-path* (merge-pathnames +libraries-folder-name+ *server-root-path*))
(defparameter *templates-path* (merge-pathnames +templates-folder-name+ *server-root-path*))

;; Configuration values
(defparameter *config-params* (make-hash-table :test 'equal))

(defun load-configuration-line (line)
  (destructuring-bind (key-dirty value-dirty)
      (cl-ppcre:split "\\s*=\\s*" line :limit 2)
    (let ((key (trim key-dirty))
          (value (trim value-dirty)))
      (setf (gethash key *config-params*) value))))

(defun load-configuration-file ()
  (let ((config-file-path (merge-pathnames +config-filename+ *configuration-path*)))
    (with-open-file (stream config-file-path)
      (do ((line (read-line stream nil)
                 (read-line stream nil)))
          ((null line))
        (load-configuration-line line)))))

(defun get-parameter (name)
  (when name
    (gethash name *config-params*)))
