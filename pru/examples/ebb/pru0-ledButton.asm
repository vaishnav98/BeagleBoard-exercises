; PRUSS program to flash a LED on P9_27 (pru0_pru_r30_5) until a button 
; that is connected to P9_28 (pru0_pru_r31_3 is pressed). This program 
; was writen by Derek Molloy for the book Exploring BeagleBone

; .origin 0                        ; start of program in PRU memory
; .entrypoint START                ; program entry point (for a debugger)

    .asg 200, INS_PER_US            ; 5ns per instruction
    .asg 2,	INS_PER_DELAY_LOOP      ; two instructions per delay loop
                                 ; set up a 50ms delay
    .asg 500 * 1000 * (INS_PER_US / INS_PER_DELAY_LOOP) , DELAY  

    .asg 32, PRU0_R31_VEC_VALID     ; allows notification of program completion
    .asg 3, PRU_EVTOUT_0            ; the event number that is sent back

	.clink
	.global start
start:
	; set	r30, r30.t5           ; turn on the output pin (LED on)
	ldi32	r30, 0xffffffff
	ldi32	r0, DELAY        ; store the length of the delay in REG0
DELAYON:
	SUB	r0, r0, 1        ; Decrement REG0 by 1
	QBNE	DELAYON, r0, 0   ; Loop to DELAYON, unless REG0=0
LEDOFF:
	ldi32	r30, 0x00000000
	; clr	r30,	r30.t5           ; clear the output bin (LED off)
	ldi32	r0, DELAY        ; Reset REG0 to the length of the delay
DELAYOFF:
	SUB	r0, r0, 1        ; decrement REG0 by 1
	QBNE	DELAYOFF, r0, 0  ; Loop to DELAYOFF, unless REG0=0

	qba	start
	
	; QBBC	start, r31, 3    ; is the button pressed? If not, loop

END:                             ; notify the calling app that finished
	; MOV	R31.b0, PRU0_R31_VEC_VALID | PRU_EVTOUT_0
	HALT                     ; halt the pru program