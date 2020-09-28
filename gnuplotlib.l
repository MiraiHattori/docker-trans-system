;;;
;;;    gnuplotlib.l

(list "$Id$")

(defclass gnuplot
  :super propertied-object
  :slots (strm data data-length last-command debug)
  )

(defmethod gnuplot
  (:init (host &key (clear t) ((:debug _debug)))
	 (setq strm 
	       (cond
		((string= (unix:gethostname) host)
		 (piped-fork "gnuplot"))
		(t
		 (piped-fork
		  "rsh" host
		  (format nil "(setenv DISPLAY ~A:0 ; cd ~A ; gnuplot)"
			  (unix:gethostname) (pwd)))
		 )
		))
	 (setq data-length 10)
	 (if clear (send self :clear))
         (setq debug _debug)
	 self)
  (:clear
   ()
   #-:cygwin
   (if (fboundp 'x::query-window-title-list)
       (let ((bef (x::query-window-title-list)) aft dif)
         (format strm "clear~%")
         (while (not dif)
           (setq aft (x::query-window-title-list))
           (setq dif (set-difference aft bef :test #'(lambda (a b) (= (cdr a) (cdr b))))))
         (setf (get self :win-id) (cdr (car dif)))
         )
     (format strm "clear~%"))
   #-:linux
   (format strm "clear~%")
   )
  (:move (x0 y0)
   (if (get self :win-id)
       (x::MoveWindow x::*Display* (get self :win-id) x0 y0)))
  (:resize
   (w h)
   (if (get self :win-id)
       (x::ResizeWindow x::*Display* (get self :win-id) w h)))
  (:flush () (x::flush x::*display*))
  ;;
  (:proc-length (&optional n) (if n (setq data-length n)) data-length)
  (:proc-clear ()
	       (setq data nil))
  (:proc-one (vs &rest args)
	     (let ()
	       (if (< (length data) (length vs))
		   (while (< (length data) (length vs))
		     (setq data (append data (list nil)))))
	       (dotimes (i (length vs))
		 (push (elt vs i) (elt data i)))
	       (dotimes (i (length vs))
		 (if (>= (length (elt data i)) data-length)
		     (setf (elt data i) (butlast (elt data i) (- (length (elt data i)) data-length)))))
	       (setq last-command (append data args))
	       (send-lexpr self :draw last-command)
	       last-command))
  ;;
  ;; (send *G* :draw #f(0 1 2 3 4 5) #f(5 4 3 2 1 0) :xrange '(0 10) :yrange '(0 10) :title '("data1" "data2"))
  (:draw (&rest vs)
	 (setq last-command vs)
         (if debug (warn ";; :draw ~S~%" vs))
	 (let (str range xrange yrange title (clear nil) (line-width 1) (direction :right) (xscale 1.0) (xoffset 0.0) (type :lines))
	   (dotimes (i (length vs))
	     (if (eq (elt vs i) :range) (setq range (elt vs (1+ i))))
	     (if (eq (elt vs i) :xrange) (setq xrange (elt vs (1+ i))))
	     (if (eq (elt vs i) :yrange) (setq yrange (elt vs (1+ i))))
	     (if (eq (elt vs i) :title) (setq title (elt vs (1+ i))))
	     (if (eq (elt vs i) :clear) (setq clear (elt vs (1+ i))))
	     (if (eq (elt vs i) :line-width) (setq line-width (elt vs (1+ i))))
	     (if (eq (elt vs i) :direction) (setq direction (elt vs (1+ i))))
	     (if (eq (elt vs i) :xscale) (setq xscale (elt vs (1+ i))))
	     (if (eq (elt vs i) :xoffset) (setq xoffset (elt vs (1+ i))))
             (if (eq (elt vs i) :type) (setq type (elt vs (1+ i))))
	     )
	   (setq vs (remove :range vs))
	   (setq vs (remove range vs :test #'equal))
	   (setq vs (remove :xrange vs))
	   (setq vs (remove xrange vs :test #'equal))
	   (setq vs (remove :yrange vs))
	   (setq vs (remove yrange vs :test #'equal))
	   (setq vs (remove :title vs))
	   (setq vs (remove title vs :test #'equal))
	   (setq vs (remove :clear vs))
	   (setq vs (remove clear vs :test #'equal))
	   (setq vs (remove :line-width vs))
	   (setq vs (remove line-width vs :test #'equal))
	   (setq vs (remove :direction vs))
	   (setq vs (remove direction vs :test #'equal))
           (setq vs (remove :xscale vs))
           (setq vs (remove xscale vs :test #'equal))
           (setq vs (remove :xoffset vs))
           (setq vs (remove xoffset vs :test #'equal))
           (setq vs (remove :type vs))
           (setq vs (remove type vs :test #'equal))
	   ;;
	   (if clear (send self :clear))
           (case type
                 (:lines ;; default
                  (format strm "plot ")
                  (if (setq range (or range xrange))
                      (format strm "[~A:~A]" (first range) (second range))
                    (format strm "[]"))
                  (if yrange (format strm "[~A:~A]" (first yrange) (second yrange)))
                  (format strm " '-'")
                  (if title (format strm " title \"~A\"" (pop title)))
                  (format strm " w lp lw ~A" line-width)
                  (dolist (v (cdr vs))
                    (format strm ", '-'")
                    (if title (format strm " title \"~A\"" (pop title)))
                    (format strm " w lp lw ~A" line-width)
                    )
                  (format strm "~%")	   
                  (dolist (v vs)
                    (dotimes (i (length v))
                      (if (eq direction :left)
                          (format strm "~A ~A~%" (+ (* i xscale) xoffset) (elt v (1- (- (length v) i))))
                        (format strm "~A ~A~%" (+ (* i xscale) xoffset) (elt v i))))
                    (format strm "e~%"))
                  )
                 (:2dmap
                  (format strm "set pm3d map~%")
                  (format strm "unset ztics~%")
                  (if yrange (format strm "set cbrange [~A:~A]~%" (elt yrange 0) (elt yrange 1))
                    (format strm "set autoscale cb~%"))
                  (format strm "splot '-' with pm3d~%")
                  
                  (dotimes (i (length (car vs)))
                    (dotimes (ii 2)
                      (dotimes (j (length vs))
                        (dotimes (jj 2)
                          (let ((x (+ (* (+ i ii) xscale) xoffset))
                                (y (+ j jj)) ;; 0 1 1 2 2 3 ...
                                (z (if (eq direction :left) (elt (elt vs j) (1- (- (length (car vs)) i))) (elt (elt vs j) i)))
                                )
                            (format strm "~A ~A ~A~%" x y z)
                            )))
                      (format strm "~%")
                      ))
                  
                  (format strm "e~%")
                  )
                 (t (warn "unknown type ~A~%" type))
                 )
	   ))
  ;;
  ;; (send g :plot '("file.dat" "using 1:6") :xrange '(-1 1) :yrange '(0 5))
  ;; executes as following commandline
  ;; gnuplot> plot [-1:1][0:5] "file.dat" using 1:6 with lines
  (:plot (&rest files)
         (if debug (warn ";; :plot ~S~%" files))
	 (let (range xrange yrange file style)
	   (setq last-command nil)
	   (dotimes (i (length files))
	     (if (eq (elt files i) :range) (setq range (elt files (1+ i))))
	     (if (eq (elt files i) :xrange) (setq xrange (elt files (1+ i))))
	     (if (eq (elt files i) :yrange) (setq yrange (elt files (1+ i))))
	     (if (eq (elt files i) :style) (setq style (elt files (1+ i))))
	     )
	   (setq files (delete :range files))
	   (setq files (delete range files :test #'equal))
	   (setq files (delete :xrange files))
	   (setq files (delete xrange files :test #'equal))
	   (setq files (delete :yrange files))
	   (setq files (delete yrange files :test #'equal))
	   (setq files (delete :style files))
	   (setq files (delete style files :test #'equal))
	   (unless style (setq style "lines"))
	   (format strm "plot ")
	   (if (setq range (or range xrange))
	       (format strm "[~A:~A]" (first range) (second range))
	     (format strm "[]"))
	   (if yrange (format strm "[~A:~A]" (first yrange) (second yrange)))
	   (setq file (pop files))
	   (if (stringp file)
	       (format strm " ~S with ~A" file style)
	     (when (listp file)
	       (format strm " ~S" (pop file))
	       (dolist (arg file) (format strm " ~A" arg))
	       (format strm " with ~A" style)))
	   (dolist (f files)
	     (if (stringp f)
		 (format strm ", ~S with ~A" f style)
	       (when (listp f)
		 (format strm ", ~S" (pop f))
		 (dolist (arg f) (format strm " ~A" arg))
		 (format strm " with ~A" style))))
	   (format strm "~%")))
  (:save (f &key (type "postscript eps color \"Times-Roman\" 24"))
	 (format strm "set terminal ~A~%" type)
	 (format strm "set output ~s~%" f)
	 (if last-command (send-lexpr self :draw last-command)
	   (format strm "replot~%"))
	 (format strm "set output~%")
	 (format strm "set terminal x11~%")
	 (if last-command (send-lexpr self :draw last-command)
	   (format strm "replot~%"))
	 )
  (:save-plt (f) (format strm "save ~s~%" f))
  (:replot () (format strm "replot~%"))
  (:reset () (format strm "reset~%"))
  (:command (msg) (format strm "~A~%" msg))
  (:quit () (format strm "quit~%"))
  (:debug (&optional (a :not-specified)) (if (eq a :not-specified) debug (setq debug a)))
  )

(defun gnuplot (&key (host (unix:gethostname)))
  (instance gnuplot :init host))

(defun user::gplot (&rest args)
  (let (str titles)
    (if (not (boundp '*g*)) (setq *g* (gnuplot)))
    (when (memq :title args)
      (setq titles (cadr (memq :title args)))
      (delete (cadr (memq :title args)) args)
      (delete :title args))
    ;;(print args)
    (send *g* :clear)
    (setq str (concatenate string str (format nil "plot '-' t \"~A\" w lp" (pop titles))))
    (dolist (a (cdr args))
      (setq str (concatenate string str (format nil ", '-' t \"~A\" w lp" (pop titles)))))
    (send *g* :command str)
    (dolist (a args)
      (dotimes (i (length a))
	(send *g* :command (format nil "~A ~A" i (elt a i))))
      (send *g* :command "e"))
    ;;(send *g* :command "replot")
    *g*))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; plot function for 2d or 3d plot
;; argument 
;;   ordinate-list ;; list of data for ordinate axis
;;     2D = (list (list y00 y01 ... y0n), ... (list ym0 ym1 ... ymn))
;;     3D = (list (list z00 z01 ... z0n), ... (list zm0 zm1 ... zmn))
;;   abscissa-list ;; list of data for abscissa axes
;;     2D = (list x0 x1 ... xn)
;;     3D = (list xylist0 ... xylistn) ;; xylist = (list x y)
;;   keylist ;; list of data's key
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun user::graph-view
  (ordinate-list
   &optional (abscissa-list (let ((idx -1)) (mapcar #'(lambda (x) (incf idx)) (make-list (length (car ordinate-list)))))) ;; range function
   &key (title "Graph") (xlabel "X") (ylabel "Y") (zlabel "Z")
        (dump-graph nil) (graph-fname (format nil "~A.eps" (substitute #\_ (elt " " 0) title)))
        (lt-lw-params)
	;;(mode "points")
        (mode "lines")
	keylist xrange yrange zrange
	x11 additional-func
	no-dump ((:graph-instance gp) (if (boundp 'user::*gp*) user::*gp* (setq user::*gp* (gnuplot))))
	(fname (format nil "data~A" (sys::address gp))))
  (labels ((gen-range-string
            (range)
            (if range (format nil "[~A:~A]" (car range) (cadr range)) "[]"))
           (2d-or-3d (r-2d r-3d) (if (atom (car abscissa-list)) (eval r-2d) (eval r-3d))))
    (unless keylist (setq keylist (let ((idx -1)) (mapcar #'(lambda (x) (incf idx)) (make-list (length ordinate-list))))))
    (unless lt-lw-params (setq lt-lw-params (let ((idx -1)) (mapcar #'(lambda (x) (incf idx) "") (make-list (length ordinate-list))))))
    ;; dump dat file
    (unless no-dump
      (with-open-file
       (f (format nil "/tmp/~A.dat" fname) :direction :output)
       (format f (2d-or-3d "# x vals..~%" "# x y vals..~%"))
       (dotimes (i (length abscissa-list))
         (if (atom (car abscissa-list))
             (format f "~A " (elt abscissa-list i))
           (format f "~A ~A " (elt (elt abscissa-list i) 0) (elt (elt abscissa-list i) 1)))
         ;;(dolist (d ordinate-list) (format f "~A " (elt d i)))
	 (dolist (d ordinate-list)
	   (if (< i (length d))
	       (format f "~A " (elt d i))))
         (format f "~%")
         )
       )
      )
    
    ;; plot
    (mapcar #'(lambda (d1 d2)
                (send gp :command (format nil "set ~A \"~A\"" d1 d2)))
            '(user::title user::xlabel user::ylabel user::zlabel)
            (list title xlabel ylabel zlabel))
    (if additional-func (funcall additional-func))
    (dotimes (i (length ordinate-list))
      (send gp :command
            (format nil "~A \"/tmp/~A.dat\" using ~A title \"~A\" ~A with ~A"
                    (case
                     i
                     (0 (apply #'format
                               (list nil
                                     (2d-or-3d "plot ~A ~A" "splot ~A ~A ~A")
                                     (gen-range-string xrange)
                                     (gen-range-string yrange)
                                     (2d-or-3d nil (gen-range-string zrange)))))
                     (t "replot"))
                    fname
                    (format nil "~A:~A" (2d-or-3d "1" "1:2") (+ i (2d-or-3d 2 3)))
                    (elt keylist i)
                    (elt lt-lw-params i)
                    mode))
      )
    (if x11 (send gp :command "set terminal X11"))
    (when dump-graph
      (unix:usleep 200000)
      (send gp :save graph-fname)
      (unix:usleep 200000))
    ))

#|
;; examples 
(defun test-gnuplot-0 ()
  (unless (boundp '*gp*) (setq *gp* (gnuplot)))
  (let ((leng 360))
    (send *gp* :proc-length leng)
    (mapcar #'(lambda (s-data c-data)
		(send *gp* :proc-one (float-vector s-data c-data)
		      :direction :left
		      :title (list "sin(x)" "cos(x)")))
	    (mapcar #'(lambda (x) (sin (deg2rad x))) (range leng))
	    (mapcar #'(lambda (x) (cos (deg2rad x))) (range leng)))
    t))

;; examples for graph-view
(defun test2d-plot ()
  (graph-view (list (mapcar #'(lambda (x) (sin (deg2rad x))) (range 360)))
	      (range 360)
	      :xrange '(0 360) :yrange '(-2 2)
	      :ylabel "sin(x)" :title "plot sin test")
  )

(defun all-combination (lst)
 (reduce #'(lambda (prev target)
            (if (eq prev :nil)
                (progn
                  (mapcar #'list target))
              (progn
                (let ((ret nil))
                  (dolist (ta target)
                    (dolist (p prev)
                      (push (append p (list ta)) ret))
                    )
                  ret))))
        lst :initial-value :nil))
(defun test3d-plot ()
  (let ((xy-list (all-combination (list (range 100) (range 100)))))
    (graph-view (list (gaussian-frequency-function
		       (mapcar #'(lambda (x) (concatenate float-vector x)) xy-list)))
		xy-list
		:title "plot gauss test")
    ))
|#

;;; $Log$
;;; Revision 1.25  2010-01-19 11:37:38  eus
;;; :draw :type :2dmap :yrange => 'set cbrange'
;;;
;;; Revision 1.24  2010/01/19 11:16:35  eus
;;; :draw :type :2dmap to use 'set pm3d map' because ylabel should be on the left of the graph
;;;
;;; Revision 1.23  2010/01/19 10:11:18  eus
;;; add :draw :type :2dmap
;;;
;;; Revision 1.22  2009/12/26 15:03:22  tokutsu
;;; :draw/:proc-one &key :xoffset & in :draw delete -> remove to use last-command in :save
;;;
;;; Revision 1.21  2009-12-24 07:58:04  nozawa
;;; fix count method of absicssa axis when direction == :left ;; old count method is -10 -9 ... 0 ;; new count method is 0 1 ... 10
;;;
;;; Revision 1.20  2009/11/04 08:41:14  nozawa
;;; add xscale to :draw for scaling x-axis
;;;
;;; Revision 1.19  2009/10/16 01:14:20  tokutsu
;;; in :draw setq last-command (important change for :save)
;;;
;;; Revision 1.18  2009/10/07 00:51:39  tokutsu
;;; :draw default line-width=1 for :save require line-width
;;;
;;; Revision 1.17  2008/02/20 07:00:39  tokutsu
;;; :draw &key :line-width :direction
;;;
;;; Revision 1.16  2007/10/30 09:25:49  namiki
;;; add :style key to method :plot
;;;
;;; Revision 1.15  2007/09/21 05:59:30  kojima
;;; add move,resize,flush methods and chane :clear for linux
;;;
;;; Revision 1.14  2007/08/01 10:00:04  namiki
;;; add :save-plt :replot :reset
;;;
;;; Revision 1.13  2007/07/07 14:06:57  eus
;;; bugfix in :save
;;;
;;; Revision 1.12  2006/09/04 03:24:04  k-okada
;;; remove :clear in :draw
;;;
;;; Revision 1.11  2006/07/27 08:06:36  ogura
;;; *** empty log message ***
;;;
;;; Revision 1.10  2005/11/21 01:29:52  tokutsu
;;; modified :proc-one
;;;
;;; Revision 1.9  2005/07/26 07:52:36  k-okada
;;; fix x::gplot -> user::gplot
;;;
;;; Revision 1.8  2005/07/25 14:57:29  k-okada
;;; add gplot
;;;
;;; Revision 1.7  2005/07/21 02:18:48  k-okada
;;; fix :save for :proc-one mode
;;;
;;; Revision 1.6  2005/07/21 01:24:55  eus
;;; fix :proc-clear
;;;
;;; Revision 1.5  2005/07/20 13:19:02  eus
;;; fix for linux
;;;
;;; Revision 1.4  2005/07/20 11:45:19  k-okada
;;; add draw, proc-one
;;;
;;; Revision 1.3  2004/02/03 10:35:40  ikuo
;;; - modify :plot  (enable to specify some options such as 'using 1:3')
;;; - modify :save  (idraw ==> postscript eps color etc)
;;;
;;; Revision 1.2  2001/09/15 04:15:05  ikuo
;;; add keywords to :plot (xrange, yrange)
;;;
;;; Revision 1.1.1.1  2000/03/13 10:37:01  kanehiro
;;; EusLisp library
;;;
;;; Revision 1.5  1999/09/25 13:37:26  ikuo
;;; add range
;;;
;;; Revision 1.4  1997/11/13 04:22:14  kanehiro
;;; (unix:getenv PWD)-> (pwd)
;;;
;;; Revision 1.3  1996/10/16 12:02:17  eus
;;; start logging
