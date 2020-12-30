#lang racket

(module+ test
  (require rackunit))

(define (read-input filename)
  (define tiles-str (string-split (file->string filename) "\n\n"))
  (for/hash ([str tiles-str])
    (parse-tile str)))

(define (parse-tile str)
  (define tile-id
    (string->number (cadr (string-split (car (string-split str ":\n"))))))
  (define tile (string-split (cadr (string-split str ":\n"))))
  (values tile-id
          (for/set ([s (in-list tile)]
                    [i (in-range 10)]
                    #:when #t
                    [x (in-string s)]
                    [j (in-range 10)]
                    #:when (eq? x #\#))
            (list i j))))

(define (get-tile-edges tile)
  (define edges-lists
    (list (for/list ([k (in-range 10)])
            (if (set-member? tile (list 0 k)) #\1 #\0))
          (for/list ([k (in-range 10)])
            (if (set-member? tile (list k 0)) #\1 #\0))
          (for/list ([k (in-range 10)])
            (if (set-member? tile (list 9 k)) #\1 #\0))
          (for/list ([k (in-range 10)])
            (if (set-member? tile (list k 9)) #\1 #\0))))
  (define reversed-edges-lists (map reverse edges-lists))
  (map (λ (lst) (string->number (list->string lst) 2)) (append edges-lists reversed-edges-lists)))

(define (get-neighbours tiles)
  (define neighbours (make-hash))
  (for* ([(tile1-idx tile1) (in-hash tiles)]
         [(tile2-idx tile2) (in-hash tiles)]
         #:unless (= tile1-idx tile2-idx)
         #:when (not (set-empty? (set-intersect (get-tile-edges tile1) (get-tile-edges tile2)))))
    (hash-update! neighbours tile1-idx (λ (ns) (set-add ns tile2-idx)) (set))
    (hash-update! neighbours tile2-idx (λ (ns) (set-add ns tile1-idx)) (set)))
  neighbours)

(define (part1 filename)
  (define tiles (read-input filename))
  (define neighbours (get-neighbours tiles))
  (for/product ([(tile-idx tile) (in-hash tiles)]
                #:when (= 2 (set-count (hash-ref neighbours tile-idx))))
    tile-idx))

(module+ test
  (check-equal? (part1 "test") 20899048083289))

(module+ main
  (displayln (part1 "input")))

(define (display-tile tile)
  (for* ([j (in-range 10)]
         [i (in-range 10)])
    (when (= i 0)
      (printf "\n"))
    (if (set-member? tile (list i j))
        (printf "#")
        (printf "."))))

(define (rotate tile)
  (for/set ([x (in-set tile)])
    (list (- 9 (cadr x)) (car x))))

(define (flipx tile)
  (for/set ([x (in-set tile)])
    (list (- 9 (car x)) (cadr x))))

(define (flipy tile)
  (for/set ([x (in-set tile)])
    (list (car x) (- 9 (cadr x)))))

(define (all-transformations tiles)
  (define r1 (set-map (hash-values tiles) rotate))
  (define r2 (set-map r1 rotate))
  (define r3 (set-map r2 rotate))
  (define s (set-union (hash-values tiles) r1 r2 r3))
  (list->set (set-union s
                        (set-map s flipx)
                        (set-map s flipy))))

(define (edge tile side)
  (define side-fn (match side
                    [1 (λ (k) (make-rectangular 0 k))]
                    [-1 (λ (k) (make-rectangular 9 k))]
                    [0+1i (λ (k) (make-rectangular k 0))]
                    [0-1i (λ (k) (make-rectangular k 9))]))
  (string->number
   (list->string (for/list ([k (in-range 10)])
                   (if (set-member? tile (side-fn k)) #\1 #\0))) 2))

(define (find-corner tiles)
  (define neighbours (get-neighbours tiles))
  (define corner (for/first ([(tile-idx tile) (in-hash tiles)]
                             #:when (= 2 (set-count (hash-ref neighbours tile-idx))))
                   tile))
  corner)

;; Too boring, cheated
