#lang racket

(module+ test
  (require rackunit))

(module+ main
  (displayln "Day 5"))

(define (parse-seat str)
  (let* ([str (string-replace str "B" "1")]
         [str (string-replace str "F" "0")]
         [str (string-replace str "R" "1")]
         [str (string-replace str "L" "0")]
         [row (substring str 0 7)]
         [col (substring str 7 10)])
    (list (string->number row 2) (string->number col 2))))

(define (read-input filename)
  (define seats-str (file->lines filename))
  (map parse-seat seats-str))

(define (seat-id seat)
  (+ (* 8 (car seat)) (cadr seat)))

(module+ test
  (for ([seat-str '("FBFBBFFRLR" "BFFFBBFRRR" "FFFBBBFRRR" "BBFFBBFRLL")]
        [expected-row '(44 70 14 102)]
        [expected-col '(5 7 7 4)]
        [expected-id '(357 567 119 820)])
    (test-case seat-str
      (let ([seat (parse-seat seat-str)])
        (check-equal? (car seat)  expected-row)
        (check-equal? (cadr seat) expected-col)
        (check-equal? (seat-id seat) expected-id)))))

(define (part1 filename)
  (define seats (read-input filename))
  (apply max (map seat-id seats)))

(module+ main
  (displayln (part1 "input")))

(define (part2 filename)
  (define seats (read-input filename))
  (define ids (map seat-id seats))
  (define id-range (range (apply min ids) (apply max ids)))
  (set-first (set-subtract (list->set id-range) (list->set ids))))

(module+ main
  (displayln (part2 "input")))
