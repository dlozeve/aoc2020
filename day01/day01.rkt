#lang racket

(module+ test
  (require rackunit))

(module+ main
  (displayln "Day 1"))

(define (read-input filename)
  (with-input-from-file filename
    (lambda ()
      (for/list ([line (in-lines)])
        (string->number line)))))

(define (part1 filename)
  (define expenses (read-input filename))
  (for*/last ([a (in-list expenses)]
              [b (in-list expenses)]
              #:final (= 2020 (+ a b)))
    (* a b)))

(define (part2 filename)
  (define expenses (read-input filename))
  (for*/last ([a (in-list expenses)]
              [b (in-list expenses)]
              [c (in-list expenses)]
              #:final (= 2020 (+ a b c)))
    (* a b c)))
