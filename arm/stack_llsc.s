	.arch armv6
	.eabi_attribute 27, 3
	.eabi_attribute 28, 1
	.fpu vfp
	.eabi_attribute 20, 1
	.eabi_attribute 21, 1
	.eabi_attribute 23, 3
	.eabi_attribute 24, 1
	.eabi_attribute 25, 1
	.eabi_attribute 26, 2
	.eabi_attribute 30, 6
	.eabi_attribute 34, 1
	.eabi_attribute 18, 4
	.file	"stac_llsc.s"
	.text
	.align	2
	.global	push
	.type	push, %function
push:
	stmfd	sp!, {fp, lr}
	add	fp, sp, #4
	sub	sp, sp, #8
	str	r0, [fp, #-8] 	@ Address of head
	str	r1, [fp, #-12] 	@ Address of e (and e->next)

.PUSH_BEGIN:
	mcr	p15, 0, r0, c7, c10, 5
	ldr	r3, [r0]		@ Load content of head
	str	r3, [r1] 		@ Store e->next
	ldrex	r2, [r0]		@ Load content of head
	cmp     r3, r2
	bne	.PUSH_BEGIN		@ Head has changed
	strex	lr, r1, [r0]		@ Store in head
	cmp	lr, #0
	bne	.PUSH_BEGIN		@ Failed, restart
	mcr	p15, 0, r0, c7, c10, 5
	sub	sp, fp, #4
	@ sp needed
	ldmfd	sp!, {fp, pc}
	.size	push, .-push
	.align	2
	.global	pop
	.type	pop, %function
pop:
	stmfd	sp!, {fp, lr}
	add	fp, sp, #4
	sub	sp, sp, #16
	str	r0, [fp, #-16]

.POP_BEGIN:
	mcr	p15, 0, r0, c7, c10, 5
	ldr	r3, [r0]
	cmp	r3, #0
	beq	.POP_RETURN

	str	r3, [fp, #-8]	@store in old_head
	ldr	r4, [r3]	@ Next
	ldrex	r2, [r0]
	cmp     r3, r2
	bne	.POP_BEGIN		@ Head has changed
	strex	lr, r4, [r0]
	cmp	lr, #0
	bne	.POP_BEGIN
	mcr	p15, 0, r0, c7, c10, 5
.POP_RETURN:
	mov	r0, r3
	sub	sp, fp, #4
	@ sp needed
	ldmfd	sp!, {fp, pc}
	.size	pop, .-pop
	.ident	"GCC: (Raspbian 4.9.1-19) 4.9.1"
	.section	.note.GNU-stack,"",%progbits
