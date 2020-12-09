#lang racket

(module+ test
  (require rackunit))

(module+ main
  (displayln "Day 9"))

(define (read-input filename)
  (list->vector (map string->number (file->lines filename))))

(define (initial-state p m)
  (reverse (for/list ([x (in-vector p 0 m)])
             (for/list ([y (in-vector p 0 m)]
                        #:unless (= x y))
               (+ x y)))))

(define (update-state s p k)
  (define m (length (car s)))
  (define new-sums (for/list ([x (in-vector p (- k m) k)])
                     (+ x (vector-ref p k))))
  (append (cdr s) (list new-sums)))

(define (in-state? s x)
  (member x (flatten s)))

;; The initial state is computed in O(m^2), and the search itself is
;; only O(nm), where n is the length of the input, because updating
;; the state is linear in m. So the overall complexity is O(m^2 + nm)
;; instead of O(nm^2) for the naïve solution.
(define (find-invalid-number p m)
  (define-values (s x)
    (for/fold ([s (initial-state p m)]
               [x (vector-ref p m)])
              ([k (in-naturals m)]
               #:break (not (in-state? s x)))
      (values (update-state s p k)
              (vector-ref p k))))
  x)

(define (part1 filename m)
  (find-invalid-number (read-input filename) m))

(module+ test
  (check-equal? (part1 "test" 5) 127))

(module+ main
  (displayln (part1 "input" 25)))

(define (part2 filename m)
  (define p (read-input filename))
  (define n (vector-length p))
  (define invalid (find-invalid-number p m))
  (for*/last ([width (in-range 2 n)]
              [i (in-range 0 (- n width))])
    (define contiguous (vector->list (vector-copy p i (+ i width))))
    #:final (= invalid (apply + contiguous))
    (+ (apply min contiguous)
       (apply max contiguous))))

(module+ test
  (check-equal? (part2 "test" 5) 62))

(module+ main
  (displayln (part2 "input" 25)))
