#lang racket

(module+ test
  (require rackunit))

(module+ main
  (displayln "Day 11"))

(define (matrix-ref mat i j default)
  (define n (vector-length mat))
  (define m (vector-length (vector-ref mat 0)))
  (if (or (< i 0) (<= n i) (< j 0) (<= m j))
      default
      (vector-ref (vector-ref mat i) j)))

(define (matrix-set! mat i j v)
  (vector-set! (vector-ref mat i) j v))

(define (matrix-copy mat)
  (for/vector ([l (in-vector mat)])
    (vector-copy l)))

(define (display-state state)
  (for ([l (in-vector state)])
    (displayln (list->string (vector->list l))))
  (displayln ""))

(define (parse-line str)
  (list->vector (string->list str)))

(define (read-input filename)
  (with-input-from-file filename
    (lambda ()
      (for/vector ([line (in-lines)])
        (parse-line line)))))

(define (update-seat-neighbours state x y)
  (define neighbours (for*/sum ([i '(-1 0 1)]
                                [j '(-1 0 1)]
                                #:unless (= 0 i j))
                       (if (eq? #\# (matrix-ref state (+ x i) (+ y j) #\.)) 1 0)))
  (define s (matrix-ref state x y #\.))
  (cond
    [(and (eq? s #\L) (= neighbours 0)) #\#]
    [(and (eq? s #\#) (>= neighbours 4)) #\L]
    [else s]))

(define (update-state state update-seat-fn)
  (define n (vector-length state))
  (define m (vector-length (vector-ref state 0)))
  (define new-state (matrix-copy state))
  (for* ([x (in-range n)]
         [y (in-range m)])
    (matrix-set! new-state x y (update-seat-fn state x y)))
  new-state)

(define (count-occupied state)
  (for*/sum ([l (in-vector state)]
             [v (in-vector l)]
             #:when (eq? v #\#))
    1))

(define (part1 filename)
  (define input (read-input filename))
  (define n (vector-length input))
  (define m (vector-length (vector-ref input 0)))
  (define-values (prev final)
    (for/fold ([prev-state 0]
               [state input])
              ([i (in-naturals)]
               #:break (equal? prev-state state))
      (define new-state (update-state state update-seat-neighbours))
      (values state new-state)))
  (count-occupied final))

(module+ test
  (check-equal? (part1 "test") 37))

(module+ main
  (displayln (part1 "input")))

(define (visible state x y dx dy)
  (define n (vector-length state))
  (define m (vector-length (vector-ref state 0)))
  (let loop ([u (+ x dx)]
             [v (+ y dy)])
    (cond
      [(or (< u 0) (< v 0) (<= n u) (<= m v)) 0]
      [(eq? #\L (matrix-ref state u v #\.)) 0]
      [(eq? #\# (matrix-ref state u v #\.)) 1]
      [else (loop (+ u dx) (+ v dy))])))

(define (update-seat-visible state x y)
  (define n-visible (apply + (for*/list ([dx '(-1 0 1)]
                                         [dy '(-1 0 1)]
                                         #:unless (= 0 dx dy))
                               (visible state x y dx dy))))
  (define s (matrix-ref state x y #\.))
  (cond
    [(and (eq? s #\L) (= n-visible 0)) #\#]
    [(and (eq? s #\#) (>= n-visible 5)) #\L]
    [else s]))

(define (part2 filename)
  (define input (read-input filename))
  (define-values (prev final)
    (for/fold ([prev-state 0]
               [state input])
              ([i (in-naturals)]
               #:break (equal? prev-state state))
      (define new-state (update-state state update-seat-visible))
      (values state new-state)))
  (count-occupied final))

(module+ test
  (check-equal? (part2 "test") 26))

(module+ main
  (displayln (part2 "input")))
