#lang racket

(require math/number-theory)

(module+ test
  (require rackunit))

(module+ main
  (displayln "Day 13"))

(define (parse-buses str)
  (map string->number (string-split str ",")))

(define (read-input filename)
  (define in (file->lines filename))
  (values (string->number (car in))
          (parse-buses (cadr in))))

(define (part1 filename)
  (define-values (t buses) (read-input filename))
  (define waits (for/list ([b (in-list buses)]
                           #:when b)
                  (list b (- b (modulo t b)))))
  (apply * (argmin cadr waits)))

(module+ test
  (check-equal? (part1 "test") 295))

(module+ main
  (displayln (part1 "input")))

(define (part2 filename)
  (define-values (t buses) (read-input filename))
  (define active-buses (for/list ([b (in-list buses)] #:when b) b))
  (define times (for/list ([b (in-list buses)] [i (in-naturals)] #:when b) (- i)))
  (solve-chinese times active-buses))

(module+ test
  (check-equal? (part2 "test") 1068781))

(module+ main
  (displayln (part2 "input")))
