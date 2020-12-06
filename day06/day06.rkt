#lang racket

(module+ test
  (require rackunit))

(module+ main
  (displayln "Day 6"))

(define (read-input filename)
  (string-split (file->string filename) "\n\n"))

(define (count-unique str)
  (set-count (set-remove (list->set (string->list str)) #\newline)))

(define (part1 filename)
  (apply + (map count-unique (read-input filename))))

(module+ test
  (check-equal? (part1 "test") 11))

(module+ main
  (displayln (part1 "input")))

(define (count-intersection str)
  (define answers (string-split str "\n"))
  (set-count
   (apply set-intersect
          (map (compose list->set string->list) answers))))

(define (part2 filename)
  (apply + (map count-intersection (read-input filename))))

(module+ test
  (check-equal? (part2 "test") 6))

(module+ main
  (displayln (part2 "input")))
