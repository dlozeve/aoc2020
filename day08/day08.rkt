#lang racket/base

(require racket/string
         racket/vector
         racket/file
         racket/match)

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

(define (execute program)
  (define n (vector-length program))
  (let loop ([acc 0]
             [i 0]
             [visited '()])
    (cond
      [(member i visited) (values 'loop visited acc)]
      [(= i n) (values 'end visited acc)]
      [else (match (vector-ref program i)
              [(list 'nop x) (loop acc (add1 i) (cons i visited))]
              [(list 'acc x) (loop (+ acc x) (add1 i) (cons i visited))]
              [(list 'jmp x) (loop acc (+ i x) (cons i visited))]
              [instr (error "invalid instruction" i instr)])])))

(define (part1 filename)
  (define program (read-input filename))
  (define-values (state visited acc) (execute program))
  acc)

(module+ test
  (check-equal? (part1 "test") 5))

(module+ main
  (displayln (part1 "input")))

(define (change-instruction program visited)
  (define new-program (vector-copy program))
  (define new-visited
    (let loop ([instructions visited])
      (match (vector-ref new-program (car instructions))
        [(list 'nop x)
         (vector-set! new-program (car instructions) (list 'jmp x))
         (cdr instructions)]
        [(list 'jmp x)
         (vector-set! new-program (car instructions) (list 'nop x))
         (cdr instructions)]
        [z (loop (cdr instructions))])))
  (values new-program new-visited))

(define (part2 filename)
  (define program (read-input filename))
  (define-values (initial-reason initial-visited initial-acc) (execute program))
  (let loop ([visited initial-visited])
    (let*-values ([(new-program new-visited) (change-instruction program visited)]
                  [(reason visited acc) (execute new-program)])
      (if (equal? reason 'end)
          acc
          (loop new-visited)))))

(module+ test
  (check-equal? (part2 "test") 8))

(module+ main
  (displayln (part2 "input")))
