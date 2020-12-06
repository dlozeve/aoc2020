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
