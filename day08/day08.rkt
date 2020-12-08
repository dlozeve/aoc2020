#lang racket

(module+ test
  (require rackunit))

(module+ main
  (displayln "Day 8"))

(define (parse-instruction str)
  (define instr (string-split str))
  (cons (string->symbol (car instr))
        (map string->number (cdr instr))))

(define (read-input filename)
  (list->vector (map parse-instruction (file->lines filename))))

(define (run-until-loop program)
  (define n (vector-length program))
  (let loop ([acc 0]
             [i 0]
             [visited '()])
    (if (member i visited)
        acc
        (match (vector-ref program i)
          [(list 'nop x) (loop acc (add1 i) (cons i visited))]
          [(list 'acc x) (loop (+ acc x) (add1 i) (cons i visited))]
          [(list 'jmp x) (loop acc (+ i x) (cons i visited))]
          [instr (error "invalid instruction" i instr)]))))

(define (part1 filename)
  (define program (read-input filename))
  (run-until-loop program))

(module+ test
  (check-equal? (part1 "test") 5))

(module+ main
  (displayln (part1 "input")))
