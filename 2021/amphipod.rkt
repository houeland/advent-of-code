#lang racket
(require data/heap)

(define l0 (read-line (current-input-port) 'any))
(define l1 (read-line (current-input-port) 'any))
(define l2 (read-line (current-input-port) 'any))
(define l3 (read-line (current-input-port) 'any))
(define l4 (read-line (current-input-port) 'any))
(define l5 (read-line (current-input-port) 'any))
(define l6 (read-line (current-input-port) 'any))
(define start (list l0 l1 l2 l3 l4 l5 l6))

(define (movecost from_x from_y to_x to_y)
  ;(display "...")
  ;(displayln (list (list from_x from_y) (list to_x to_y)))
  (if (and (= from_x to_x) (= from_y to_y))
    0
    (+ (- from_y 1) (abs (- from_x to_x)) (- to_y 1))
  )
)

(define-syntax-rule (inc! x y)
  (set! x (+ x y))
)

(define (getxy s x y)
  (substring (list-ref s y) x (+ x 1))
)

(define (h s)
  (define a-good 0)
  (define b-good 0)
  (define c-good 0)
  (define d-good 0)
  (define h-cost 0)
  (for ([y '(6 5 4 3 2 1 0)])
    (when (equal? "A" (getxy s 3 y))
      (inc! a-good 1)
    )
    (when (equal? "B" (getxy s 5 y))
      (inc! b-good 1)
    )
    (when (equal? "C" (getxy s 7 y))
      (inc! c-good 1)
    )
    (when (equal? "D" (getxy s 9 y))
      (inc! d-good 1)
    )
  )
  (for ([y '(6 5 4 3 2 1 0)])
    (for ([x '(0 1 2 3 4 5 6 7 8 9 10 11 12)])
      (define curchar (getxy s x y))
      (define num-steps-needed #f)
      (define (domove check-str want-x gotgood)
        (define want-y (- 5 gotgood))
        (set! num-steps-needed (+ (abs (- x want-x)) (abs (- y want-y))))
        (and (equal? check-str curchar) (not (= want-x x)))
      )
      (when (domove "A" 3 a-good)
        ;(displayln (list "move A from" x y))
        (inc! h-cost (* num-steps-needed 1))
        (inc! a-good 1)
      )
      (when (domove "B" 5 b-good)
        ;(displayln (list "move B from" x y))
        (inc! h-cost (* num-steps-needed 10))
        (inc! b-good 1)
      )
      (when (domove "C" 7 c-good)
        ;(displayln (list "move C from" x y))
        (inc! h-cost (* num-steps-needed 100))
        (inc! c-good 1)
      )
      (when (domove "D" 9 d-good)
        ;(displayln (list "move D from" x y))
        (inc! h-cost (* num-steps-needed 1000))
        (inc! d-good 1)
      )
    )
  )
  h-cost)

(h start)

(define (print-state s spent-cost label)
  (display (car s))
  (display " g-sum:")
  (display (+ (h s) spent-cost))
  (display " heur:")
  (display (h s))
  (display " spent:")
  (display spent-cost)
  (display " ")
  (display label)
  (displayln "")
  (for ([x (cdr s)])
    (displayln x)
  )
)

(define (poke-str str idx newchar)
  (define new-poke-str (string-copy str))
  (string-set! new-poke-str idx newchar)
  (string->immutable-string new-poke-str)
)

(define (update-board s x y new-x new-y newchar)
  ;(displayln (list "try moving" newchar x y "to" new-x new-y))
  (define output-board (build-list 7
    (lambda (yy)
      (cond
        [(= yy new-y) (poke-str (list-ref s yy) new-x newchar)]
        [(= yy y) (poke-str (list-ref s yy) x #\.)]
        [else (list-ref s yy)]
      )
    )
  ))
  output-board
)

(define (list-next-moves already-spent-cost s)
  ;(print-state s already-spent-cost 'move-from-pos)
  (define new-move-list '())

  (define (try-it check-str xxx)
    (define try-it-ready #t)
    (for ([yyy '(2 3 4 5)])
        (define curchar (getxy s xxx yyy))
        (cond
        [(equal? curchar check-str)]
        [(equal? curchar ".")]
        [else (set! try-it-ready #f)]
        )
    )
    try-it-ready
  )

  (define a-ready (try-it "A" 3))
  (define b-ready (try-it "B" 5))
  (define c-ready (try-it "C" 7))
  (define d-ready (try-it "D" 9))

  ;(displayln (list a-ready b-ready c-ready d-ready s))

  (for ([x '(0 1 2 3 4 5 6 7 8 9 10 11 12)])
    (define y-found 0)
    (for ([y '(2 3 4 5 6)])
      #:break (> y-found 0)
      (define curchar (getxy s x y))
      (define (try-raise check-str check-chr check-cost)
        ;(displayln (list "compare-char equal?" curchar check-str))
        (when (equal? curchar check-str)
          ;(displayln (list "raise" check-str "from" x y))
          (define (sub-move-it new-x dx)
            (unless (member new-x '(3 5 7 9))
              (define num-steps (+ (- y 1) dx))
              (define add-move-cost (* num-steps check-cost))
              (define new-board (update-board s x y new-x 1 check-chr))
              ;(print-state new-board (list 'new-board add-move-cost))
              (set! new-move-list (cons (list (+ already-spent-cost add-move-cost) new-board) new-move-list))
            )
          )
          (for ([dx 20])
            #:break (not (equal? (getxy s (- x dx) 1) "."))
            (define new-x (- x dx))
            (sub-move-it new-x dx)
          )
          (for ([dx 20])
            #:break (not (equal? (getxy s (+ x dx) 1) "."))
            (define new-x (+ x dx))
            (sub-move-it new-x dx)
          )
          (set! y-found 1)
        )
      )
      (try-raise "A" #\A 1)
      (try-raise "B" #\B 10)
      (try-raise "C" #\C 100)
      (try-raise "D" #\D 1000)
    )
  )

  (for ([x '(0 1 2 3 4 5 6 7 8 9 10 11 12)])
    (define curchar (getxy s x 1))
    (define (try-sink check-str check-chr check-cost trg-x)
      (when (equal? curchar check-str)
        (define trg-y 0)
        (for ([yyy 6])
          (unless (equal? curchar (getxy s trg-x yyy))
            ;(displayln (list "sink-to" yyy))
            (set! trg-y yyy)
          )
        )
        (define num-steps (- trg-y 1))
        ;(displayln (list "sink" check-str "from" x 1 "to" trg-x trg-y))
        ;(print-state s already-spent-cost 'sink-from-pos)
        (define blocked #f)
        (for ([xx (in-range (+ x 1) (+ trg-x 1) 1)])
          ;(display (list xx " "))
          (inc! num-steps 1)
          (when (not (equal? "." (getxy s xx 1)))
            (set! blocked #t)
          )
        )
        (for ([xx (in-range (- x 1) (- trg-x 1) -1)])
          ;(display (list xx " "))
          (inc! num-steps 1)
          (when (not (equal? "." (getxy s xx 1)))
            (set! blocked #t)
          )
        )
        ;(displayln (list "num-steps" num-steps "blocked?" blocked))
        (unless blocked
          (define add-move-cost (* num-steps check-cost))
          (define new-board (update-board s x 1 trg-x trg-y check-chr))
          (set! new-move-list (cons (list (+ already-spent-cost add-move-cost) new-board) new-move-list))
        )
      )
    )
    (when a-ready (try-sink "A" #\A 1 3))
    (when b-ready (try-sink "B" #\B 10 5))
    (when c-ready (try-sink "C" #\C 100 7))
    (when d-ready (try-sink "D" #\D 1000 9))
  )

  (reverse new-move-list)
)

(define pq
  (make-heap
    (lambda (a b) (<= (car a) (car b)))
  )
)
(define ht-seen (make-hash))
(define ht-camefrom (make-hash))

(define (addboard! g spent-cost board source-board)
  (heap-add! pq (list g spent-cost board source-board))
)

(displayln "start search")

(addboard! (h start) 0 start '())

(define super-mega-victorious #f)
(define found-goal-state '())

(for ([step-iter 1000000])
  #:break (= (heap-count pq) 0)
  #:break super-mega-victorious
  (match-define (list heur-cost cur-spent-cost cur-board came-from-board) (heap-min pq))
  (heap-remove-min! pq)
  ;(displayln (list "check-hash" cur-board))

  (define cur-h-to-goal (h cur-board))
  (when (= (modulo step-iter 10000) 0)
    (displayln (list "search iter" step-iter "remaining cost" cur-h-to-goal))
  )

  (when (= cur-h-to-goal 0)
    (displayln "super mega victory!")
    (set! super-mega-victorious #t)
    (set! found-goal-state cur-board)
    (displayln (list "search iter" step-iter "remaining cost" cur-h-to-goal))
    (displayln (list "spent:" cur-spent-cost "board:" cur-board))
    (print-state cur-board cur-spent-cost 'victory-pos)
  )

  (unless (hash-has-key? ht-seen cur-board)
    (hash-set! ht-seen cur-board cur-spent-cost)
    (hash-set! ht-camefrom cur-board came-from-board)
  
    ;(displayln (list "spent:" cur-spent-cost "board:" cur-board))
    ;(print-state cur-board cur-spent-cost 'source-pos)
  
    ;(displayln "new moves:")
    (define new-moves (list-next-moves cur-spent-cost cur-board))
    (for-each
      (match-lambda [(list mcost mboard)
        ;(displayln (list mcost mboard))
        ;(print-state mboard mcost 'candidate)
        (define mg (+ mcost (h mboard)))
        (when (< mg heur-cost)
          (displayln (list "well that's not good! child:" mg "parent:" heur-cost))
          (print-state cur-board cur-spent-cost 'parent)
          (print-state mboard mcost 'child)
        )
        (addboard! mg mcost mboard cur-board)
      ])
    new-moves)
  )
)

(define b found-goal-state)
(define solution-path '())
(for ([step-iter 1000000])
  #:break (equal? b '())
  (set! solution-path (cons b solution-path))
  (set! b (hash-ref ht-camefrom b #f))
)
(displayln "")
(displayln "== solution path: ==")
(for-each
  (lambda (b)
    (define bcost (hash-ref ht-seen b #f))
    (print-state b bcost 'solution-trace)
    (displayln "")
  )
solution-path)
