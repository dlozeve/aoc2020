#lang racket

(module+ test
  (require rackunit))

(module+ main
  (displayln "Day 5"))

(define (seat-id str)
  (define binary-str (list->string
                      (for/list ([c (in-string str)])
                        (if (or (equal? c #\B) (equal? c #\R))
                            #\1
                            #\0))))
  (string->number binary-str 2))

(define (read-input filename)
  (define seats (file->lines filename))
  (map seat-id seats))

(module+ test
  (for ([seat '("FBFBBFFRLR" "BFFFBBFRRR" "FFFBBBFRRR" "BBFFBBFRLL")]
        [expected-id '(357 567 119 820)])
    (check-equal? (seat-id seat) expected-id)))

(define (part1 filename)
  (apply max (read-input filename)))

(module+ main
  (displayln (part1 "input")))

(define (part2 filename)
  (define ids (read-input filename))
  (define id-range (range (apply min ids) (apply max ids)))
  (set-first (set-subtract (list->set id-range) (list->set ids))))

(module+ main
  (displayln (part2 "input")))
