#lang racket

(module+ test
  (require rackunit))

(define (part1 input)
  (define h (make-hash))
  (for ([n (in-list (drop-right input 1))]
        [i (in-naturals)])
    (hash-set! h n i))
  (for/fold ([n (last input)])
            ([i (in-range (length input) 2020)])
    (define res (if (hash-has-key? h n)
                    (- (sub1 i) (hash-ref h n))
                    0))
    (hash-set! h n (sub1 i))
    res))

(module+ test
  (check-equal? (part1 '(0 3 6)) 436)
  (check-equal? (part1 '(1 3 2)) 1)
  (check-equal? (part1 '(2 1 3)) 10)
  (check-equal? (part1 '(1 2 3)) 27)
  (check-equal? (part1 '(2 3 1)) 78)
  (check-equal? (part1 '(3 2 1)) 438)
  (check-equal? (part1 '(3 1 2)) 1836))

(module+ main
  (displayln (part1 '(14 1 17 0 3 20))))
