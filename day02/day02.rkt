#lang racket

(module+ test
  (require rackunit))

(module+ main
  (displayln "Day 2"))

(struct policy
  (lower upper char)
  #:transparent)

(define (parse-line str)
  (define lst (string-split str #px"(\\s+|:\\s+|-)"))
  (values (policy (string->number (first lst))
                  (string->number (second lst))
                  (car (string->list (third lst))))
          (last lst)))

(define (read-input filename)
  (with-input-from-file filename
    (lambda ()
      (for/lists (policies passwords)
                 ([line (in-lines)])
        (parse-line line)))))

(define (valid? pol pass)
  (define cnt (count (λ (x) (equal? x (policy-char pol)))
                     (string->list pass)))
  (and (<= (policy-lower pol) cnt)
       (>= (policy-upper pol) cnt)))

(define (part1 filename)
  (define-values (policies passwords) (read-input filename))
  (for/sum ([pol policies]
            [pass passwords]
            #:when (valid? pol pass))
    1))

(module+ test
  (check-equal? (part1 "test") 2))

(module+ main
  (displayln (part1 "input")))

(define (new-valid? pol pass)
  (xor (equal? (string-ref pass (sub1 (policy-lower pol))) (policy-char pol))
       (equal? (string-ref pass (sub1 (policy-upper pol))) (policy-char pol))))

(define (part2 filename)
  (define-values (policies passwords) (read-input filename))
  (for/sum ([pol policies]
            [pass passwords]
            #:when (new-valid? pol pass))
    1))

(module+ test
  (check-equal? (part2 "test") 1))

(module+ main
  (displayln (part2 "input")))
