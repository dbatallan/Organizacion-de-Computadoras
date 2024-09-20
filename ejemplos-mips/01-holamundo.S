# Similar a 00-holamundo.S (imprime un mensaje por salida 
# estándar, usando write(2)); pero, en este caso, vamos a
# calcular dinámicamente la longitud del string impreso.
#
# Para esto, escribimos un método, mystrlen(), que opera sobre
# un string, calculando y retornando, su longitud.
#
# Además, y debido a que este programa hace llamadas a código
# en funciones, deberemos respetar la ABI usada en el sistema.
#
# $Date: 2010/04/14 17:47:14 $

#include <sys/regdef.h>
#include <sys/syscall.h>

	.text
	.align	2

	.globl	main
	.ent	main
main:
	.frame	fp, 32, ra
	.set	noreorder
	.cpload	t9
	.set	reorder
	subu	sp, sp, 32
	.cprestore 20
	sw	ra,  28(sp)
	sw	fp, 24(sp)
	move	fp, sp

	# Calculamos la longitud del string.
	#
	la	a0, msg
	jal	mystrlen
	sw      v0, 8(sp)

	# Llamamos a write(2) para imprimir, ignorando el valor 
	# de retorno, y notando que los registros se preservan 
	# al cruzar la interfaz de llamadas al sistema, algo que
        # no ocurre en el caso de llamadas a procedimientos.
	#
	li	v0, SYS_write # ver dentro de <sys/syscall.h>.
	li	a0, 1         # a0: standard output file descriptor.
	la	a1, msg       # a1: data pointer.
	lw	a2, 8(sp)     # a2: longitud, según mystrlen().
	syscall

	# Volvemos al sistema operativo, devolviendo un código 
	# de retorno nulo.
	#
	move	v0, zero
	lw	ra,  28(sp)
	lw	fp, 24(sp)
	addu	sp, sp, 32
	j	ra
	.end	main

	.ent	mystrlen
mystrlen:
	.frame	fp, 16, ra
	.set	noreorder
	.cpload	t9
	.set	reorder
	subu	sp, sp, 16
	.cprestore 0
	sw	gp, 4(sp)
	sw	fp, 8(sp)
	move	fp, sp
	sw	a0, 16(sp)

	# Use v0 for the result.
	#
	li	v0, 0
mystrlen_loop:
	lb	t0, 0(a0)
	beqz	t0, mystrlen_return
	addiu	a0, a0, 1
	addiu	v0, v0, 1
	j	mystrlen_loop

mystrlen_return:
	# Destruimos el frame.
	#
	lw	fp, 8(sp)
	addu	sp, sp, 16

	# Retorno.
	#
	j	ra
	.end	mystrlen

	.rdata
msg:
	.asciiz	"Hola mundo.\n"
