#lang racket

(module+ test
  (require rackunit))

(module+ main
  (displayln "Day 10"))

(define (read-input filename)
  (map string->number (file->lines filename)))

(define (device jolts)
  (+ 3 (apply max jolts)))

(define (part1 filename)
  (define input (read-input filename))
  (define jolts (sort (cons 0 (cons (device input) input)) <))
  (define counts (make-hash))
  (for ([x (in-list (drop jolts 1))]
        [y (in-list jolts)])
    (hash-update! counts (- x y) add1 0))
  (* (hash-ref counts 1 0) (hash-ref counts 3 0)))

(module+ test
  (check-equal? (part1 "test1") (* 7 5))
  (check-equal? (part1 "test2") (* 22 10)))

(module+ main
  (displayln (part1 "input")))
