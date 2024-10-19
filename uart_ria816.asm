;;; ----------------------------------------------------------------------------
;;; ---------------------- UART communication functions  -----------------------
;;; ----------------------------------------------------------------------------

UART    = $FFE0
UARTS   = UART+0
UARTD   = UART+1

        ;; initialize UART
UAINIT: rts                     ; no need to reset anything

        ;; write character to UART, wait until UART is ready to transmit
        ;; A, X and Y registers must remain unchanged
UAPUTW: BIT     UARTS           ; check UART status
        BPL     UAPUTW          ; wait if cannot write (bit 7)
        STA     UARTD           ; write character
        RTS

        ;; get character from UART, return result in A,
        ;; return A=0 if no character available for reading
        ;; X and Y registers must remain unchanged
UAGET:  LDA     UARTS           ; check UART status
        AND     #$40            ; can read?
        BEQ     UAGRET          ; if not, return with Z flag set
        LDA     UARTD           ; read UART data
UAGRET: RTS

        ;; get character from UART, wait if none, return result in A
        ;; X and Y registers must remain unchanged
UAGETW: JSR     UAGET
        BEQ     UAGETW
        RTS
