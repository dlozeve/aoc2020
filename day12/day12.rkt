#lang racket

(module+ test
  (require rackunit))

(module+ main
  (displayln "Day 12"))

(define (parse-instruction str)
  (list (string->symbol (substring str 0 1))
        (string->number (substring str 1))))

(define (read-input filename)
  (map parse-instruction (file->lines filename)))

(struct state
  (pos dir)
  #:transparent)

(define (step st instr)
  (match instr
    [`(N ,n) (struct-copy state st [pos (+ (state-pos st) (make-rectangular 0 n))])]
    [`(S ,n) (struct-copy state st [pos (- (state-pos st) (make-rectangular 0 n))])]
    [`(E ,n) (struct-copy state st [pos (+ (state-pos st) (make-rectangular n 0))])]
    [`(W ,n) (struct-copy state st [pos (- (state-pos st) (make-rectangular n 0))])]
    [`(F ,n) (struct-copy state st [pos (+ (state-pos st) (* n (state-dir st)))])]
    [`(R ,n) (struct-copy state st [dir (* (state-dir st) (make-polar 1 (degrees->radians (- n))))])]
    [`(L ,n) (struct-copy state st [dir (* (state-dir st) (make-polar 1 (degrees->radians n)))])]))

(define (part1 filename)
  (define input (read-input filename))
  (define final
    (state-pos (for/fold ([st (state 0 1)])
                         ([instr (in-list input)])
                 (step st instr))))
  (exact-round (+ (abs (real-part final)) (abs (imag-part final)))))

(module+ test
  (check-equal? (part1 "test") 25))

(module+ main
  (displayln (part1 "input")))

(define (step2 st instr)
  (match instr
    [`(N ,n) (struct-copy state st [dir (+ (state-dir st) (make-rectangular 0 n))])]
    [`(S ,n) (struct-copy state st [dir (- (state-dir st) (make-rectangular 0 n))])]
    [`(E ,n) (struct-copy state st [dir (+ (state-dir st) (make-rectangular n 0))])]
    [`(W ,n) (struct-copy state st [dir (- (state-dir st) (make-rectangular n 0))])]
    [`(F ,n) (struct-copy state st [pos (+ (state-pos st) (* n (state-dir st)))])]
    [`(R ,n) (struct-copy state st [dir (* (state-dir st) (make-polar 1 (degrees->radians (- n))))])]
    [`(L ,n) (struct-copy state st [dir (* (state-dir st) (make-polar 1 (degrees->radians n)))])]))

(define (part2 filename)
  (define input (read-input filename))
  (define final
    (state-pos (for/fold ([st (state 0 (make-rectangular 10 1))])
                         ([instr (in-list input)])
                 (step2 st instr))))
  (exact-round (+ (abs (real-part final)) (abs (imag-part final)))))

(module+ test
  (check-equal? (part2 "test") 286))

(module+ main
  (displayln (part2 "input")))
