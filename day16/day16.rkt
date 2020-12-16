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

(define ((valid? rules) ticket)
  (for/and ([val (in-list ticket)])
    (for/or ([(name rule-proc) (in-hash rules)])
      (rule-proc val))))

(define (field-positions h)
  (if (for/and ([(k v) (in-hash h)]) (= 1 (length v)))
      (for/hash ([(k v) (in-hash h)]) (values k (car v)))
      (begin
        (for ([(name lst) (in-hash h)]
              #:when (= 1 (length lst)))
          (for ([(other-name other-lst) (in-hash h)]
                #:unless (equal? other-name name))
            (hash-set! h other-name (remove (car lst) other-lst))))
        (field-positions h))))

(define (determine-ticket filename)
  (define-values (rules my-ticket nearby-tickets) (read-input filename))
  (define valid-tickets (filter (valid? rules) nearby-tickets))
  (define h (make-hash))
  (for ([(name rule-proc) (in-hash rules)])
    (hash-set! h name (range (length my-ticket))))
  (for ([(name rule-proc) (in-hash rules)]
        #:when #t
        [ticket (in-list valid-tickets)]
        #:when #t
        [val (in-list ticket)]
        [i (in-naturals)]
        #:when (not (rule-proc val)))
    (hash-update! h name (λ (lst) (remove i lst =))))
  (define positions (field-positions h))
  (for/hash ([(name pos) (in-hash positions)])
    (values name (list-ref my-ticket pos))))

(module+ test
  (check-equal? (determine-ticket "test2") (hash "class" 12 "row" 11 "seat" 13)))

(define (part2 filename)
  (define ticket (determine-ticket filename))
  (apply * (for/list ([(name val) (in-hash ticket)]
                      #:when (string-prefix? name "departure"))
             val)))

(module+ main
  (displayln (part2 "input")))
