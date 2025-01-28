(define-data-var total-pool-amount uint u0)
(define-data-var pool-interest-rate uint u5) ;; Annual interest rate in percent
(define-data-var last-distribution-block uint u0)
(define-data-var member-count uint u0)

(define-map savings principal { balance: uint })

;; Events
(define-constant ERR_NOT_ENOUGH_BALANCE (err u100))
(define-constant ERR_NOT_REGISTERED (err u101))
(define-constant ERR_INVALID_AMOUNT (err u102))
(define-constant ERR_ZERO_POOL_AMOUNT (err u103))

;; Register a member in the pool
(define-public (register-member)
  (begin
    (if (is-some (map-get? savings tx-sender))
        (ok false) ;; Already registered
        (begin
          (map-set savings tx-sender (tuple (balance u0)))
          (var-set member-count (+ (var-get member-count) u1))
          (ok true)))))