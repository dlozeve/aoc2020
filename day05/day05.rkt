#lang racket

(module+ test
  (require rackunit))

(module+ main
  (displayln "Day 5"))

(define (parse-seat str)
  (define-values (row col) (split-at (string->list str) 7))
  ;;  #t means upper half
  (list (map (λ (c) (equal? c #\B)) row)
        (map (λ (c) (equal? c #\R)) col)))

(define (read-input filename)
  (define seats-str (file->lines filename))
  (map parse-seat seats-str))

(define (binary-space-decode lst lower upper)
  (define midpoint (+ lower (/ (- upper lower) 2)))
  (if (null? (cdr lst))
      (if (car lst) upper lower)
      (if (car lst)
          (binary-space-decode (cdr lst) (ceiling midpoint) upper)
          (binary-space-decode (cdr lst) lower (floor midpoint)))))

(define (seat-id row col)
  (+ (* 8 row) col))

(module+ test
  (for ([seat '("FBFBBFFRLR" "BFFFBBFRRR" "FFFBBBFRRR" "BBFFBBFRLL")]
        [expected-row '(44 70 14 102)]
        [expected-col '(5 7 7 4)]
        [expected-id '(357 567 119 820)])
    (test-case seat
      (let ([row (binary-space-decode (car (parse-seat seat)) 0 127)]
            [col (binary-space-decode (cadr (parse-seat seat)) 0 7)])
        (check-equal? row expected-row)
        (check-equal? col expected-col)
        (check-equal? (seat-id row col) expected-id)))))

(define (part1 filename)
  (define seats (read-input filename))
  (apply max (for/list ([seat seats])
               (seat-id (binary-space-decode (car seat) 0 127)
                        (binary-space-decode (cadr seat) 0 7)))))

(module+ main
  (displayln (part1 "input")))

(define max-seat (seat-id 127 7))
(define min-seat (seat-id 0 0))

(define (part2 filename)
  (define seats (read-input filename))
  (define ids (for/list ([seat seats])
                (seat-id (binary-space-decode (car seat) 0 127)
                         (binary-space-decode (cadr seat) 0 7))))
  (define id-range (range (apply min ids) (apply max ids)))
  (set-first (set-subtract (list->set id-range) (list->set ids))))

(module+ main
  (displayln (part2 "input")))
