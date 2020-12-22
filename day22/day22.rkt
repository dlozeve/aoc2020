#lang racket

(module+ test
  (require rackunit))

(define (read-input filename)
  (apply values
         (map (λ (s) (map string->number (cdr (string-split s "\n"))))
              (string-split (file->string filename) "\n\n"))))

(define (play p1 p2)
  (match (list p1 p2)
    [(list xs '()) (list xs '())]
    [(list '() ys) (list '() ys)]
    [(list (list-rest x xs) (list-rest y ys))
     (if (< x y)
         (play xs (append ys (list y x)))
         (play (append xs (list x y)) ys))]))

(define (play-recursive deck1 deck2)
  (define states (mutable-set))
  (let loop ([p1 deck1]
             [p2 deck2])
    (let/cc return
      (when (set-member? states (list p1 p2)) (return (list p1 '())))
      (set-add! states (list p1 p2))
      (match (list p1 p2)
        [(list xs '()) (list xs '())]
        [(list '() ys) (list '() ys)]
        [(list (list-rest x xs) (list-rest y ys))
         (if (and (<= x (length xs)) (<= y (length ys)))
             (if (empty? (cadr (play-recursive (take xs x) (take ys y))))
                 (loop (append xs (list x y)) ys)
                 (loop xs (append ys (list y x))))
             (if (> x y)
                 (loop (append xs (list x y)) ys)
                 (loop xs (append ys (list y x)))))]))))

(define (winning-score play-fn deck1 deck2)
  (define final-deck (apply append (play-fn deck1 deck2)))
  (for/sum ([x (in-list (reverse final-deck))]
            [i (in-naturals 1)])
    (* x i)))

(define (part1 filename)
  (define-values (deck1 deck2) (read-input filename))
  (winning-score play deck1 deck2))

(define (part2 filename)
  (define-values (deck1 deck2) (read-input filename))
  (winning-score play-recursive deck1 deck2))

(module+ test
  (check-equal? (part1 "test") 306)
  (check-equal? (part2 "test") 291))

(module+ main
  (displayln (part1 "input"))
  (displayln (part2 "input")))
