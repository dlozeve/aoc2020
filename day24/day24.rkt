#lang racket

(module+ test
  (require rackunit))

(define (read-input filename)
  (map string->tile (file->lines filename)))

(define (string->tile str)
  (path->tile (map string->symbol (regexp-match* #rx"(e|w|se|sw|ne|nw)" str))))

(define (path->tile path)
  (define-values (q r)
    (for/fold ([q 0]
               [r 0])
              ([s (in-list path)])
      (match s
        ['e (values (add1 q) r)]
        ['ne (values (add1 q) (sub1 r))]
        ['nw (values q (sub1 r))]
        ['w (values (sub1 q) r)]
        ['sw (values (sub1 q) (add1 r))]
        ['se (values q (add1 r))])))
  (list q r))

(define (initial-grid tiles)
  (define grid (make-hash))
  (for ([tile (in-list tiles)])
    (hash-update! grid tile not #f))
  grid)

(define (count-alive grid)
  (for/sum ([(k v) (in-hash grid)]
            #:when v)
    1))

(define (part1 filename)
  (define tiles (read-input filename))
  (count-alive (initial-grid tiles)))

(module+ test
  (check-equal? (part1 "test") 10))

(module+ main
  (displayln (part1 "input")))

(define (count-alive-neighbours grid tile)
  (define q (car tile))
  (define r (cadr tile))
  (for*/sum ([i (in-range -1 2)]
             [j (in-range -1 2)]
             #:unless (= 0 i j)
             #:unless (= 2 (abs (+ i j)))
             #:when (hash-ref grid (list (+ q i) (+ r j)) #f))
    1))

(define (step grid)
  (define size (+ 2 (apply max (flatten (hash-keys grid)))))
  (for*/hash ([q (in-range (- size) size)]
              [r (in-range (- size) size)])
    (define color (hash-ref grid (list q r) #f))
    (define n (count-alive-neighbours grid (list q r)))
    (values (list q r)
            (cond
              [(and color (or (= 0 n) (> n 2))) #f]
              [(and (not color) (= 2 n)) #t]
              [else color]))))

(define (part2 filename)
  (define tiles (read-input filename))
  (count-alive
   (for/fold ([grid (initial-grid tiles)])
             ([i (in-range 100)])
     (step grid))))

(module+ test
  (check-equal? (part2 "test") 2208))

(module+ main
  (displayln (part2 "input")))
