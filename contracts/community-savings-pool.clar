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

;; Contribute to the pool
(define-public (contribute (amount uint))
  (begin
    (asserts! (> amount u0) ERR_INVALID_AMOUNT)
    (asserts! (is-some (map-get? savings tx-sender)) ERR_NOT_REGISTERED)
    (let ((current-balance (get balance (unwrap! (map-get? savings tx-sender) ERR_NOT_REGISTERED))))
      (try! (stx-transfer? amount tx-sender (as-contract tx-sender)))
      (map-set savings tx-sender (tuple (balance (+ current-balance amount))))
      (var-set total-pool-amount (+ (var-get total-pool-amount) amount))
      (ok true))))

;; Withdraw from the pool
(define-public (withdraw (amount uint))
  (let ((current-balance (get balance (default-to (tuple (balance u0)) (map-get? savings tx-sender)))))
    (if (>= current-balance amount)
        (begin
          (map-set savings tx-sender (tuple (balance (- current-balance amount))))
          (var-set total-pool-amount (- (var-get total-pool-amount) amount))
          (ok true))
        ERR_NOT_ENOUGH_BALANCE)))
