#lang racket

(module+ test
  (require rackunit))

(define (read-input filename)
  (apply values
         (map (λ (s) (map string->number (cdr (string-split s "\n"))))
              (string-split (file->string filename) "\n\n"))))

(define (play p1 p2)
  (match (list p1 p2)
    [(list x '()) x]
    [(list '() x) x]
    [(list (list-rest a x) (list-rest b y))
     (if (< a b)
         (play x (append y (list b a)))
         (play (append x (list a b)) y))]))

(define (part1 filename)
  (define-values (p1 p2)  (read-input filename))
  (define final-deck (play p1 p2))
  (for/sum ([x (in-list (reverse final-deck))]
            [i (in-naturals 1)])
    (* x i)))

(module+ test
  (check-equal? (part1 "test") 306))

(module+ main
  (displayln (part1 "input")))

