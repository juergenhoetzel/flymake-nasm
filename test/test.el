(require 'flymake)
(require 'flymake-nasm)


(defun flymake-tests--wait-for-backends ()
  (unless noninteractive (read-event "" nil 0.1))
  (cl-loop repeat 5
           for notdone = (cl-set-difference (flymake-running-backends)
                                            (flymake-reporting-backends))
           while notdone
           unless noninteractive do (read-event "" nil 0.1)
           do (sleep-for (+ 0.5 flymake-no-changes-timeout))
           finally (when notdone (ert-fail
                                  (format "Some backends not reporting yet %s"
                                          notdone)))))

(ert-deftest basic-diagnostics ()
  "Test basic syntax error."
  (with-current-buffer
      (find-file-noselect "test/hello.asm")
    (setq flymake-diagnostic-functions '(flymake-nasm-backend t))
    (let ((flymake-start-on-flymake-mode nil))
      (unless flymake-mode (flymake-mode 1)))
    (flymake-start)
    (flymake-tests--wait-for-backends)
    (flymake-goto-next-error)
    (should (eq (line-number-at-pos) 13))
    (should (eq 'flymake-error (face-at-point)))))
