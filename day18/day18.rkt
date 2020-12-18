#lang racket

(module+ test
  (require rackunit))

(define (read-input filename)
  (with-input-from-file filename
    (lambda ()
      (for/list ([line (in-lines)])
        (parse-expression line)))))

(define (parse-expression str)
  (read (open-input-string (string-append "(" str ")"))))

(define (eval-left lst)
  (match lst
    [(? number? x) x]
    [(list x) x]
    [(list-rest a '+ b r)
     (eval-left (cons (+ (eval-left a) (eval-left b)) r))]
    [(list-rest a '* b r)
     (eval-left (cons (* (eval-left a) (eval-left b)) r))]))

(define (part1 filename)
  (define input (read-input filename))
  (apply + (map eval-left input)))

(module+ test
  (check-equal? (eval-left (parse-expression "1 + 2 * 3 + 4 * 5 + 6")) 71)
  (check-equal? (eval-left (parse-expression "1 + (2 * 3) + (4 * (5 + 6))")) 51)
  (check-equal? (eval-left (parse-expression "2 * 3 + (4 * 5)")) 26)
  (check-equal? (eval-left (parse-expression "5 + (8 * 3 + 9 + 3 * 4 * 3)")) 437)
  (check-equal? (eval-left (parse-expression "5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))")) 12240)
  (check-equal? (eval-left (parse-expression "((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2")) 13632))

(module+ main
  (displayln (part1 "input")))

(define (eval-left-priority lst)
  (match lst
    [(? number? x) x]
    [(list x) x]
    [(list-rest a '* b '+ c r)
     (eval-left-priority (list* a '* (+ (eval-left-priority b) (eval-left-priority c)) r))]
    [(list-rest a '+ b r)
     (eval-left-priority (cons (+ (eval-left-priority a) (eval-left-priority b)) r))]
    [(list-rest a '* b r)
     (eval-left-priority (cons (* (eval-left-priority a) (eval-left-priority b)) r))]))

(module+ test
  (check-equal? (eval-left-priority (parse-expression "1 + 2 * 3 + 4 * 5 + 6")) 231)
  (check-equal? (eval-left-priority (parse-expression "1 + (2 * 3) + (4 * (5 + 6))")) 51)
  (check-equal? (eval-left-priority (parse-expression "2 * 3 + (4 * 5)")) 46)
  (check-equal? (eval-left-priority (parse-expression "5 + (8 * 3 + 9 + 3 * 4 * 3)")) 1445)
  (check-equal? (eval-left-priority (parse-expression "5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))")) 669060)
  (check-equal? (eval-left-priority (parse-expression "((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2")) 23340))

(define (part2 filename)
  (define input (read-input filename))
  (apply + (map eval-left-priority input)))

(module+ main
  (displayln (part2 "input")))
