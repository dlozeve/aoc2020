#lang racket/base

(require racket/list
         racket/string
         graph)

(module+ test
  (require rackunit))

(module+ main
  (displayln "Day 7"))

(define (read-input filename)
  (with-input-from-file filename
    (lambda ()
      (weighted-graph/directed
       (append*
        (for/list ([line (in-lines)]
                   #:unless (string-contains? line "contain no"))
          (define nodes (regexp-match* #px"\\w+\\s\\w+ bag" line))
          (define weights (map string->number (regexp-match* #px"\\d+" line)))
          (for/list ([node (cdr nodes)]
                     [w weights])
            (list w (car nodes) node))))))))

(define (part1 filename)
  (define g (read-input filename))
  (define-values (dists preds) (bfs (transpose g) "shiny gold bag"))
  (for/sum ([(k v) dists]
            #:when (< 0 v +inf.0))
    1))

(module+ test
  (check-equal? (part1 "test") 4))

(module+ main
  (displayln (part1 "input")))

(define (count-bags g bag)
  (add1 (for/sum ([t (in-neighbors g bag)])
          (* (edge-weight g bag t) (count-bags g t)))))

(define (part2 filename)
  (define g (read-input filename))
  (sub1 (count-bags g "shiny gold bag")))

(module+ test
  (check-equal? (part2 "test") 32)
  (check-equal? (part2 "test2") 126))

(module+ main
  (displayln (part2 "input")))
