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
  (unique-allergens h))

(define (unique-allergens h)
  (if (for/and ([(k v) (in-hash h)]) (= 1 (set-count v)))
      (for/hash ([(k v) (in-hash h)]) (values k (set-first v)))
      (begin
        (for ([(k v) (in-hash h)]
              #:when (= 1 (set-count v))
              [(other-k other-v) (in-hash h)]
              #:unless (equal? other-k k))
          (hash-set! h other-k (set-remove other-v (set-first v))))
        (unique-allergens h))))

(define (part1 filename)
  (define foods (read-input filename))
  (define allergens (find-allergens foods))
  (define all-ingredients (apply append (map car foods)))
  (define allergen-ingredients (hash-values allergens))
  (length (for/list ([ingredient (in-list all-ingredients)]
                     #:unless (set-member? allergen-ingredients ingredient))
            ingredient)))

(module+ test
  (check-equal? (part1 "test") 5))

(module+ main
  (displayln (part1 "input")))

(define (part2 filename)
  (define foods (read-input filename))
  (define allergens (find-allergens foods))
  (define allergen-ingredients (for/list ([allergen (sort (hash-keys allergens) string<=?)])
                                 (hash-ref allergens allergen)))
  (string-join allergen-ingredients ","))

(module+ test
  (check-equal? (part2 "test") "mxmxvkd,sqjhc,fvjkl"))

(module+ main
  (displayln (part2 "input")))
