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

(define (rule->regexp rules rule-idx)
  (define (rule->str idx)
    (match (hash-ref rules idx)
      [(list (regexp #rx"\"(.)\"" (list _ x))) x]
      [(list x ... "|" y ...)
       (string-append "("
                      (apply string-append
                             (map (compose rule->str string->number) x))
                      "|"
                      (apply string-append
                             (map (compose rule->str string->number) y))
                      ")")]
      [(list x ...) (apply string-append
                           (map (compose rule->str string->number) x))]))
  (regexp (rule->str rule-idx)))

(define (part1 filename)
  (define-values (rules messages) (read-input filename))
  (define rule0 (rule->regexp rules 0))
  (length (for/list ([msg (in-list messages)]
                     #:when (regexp-match-exact? rule0 msg))
            msg)))

(module+ test
  (check-equal? (part1 "test") 2))

(module+ main
  (displayln (part1 "input")))

