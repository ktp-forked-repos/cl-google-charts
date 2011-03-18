(in-package #:google-charts)

(defgeneric symbol->string (value)
  (:method ((value symbol))
    (substitute #\_ #\- (string-downcase value)))
  (:method (value)
    (string value)))

(defclass icon ()
  ((shadowp :initform nil :initarg :shadowp :accessor shadowp)
   (fill-color :initarg :fill-color :accessor fill-color)
   (text-color :initarg :text-color :accessor text-color)))

(defclass bubble (icon)
  ((icon :initform nil :initarg :icon :accessor icon)
   (text :initarg :text :accessor text) ; string for text, list for texts
   (bigp :initform nil :initarg :bigp :accessor bigp)
   (frame-style :initarg :frame-style :accessor frame-style)))

(defmethod get-parameters append ((chart bubble))
  `(("chst" . ,(format nil
                       "d_bubble~:[~;_icon~]_text~:[~;s~]_~:[small~;big~]~:[~;_withshadow~]"
                       (icon chart)
                       (listp (text chart))
                       (or (listp (text chart))
                           (and (icon chart) (bigp chart)))
                       (shadowp chart)))
    ("chld" . ,(format nil "~@[~a|~]~a|~@[~a|~]~a|~a~{|~a~}"
                       (when (icon chart) (symbol->string (icon chart)))
                       (frame-style chart)
                       (when (stringp (text chart)) (text chart))
                       (fill-color chart)
                       (text-color chart)
                       (when (listp (text chart)) (text chart))))))

(defclass pin (icon)
  ;; character for text, symbol for icon
  ((content :initarg :content :accessor content)
   (style :initform nil :initarg :style :accessor style)
   (star-fill-color :initform nil :initarg :star-fill-color
                    :accessor star-fill-color)))

(defmethod get-parameters append ((chart pin))
  `(("chst" . ,(format nil
                       "d_map_~:[~;x~]pin_~:[letter~;icon~]~:[~;_withshadow~]"
                       (style chart)
                       (symbolp (content chart))
                       (shadowp chart)))
    ("chld" . ,(format nil "~@[pin_~a|~]~a|~a~@[|~a~]~@[|~a~]"
                       (when (style chart) (symbol->string (style chart)))
                       (symbol->string (content chart))
                       (fill-color chart)
                       (when (characterp (content chart)) (text-color chart))
                       (when (eq (style chart) :star)
                         (star-fill-color chart))))))
