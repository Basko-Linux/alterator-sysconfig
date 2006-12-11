(document:surround "/std/frame")
(document:insert "/std/functions")

(document:envelop with-translation _ "alterator-syskbd")


(define keyboard-names `(("caps_toggle" . ,(_ "CapsLock key"))
                         ("ctrl_shift_toggle" . ,(_ "Control+Shift keys"))
                         ("ctrl_toggle" . ,(_ "Control key"))
                         ("toggle" . ,(_ "Alt key"))
                         ("default" . ,(_ "Default"))
                         ("nodeadkeys" . ,(_ "Without dead keys"))))


(define keyboards (woo-catch
                   (lambda()
                     (woo-list-names "/syskbd"))
                   (lambda(reason) '())))

(define (get-name item)
  (cond-assoc item keyboard-names item))

(define (apply-keyboard)
  (woo-catch
   (thunk
    (let ((current (keyboard-type current)))
      (and (>= current 0)
           (woo-write (string-append "/syskbd/" (list-ref keyboards current)))))
    #t)
   (lambda(reason) #f)))

;;;;;;;;;;;;

(hbox
 (spacer)
 (vbox
  max-height 200
  (label (_ "Please select keyboard switch type"))
  (document:id keyboard-type (listbox
                              layout-policy 100 -2
                              max-width 300
                              rows (map get-name keyboards)
                              (and (> (length keyboards) 0) (current 0)))))
 (spacer))

(frame:on-next apply-keyboard)

(document:root (when loaded (if (null? keyboards)
                                (if (eq? (global 'frame:direction) 'next)
                                    (frame:next)
                                    (frame:back)))))
