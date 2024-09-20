# Imprime un mensaje por salida estándar, usando write(2).
#
# $Date: 2008/04/21 17:24:06 $

#include <sys/regdef.h>
#include <sys/syscall.h>

	.text
	.align	2

	.globl	main
	.ent	main
main:
	# Llamamos a write(2) para imprimir, ignorando el valor 
	# de retorno, y notando que los registros se preservan 
	# al cruzar la interfaz de llamadas al sistema, algo que
	# no ocurre en el caso de llamadas a procedimientos. 
	#
	li	v0, SYS_write # ver dentro de <sys/syscall.h>.
	li	a0, 1         # a0: standard output file descriptor.
	la	a1, msg       # a1: data pointer.
	li	a2, 12	      # a2: data length (12 bytes).
	syscall

	# Volvemos al sistema operativo, devolviendo un
	# código de retorno nulo.
	#
	move	v0, zero
	j	ra
	.end	main

	.rdata
msg:
	.asciiz	"Hola mundo.\n"
