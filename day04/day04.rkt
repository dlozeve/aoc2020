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

(define (byr-valid? v)
  (<= 1920 (string->number v) 2002))

(module+ test
  (check-pred byr-valid? "2002")
  (check-pred (negate byr-valid?) "2003"))

(define (iyr-valid? v)
  (<= 2010 (string->number v) 2020))

(define (eyr-valid? v)
  (<= 2020 (string->number v) 2030))

(define (hgt-valid? v)
  (cond
    [(string-suffix? v "cm") (<= 150 (string->number (string-trim v "cm")) 193)]
    [(string-suffix? v "in") (<= 59 (string->number (string-trim v "in")) 76)]
    [else #f]))

(module+ test
  (check-pred hgt-valid? "60in")
  (check-pred hgt-valid? "190cm")
  (check-pred (negate hgt-valid?) "190in")
  (check-pred (negate hgt-valid?) "190"))

(define (hcl-valid? v)
  (regexp-match-exact? #px"#[0-9a-f]{6}" v))

(module+ test
  (check-pred hcl-valid? "#123abc")
  (check-pred (negate hcl-valid?) "#123abz")
  (check-pred (negate hcl-valid?) "123abc"))

(define (ecl-valid? v)
  (member v '("amb" "blu" "brn" "gry" "grn" "hzl" "oth")))

(module+ test
  (check-pred ecl-valid? "brn")
  (check-pred (negate ecl-valid?) "wat"))

(define (pid-valid? v)
  (regexp-match-exact? #px"[0-9]{9}" v))

(module+ test
  (check-pred pid-valid? "000000001")
  (check-pred (negate pid-valid?) "0123456789"))

(define (strict-valid? passport)
  (and (for/and ([key '("byr" "iyr" "eyr" "hgt" "hcl" "ecl" "pid")])
         (hash-has-key? passport key))
       (byr-valid? (hash-ref passport "byr"))
       (iyr-valid? (hash-ref passport "iyr"))
       (eyr-valid? (hash-ref passport "eyr"))
       (hgt-valid? (hash-ref passport "hgt"))
       (hcl-valid? (hash-ref passport "hcl"))
       (ecl-valid? (hash-ref passport "ecl"))
       (pid-valid? (hash-ref passport "pid"))))

(define (part2 filename)
  (define passports (read-input filename))
  (length (filter strict-valid? passports)))

(module+ test
  (check-equal? (part2 "valid") 4)
  (check-equal? (part2 "invalid") 0))

(module+ main
  (displayln (part2 "input")))
