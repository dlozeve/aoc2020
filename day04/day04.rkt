#lang racket

(module+ test
  (require rackunit))

(module+ main
  (displayln "Day 4"))

(define (parse-passport str)
  (define fields (string-split str #px"\\s+"))
  (for/hash ([f fields])
    (apply values (string-split f ":"))))

(define (read-input filename)
  (define passports-str (string-split (file->string filename) "\n\n"))
  (map parse-passport passports-str))

(define (valid? passport)
  (for/and ([key '("byr" "iyr" "eyr" "hgt" "hcl" "ecl" "pid")])
    (hash-has-key? passport key)))

(define (part1 filename)
  (define passports (read-input filename))
  (length (filter valid? passports)))

(module+ test
  (check-equal? (part1 "test") 2))

(module+ main
  (displayln (part1 "input")))
