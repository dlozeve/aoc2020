#lang racket/base

(require racket/list
         racket/set)

(module+ test
  (require rackunit))

(define (read-input filename dimension)
  (with-input-from-file filename
    (lambda ()
      (for/set ([line (in-lines)]
                [i (in-naturals)]
                #:when #t
                [c (in-list (string->list line))]
                [j (in-naturals)]
                #:when (eq? c #\#))
        (append (list i j) (make-list (- dimension 2) 0))))))

(define (neighbours pos)
  (define dim (length pos))
  (define relative (remove (make-list dim 0) (apply cartesian-product (make-list dim '(-1 0 1)))))
  (map (λ (rel) (map + pos rel)) relative))

(define (lives? state pos)
  (define neighbours-count (length (filter (λ (n) (set-member? state n))
                                           (neighbours pos))))
  (define current (set-member? state pos))
  (or (and current (<= 2 neighbours-count 3))
      (and (not current) (= 3 neighbours-count))))

(define (step state)
  (define dim (length (set-first state)))
  (define indexes (flatten (set->list state)))
  (define min-index (sub1 (apply min indexes)))
  (define max-index (+ 2 (apply max indexes)))
  (for/set ([pos (apply cartesian-product (make-list dim (range min-index max-index)))] 
            #:when (lives? state pos))
    pos))

(define (power n f)
  (apply compose (make-list n f)))

(define (part1 filename)
  (define input (read-input filename 3))
  (set-count ((power 6 step) input)))

(define (part2 filename)
  (define input (read-input filename 4))
  (set-count ((power 6 step) input)))

(module+ test
  (check-equal? (part1 "test") 112)
  (check-equal? (part2 "test") 848))

(module+ main
  (displayln (part1 "input"))
  (displayln (part2 "input")))
