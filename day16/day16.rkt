#lang racket

(module+ test
  (require rackunit))

(define (parse-ticket str)
  (map string->number (string-split str ",")))

(define (parse-rules lst)
  (for/hash ([str (in-list lst)])
    (define name (car (string-split str ": ")))
    (define ranges (map string->number (regexp-match* #px"\\d+" str)))
    (values name
            (λ (n) (or (<= (first ranges) n (second ranges))
                       (<= (third ranges) n (fourth ranges)))))))

(define (read-input filename)
  (define in-str (file->string filename))
  (define rules (parse-rules (regexp-match* #px"[\\w ]+: \\d+-\\d+ or \\d+-\\d+" in-str)))
  (define my-ticket
    (parse-ticket (cadr (regexp-match #px"your ticket:\n([\\d,]+)" in-str))))
  (define nearby-tickets
    (map parse-ticket
         (string-split
          (cadr (regexp-match #px"nearby tickets:\n([\\d,\n]+)" in-str)))))
  (values rules my-ticket nearby-tickets))

(define (part1 filename)
  (define-values (rules my-ticket nearby-tickets) (read-input filename))
  (define invalid-values
    (for*/list ([ticket (in-list nearby-tickets)]
                [val (in-list ticket)]
                #:when (for/and ([(name rule-proc) (in-hash rules)])
                         (not (rule-proc val))))
      val))
  (apply + invalid-values))

(module+ test
  (check-equal? (part1 "test1") 71))

(module+ main
  (displayln (part1 "input")))
