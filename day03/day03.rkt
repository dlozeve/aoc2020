#lang racket

(module+ test
  (require rackunit))

(module+ main
  (displayln "Day 3"))

(define (parse-line str)
  (list->vector
   (map (λ (c) (if (equal? c #\#) 1 0)) (string->list str))))

(define (read-input filename)
  (with-input-from-file filename
    (lambda ()
      (for/vector ([line (in-lines)])
        (parse-line line)))))

(define (traj grid down right)
  (define height (vector-length grid))
  (define width (vector-length (vector-ref grid 0)))
  (for/list ([line (in-vector grid 0 #f down)]
             [j (in-range 0 (* width height right) right)])
    (vector-ref line (remainder j width))))

(define (part1 filename)
  (define grid (read-input filename))
  (apply + (traj grid 1 3)))

(module+ test
  (check-equal? (part1 "test") 7))

(module+ main
  (displayln (part1 "input")))

(define slopes
  '((1 1)
    (1 3)
    (1 5)
    (1 7)
    (2 1)))

(define (part2 filename)
  (define grid (read-input filename))
  (for/product ([slope slopes])
    (apply + (traj grid (car slope) (cadr slope)))))

(module+ test
  (check-equal? (part2 "test") 336))

(module+ main
  (displayln (part2 "input")))
