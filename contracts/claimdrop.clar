;; --------------------------------------------------
;; Contract: claim-drop
;; Purpose: Airdrop STX to eligible users who can claim once
;; Author: [Your Name]
;; License: MIT
;; --------------------------------------------------

(define-constant ERR_UNAUTHORIZED (err u100))
(define-constant ERR_ALREADY_CLAIMED (err u101))
(define-constant ERR_NOT_ELIGIBLE (err u102))
(define-constant ERR_INSUFFICIENT_BALANCE (err u103))

;; === Admin Control ===
(define-data-var contract-owner principal tx-sender)

;; === Claimable STX Map ===
(define-map claimable-stx
  principal  ;; user
  uint       ;; amount in micro-STX
)

;; === Claim Status Map ===
(define-map has-claimed
  principal  ;; user
  bool       ;; true = claimed
)

;; === Total Available Funds (for internal tracking, optional) ===
(define-data-var total-assigned uint u0)

;; === Admin: Assign airdrop amount to user ===
(define-public (set-claimable (user principal) (amount uint))
  (begin
    (if (is-eq tx-sender (var-get contract-owner))
        (begin
          (map-set claimable-stx user amount)
          (var-set total-assigned (+ (var-get total-assigned) amount))
          (ok true))
        ERR_UNAUTHORIZED)))

;; === User: Claim STX if eligible ===
(define-public (claim)
  (let (
        (amount (default-to u0 (map-get? claimable-stx tx-sender)))
        (already-claimed (default-to false (map-get? has-claimed tx-sender)))
       )
    (if (is-eq already-claimed true)
        ERR_ALREADY_CLAIMED
        (if (> amount u0)
            (begin
              (try! (stx-transfer? amount (as-contract tx-sender) tx-sender))
              (map-set has-claimed tx-sender true)
              (map-delete claimable-stx tx-sender)
              (ok amount))
            ERR_NOT_ELIGIBLE))))

;; === Read-Only: Check eligibility ===
(define-read-only (check-eligibility (user principal))
  (let (
        (amount (default-to u0 (map-get? claimable-stx user)))
        (claimed (default-to false (map-get? has-claimed user)))
       )
    (ok (and (> amount u0) (not claimed)))))

;; === Read-Only: Has user claimed? ===
(define-read-only (has-user-claimed (user principal))
  (ok (default-to false (map-get? has-claimed user))))

;; === Admin: Withdraw remaining unassigned STX (optional) ===
(define-public (withdraw-unused (amount uint) (recipient principal))
  (if (is-eq tx-sender (var-get contract-owner))
      (stx-transfer? amount (as-contract tx-sender) recipient)
      ERR_UNAUTHORIZED))
