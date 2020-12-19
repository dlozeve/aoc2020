#lang racket

(module+ test
  (require rackunit))

(define (read-input filename)
  (define file-str (string-split (file->string filename) "\n\n"))
  (define rules (for/hash ([str (string-split (car file-str) "\n")])
                  (define rule (string-split str ": "))
                  (values (string->number (car rule))
                          (string-split (cadr rule)))))
  (define messages (string-split (cadr file-str) "\n"))
  (values rules messages))

(define (rule->str rules idx)
  (match (hash-ref rules idx)
    [(list (regexp #rx"\"(.)\"" (list _ x))) x]
    [(list x ... "|" y ...)
     (string-append "(?:"
                    (apply string-append
                           (map (λ (s) (rule->str rules (string->number s))) x))
                    "|"
                    (apply string-append
                           (map (λ (s) (rule->str rules (string->number s))) y))
                    ")")]
    [(list x ...) (apply string-append
                         (map (λ (s) (rule->str rules (string->number s))) x))]))

(define (part1 filename)
  (define-values (rules messages) (read-input filename))
  (define rule0 (regexp (rule->str rules 0)))
  (length (for/list ([msg (in-list messages)]
                     #:when (regexp-match-exact? rule0 msg))
            msg)))

(module+ test
  (check-equal? (part1 "test") 2))

(module+ main
  (displayln (part1 "input")))

(define (part2 filename)
  (define-values (rules messages) (read-input filename))
  ;; Rule 0 is just "8 11", rule 8 is just "(rule42)+", and rule 11
  ;; matches "(rule42)+(rule31)+" with the same repetition. Thus we
  ;; only need to check that rule 42 matches more times than rule 31.
  (define rule42 (rule->str rules 42))
  (define rule31 (rule->str rules 31))
  (define rule0 (regexp (string-append "(" rule42 ")+(" rule31 ")+")))
  (for/sum ([msg (in-list messages)]
            #:when (regexp-match-exact? rule0 msg))
    (define n31 (length
                 (regexp-match* rule31
                                (cadr (regexp-split (regexp (string-append "^(" rule42 ")+")) msg)))))
    (define n42 (length
                 (regexp-match* rule42
                                (car (regexp-split (regexp (string-append "(" rule31 ")+$")) msg)))))
    (if (> n42 n31) 1 0)))

(module+ test
  (check-equal? (part2 "test2") 12))

(module+ main
  (displayln (part2 "input")))
