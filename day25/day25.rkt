#lang racket/base

(module+ test
  (require rackunit))

(define (modular-expt a b n)
  (if (= b 0)
      (if (= 1 n) 0 1)
      (let loop ([b b])
        (cond
          [(= b 1) (modulo a n)]
          [(even? b) (define c (loop (quotient b 2)))
                     (modulo (* c c) n)]
          [else (modulo (* a (loop (sub1 b))) n)]))))

;; https://en.wikipedia.org/wiki/Baby-step_giant-step
(define (discrete-logarithm a b n)
  (define m (inexact->exact (ceiling (sqrt n))))
  (define h (for/hash ([j (in-range m)])
              (values (modular-expt a j n) j)))
  (define t (modular-expt a (- n m 1) n))
  (let loop ([c b]
             [i 0])
    (if (hash-has-key? h c)
        (+ (hash-ref h c) (* i m))
        (loop (modulo (* c t) n) (add1 i)))))

(define (part1 public1 public2)
  (define private1 (discrete-logarithm 7 public1 20201227))
  (modular-expt public2 private1 20201227))

(module+ test
  (check-equal? (part1 5764801 17807724) 14897079))

(module+ main
  (displayln (part1 3248366 4738476)))
