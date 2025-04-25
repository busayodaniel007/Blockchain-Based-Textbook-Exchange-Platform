;; Payment Processing Contract
;; Handles secure transactions

;; Define the token to be used for payments (STX by default)
(define-fungible-token textbook-token)

;; Initial token supply
(define-data-var token-supply uint u1000000000)

;; Initialize token supply
(begin
  (ft-mint? textbook-token (var-get token-supply) tx-sender))

;; Error codes
(define-constant ERR-INSUFFICIENT-FUNDS (err u500))
(define-constant ERR-TRANSFER-FAILED (err u501))

;; Process payment between buyer and seller
(define-public (process-payment (buyer principal) (seller principal) (amount uint))
  (let ((buyer-balance (ft-get-balance textbook-token buyer)))
    (if (>= buyer-balance amount)
      (match (ft-transfer? textbook-token amount buyer seller)
        success (ok true)
        error (err ERR-TRANSFER-FAILED))
      (err ERR-INSUFFICIENT-FUNDS))))

;; Get token balance
(define-read-only (get-balance (user principal))
  (ft-get-balance textbook-token user))

;; Mint tokens (for testing purposes)
(define-public (mint-tokens (recipient principal) (amount uint))
  (begin
    (ft-mint? textbook-token amount recipient)))

;; Burn tokens
(define-public (burn-tokens (amount uint))
  (begin
    (ft-burn? textbook-token amount tx-sender)))
