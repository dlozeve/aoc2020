#lang racket

(module+ test
  (require rackunit))

(module+ main
  (displayln "Day 11"))

(define (read-input filename)
  (with-input-from-file filename
    (lambda ()
      (for/hash ([line (in-lines)]
                 [i (in-naturals)]
                 #:when #t
                 [c (in-list (string->list line))]
                 [j (in-naturals)]
                 #:when (equal? c #\L))
        (values (list i j) 'empty)))))

(define (update-seat state x y)
  (define neighbours (for*/sum ([i '(-1 0 1)]
                                [j '(-1 0 1)]
                                #:unless (= 0 i j))
                       (if (eq? 'occupied (hash-ref state (list (+ x i) (+ y j)) 'floor)) 1 0)))
  (define s (hash-ref state (list x y)))
  (cond
    [(and (eq? s 'empty) (= neighbours 0)) 'occupied]
    [(and (eq? s 'occupied) (>= neighbours 4)) 'empty]
    [else s]))

(define (part1 filename)
  (define input (read-input filename))
  (define-values (prev final)
    (for/fold ([prev-state (hash)]
               [state input])
              ([i (in-naturals)]
               #:break (equal? prev-state state))
      (values state (for/hash ([(pos v) (in-hash state)])
                      (values pos (update-seat state (car pos) (cadr pos)))))))
  (length (filter (λ (s) (eq? s 'occupied)) (hash-values final))))

(module+ test
  (check-equal? (part1 "test") 37))

(module+ main
  (displayln (part1 "input")))
