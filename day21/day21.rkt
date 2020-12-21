#lang racket

(module+ test
  (require rackunit))

(define (read-input filename)
  (map parse-food (file->lines filename)))

(define (parse-food str)
  (define match (regexp-match #px"(.+)\\(contains (.+)\\)" str))
  (list (string-split (cadr match))
        (string-split (caddr match) ", ")))

(define (find-allergens foods)
  (define h (make-hash))
  (for* ([food (in-list foods)]
         [allergen (in-list (cadr food))])
    (define s (hash-ref h allergen (list->set (car food))))
    (hash-set! h allergen (set-intersect s (list->set (car food)))))
  h)

(define (part1 filename)
  (define foods (read-input filename))
  (define allergens (find-allergens foods))
  (define all-ingredients (apply append (map car foods)))
  (define allergen-ingredients (apply set-union (hash-values allergens)))
  (length (for/list ([ingredient (in-list all-ingredients)]
                     #:unless (set-member? allergen-ingredients ingredient))
            ingredient)))

(module+ test
  (check-equal? (part1 "test") 5))

(module+ main
  (displayln (part1 "input")))
