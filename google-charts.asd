(defpackage google-charts.system
  (:use #:cl #:asdf))

(in-package #:google-charts.system)

(defsystem google-charts
  :depends-on (drakma puri)
  :serial t
  :components ((:file "package")
               (:file "icons")
               (:file "charts")
               (:file "miscellany")
               (:file "api")))
