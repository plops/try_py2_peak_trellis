(eval-when (:compile-toplevel :execute :load-toplevel)
  (ql:quickload "cl-py-generator"))
(in-package :cl-py-generator)

(progn
  (defparameter *path* "/home/martin/stage/try_py2_peak_trellis")
  (defparameter *code-file* "run_01_temp_converter")
  (defparameter *source* (format nil "~a/source/~a" *path* *code-file*))

  (let* ((code
	  `(do0
	    "#!/usr/bin/env python2"


	    (string3 ,(format nil "temperature converter.
Usage:
  ~a [-vh] [-c celsius] [-f fahrenheit]

Options:
  -h --help               Show this screen
  -v --verbose            Print debugging output
  -H --hidden             don't open GUI
  -c celsius              celsius [default: 0.0]
  -f fahrenheit           fahrenheit [default: None]
"
			      *code-file*))
	    
	    "# martin kielhorn 2019-02-14"
	    "# example from https://pypi.org/project/Trellis/0.7a2/"
	    "#  pip install --user Trellis==0.7a2"
	    "# https://github.com/PEAK-Legacy/Trellis"
	    "# to install from github: pip2 install --user ez_setup"
	    "# wget http://peak.telecommunity.com/snapshots/Contextual-0.7a1.dev-r2695.tar.gz http://peak.telecommunity.com/snapshots/Trellis-0.7a3-dev-r2610.tar.gz "
	    "#  pip2 install --user Contextual-0.7a1.dev-r2695.tar.gz"
	    "# i installed trellis by commenting out the contextual line in its setup.py and then extracting the egg file into ~/.local/lib/python2.7/site-packages/peak"
	    "from peak.events import trellis"

	    (imports (os
		      sys
		      docopt
		      (np numpy)
		      pathlib
		      re
		      ))
	    (imports (traceback))

	    "from peak.events import trellis"
	    (setf args (docopt.docopt __doc__ :version (string "0.0.1")))
	    (if (aref args (string "--verbose"))
		(print args))
	    
	    (class TempConverter (trellis.Component)
		   (setf F (trellis.maintain (lambda (self) (+ 32 (* 1.8 self.C)))
					     :initially 32)
			 C (trellis.maintain (lambda (self) (/ (- self.F 32) 1.8))
					     :initially 0))
		   "@trellis.perform"
		   (def show_values (self)
		     (print (dot (string "Celsius    .. {}")
				 (format self.C)))
		     (print (dot (string "Fahrenheit .. {}")
				 (format self.F)))))
	    (setf tc (TempConverter :C (float (aref args (string "-c"))))
		  tc.F 32
		  tc.C -40)
	    )))
    (write-source *source* code)))
