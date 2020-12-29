#lang racket

(module+ test
  (require rackunit))

(define (labelling->cups num)
  (define cups (make-vector 10 0))
  (define start (quotient num 100000000))
  (let loop ([prev start]
             [n num])
    (define-values (q r) (quotient/remainder n 10))
    (vector-set! cups r prev)
    (if (= q 0)
        (values cups start)
        (loop r q))))

(define (cups->labelling cups)
  (let loop ([idx (vector-ref cups 1)]
             [num 0])
    (if (= 1 idx)
        num
        (loop (vector-ref cups idx) (+ (* 10 num) idx)))))

(define (move! cups current)
  (define picked-up (let loop ([idxs (list (vector-ref cups current))]
                               [i 0])
                      (if (>= i 2)
                          idxs
                          (loop (cons (vector-ref cups (car idxs)) idxs) (add1 i)))))
  (define destination (let loop ([d (sub1 current)])
                        (if (or (= 0 d) (member d picked-up))
                            (loop (modulo (sub1 d) (vector-length cups)))
                            d)))
  (vector-set! cups current (vector-ref cups (car picked-up)))
  (vector-set! cups (car picked-up) (vector-ref cups destination))
  (vector-set! cups destination (last picked-up))
  (vector-ref cups current))

(define (play! cups start steps)
  (for/fold ([current start])
            ([i (in-range steps)])
    (move! cups current)))

(define (part1 input steps)
  (define-values (cups start) (labelling->cups input))
  (play! cups start steps)
  (cups->labelling cups))

(module+ test
  (check-equal? (part1 389125467 10) 92658374)
  (check-equal? (part1 389125467 100) 67384529))

(module+ main
  (displayln (part1 198753462 100)))

(define (part2 input)
  (define-values (base-cups start) (labelling->cups input))
  (define cups (make-vector 1000001 0))
  (vector-copy! cups 0 base-cups)
  (vector-set! cups (remainder input 10) 10)
  (for ([i (in-range 10 1000000)])
    (vector-set! cups i (add1 i)))
  (vector-set! cups 1000000 start)
  (play! cups start 10000000)
  (* (vector-ref cups 1) (vector-ref cups (vector-ref cups 1))))

(module+ test
  (check-equal? (part2 389125467) 149245887792))

(module+ main
  (displayln (part2 198753462)))
