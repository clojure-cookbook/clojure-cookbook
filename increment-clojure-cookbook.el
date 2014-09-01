(defun increment-clojure-cookbook ()
  "When reading the Clojure cookbook, find the next section, and close the buffer."
  (interactive)
  (let* ((cur (buffer-name))
         (cur-sec (substring cur 0 (1+ (string-match "-" cur))))
         (cur-chap (substring cur (1+ (string-match "-" cur)) (string-match "_" cur)))
         (cur-chap-num (string-to-number cur-chap))
         (next-chap-num (1+ cur-chap-num))
         (next-search (concat cur-sec (number-to-string next-chap-num)))
         (next-target (file-name-completion next-search "")))
    (progn 
      (find-file next-target)
      (kill-buffer cur))))
