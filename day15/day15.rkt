#lang racket

(module+ test
  (require rackunit))

(define (run-game input idx)
  (define h (make-hash))
  (for ([n (in-list (drop-right input 1))]
        [i (in-naturals)])
    (hash-set! h n (add1 i)))
  (for/fold ([n (last input)])
            ([i (in-range (length input) idx)])
    (define res (- i (hash-ref h n i)))
    (hash-set! h n i)
    res))

(module+ test
  (check-equal? (run-game '(0 3 6) 2020) 436)
  (check-equal? (run-game '(1 3 2) 2020) 1)
  (check-equal? (run-game '(2 1 3) 2020) 10)
  (check-equal? (run-game '(1 2 3) 2020) 27)
  (check-equal? (run-game '(2 3 1) 2020) 78)
  (check-equal? (run-game '(3 2 1) 2020) 438)
  (check-equal? (run-game '(3 1 2) 2020) 1836))

(module+ main
  (displayln (run-game '(14 1 17 0 3 20) 2020)))

(module+ test
  (check-equal? (run-game '(0 3 6) 30000000) 175594)
  (check-equal? (run-game '(1 3 2) 30000000) 2578)
  (check-equal? (run-game '(2 1 3) 30000000) 3544142)
  (check-equal? (run-game '(1 2 3) 30000000) 261214)
  (check-equal? (run-game '(2 3 1) 30000000) 6895259)
  (check-equal? (run-game '(3 2 1) 30000000) 18)
  (check-equal? (run-game '(3 1 2) 30000000) 362))

(module+ main
  (displayln (run-game '(14 1 17 0 3 20) 30000000)))
