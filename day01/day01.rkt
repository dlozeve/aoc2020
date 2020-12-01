#lang racket

(module+ test
  (require rackunit))

(module+ main
  (displayln "Day 1"))

(define (read-input filename)
  (map string->number (file->lines filename)))

(define (part1 filename)
  (define expenses (read-input filename))
  (for*/last ([a (in-list expenses)]
              [b (in-list expenses)]
              #:final (= 2020 (+ a b)))
    (* a b)))

(module+ test
  (check-eq? (part1 "test") 514579))

(module+ main
  (displayln (part1 "input")))

(define (part2 filename)
  (define expenses (read-input filename))
  (for*/last ([a (in-list expenses)]
              [b (in-list expenses)]
              [c (in-list expenses)]
              #:final (= 2020 (+ a b c)))
    (* a b c)))

(module+ test
  (check-eq? (part2 "test") 241861950))

(module+ main
  (displayln (part2 "input")))
