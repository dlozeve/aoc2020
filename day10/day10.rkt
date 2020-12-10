#lang racket

(module+ test
  (require rackunit))

(module+ main
  (displayln "Day 10"))

(define (read-input filename)
  (define input (map string->number (file->lines filename)))
  (sort (cons 0 (cons (target input) input)) <))

(define (target lst)
  (+ 3 (apply max lst)))

(define (part1 filename)
  (define jolts (read-input filename))
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

(define (count-paths jolts)
  (define counts (make-hash))
  (hash-set! counts 0 1)
  (for ([x (in-list (cdr jolts))])
    (hash-set! counts x (+ (hash-ref counts (- x 1) 0)
                           (hash-ref counts (- x 2) 0)
                           (hash-ref counts (- x 3) 0))))
  (hash-ref counts (last jolts)))

(define (part2 filename)
  (define jolts (read-input filename))
  (count-paths jolts))

(module+ test
  (check-equal? (part2 "test1") 8)
  (check-equal? (part2 "test2") 19208))

(module+ main
  (displayln (part2 "input")))
