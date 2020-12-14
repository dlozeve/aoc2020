#lang racket

(module+ test
  (require rackunit))

(define (parse-line str)
  (if (string-prefix? str "mask")
      (list 'mask (string-trim str "mask = "))
      (let ([params (map string->number (cdr (regexp-match #px"mem\\[(\\d+)\\] = (\\d+)" str)))])
        (list 'mem (car params) (cadr params)))))

(define (read-input filename)
  (map parse-line (file->lines filename)))

(define (apply-mask mask num)
  (define num-binary (reverse (string->list (number->string num 2))))
  (define num-lst (append num-binary (make-list (- 36 (length num-binary)) #\0)))
  (define mask-lst (reverse (string->list mask)))
  (define res-lst (for/list ([d (in-list num-lst)]
                             [m (in-list mask-lst)])
                    (cond
                      [(eq? m #\1) #\1]
                      [(eq? m #\0) #\0]
                      [else d])))
  (string->number (list->string (reverse res-lst)) 2))

(define (part1 filename)
  (define input (read-input filename))
  (define mem (make-hash))
  (for/fold ([mask ""])
            ([instr (in-list input)])
    (match instr
      [`(mask ,x) x]
      [`(mem ,i ,x) (hash-set! mem i (apply-mask mask x))
                    mask]))
  (apply + (hash-values mem)))

(module+ test
  (check-equal? (part1 "test") 165))

(module+ main
  (displayln (part1 "input")))

(define (floating-expansion mask)
  (define x-indexes (indexes-of (reverse (string->list mask)) #\X))
  (for/list ([idxs (in-combinations x-indexes)])
    (apply + (map (λ (idx) (- (expt 2 idx))) idxs))))

(define (destinations mask mask-expansion addr)
  (map (λ (x) (+ (bitwise-ior mask addr) x)) mask-expansion))

(module+ test
  (let* ([mask "000000000000000000000000000000X1001X"]
         [mask-num (string->number (string-replace mask "X" "1") 2)]
         [mask-expansion (floating-expansion mask)])
    (check-equal? (sort (destinations mask-num mask-expansion 42) <)
                  '(26 27 58 59)))
  (let* ([mask "00000000000000000000000000000000X0XX"]
         [mask-num (string->number (string-replace mask "X" "1") 2)]
         [mask-expansion (floating-expansion mask)])
    (check-equal? (sort (destinations mask-num mask-expansion 16) <)
                  '(16 17 18 19 24 25 26 27))))

(define (part2 filename)
  (define input (read-input filename))
  (define mem (make-hash))
  (for/fold ([mask 0]
             [mask-expansion '()])
            ([instr (in-list input)])
    (match instr
      [`(mask ,x) (values (string->number (string-replace x "X" "1") 2)
                          (floating-expansion x))]
      [`(mem ,i ,x) (for ([dest (in-list (destinations mask mask-expansion i))])
                      (hash-set! mem dest x))
                    (values mask mask-expansion)]))
  (apply + (hash-values mem)))

(module+ test
  (check-equal? (part2 "test2") 208))

(module+ main
  (displayln (part2 "input")))
