# 04-lseek.S: ejemplo de invocación de SYS_lseek: creamos un archivo
# de longitud nula (si ya existe, intentamos truncarlo). A continuación,
# usamos lseek(2) para posicionarnos 1KB después del comenzo, creando
# de esta forma un hueco en el archivo. Luego escribimos una marca, para
# verificar que el contenido del archivo sea correcto una vez que este
# programa haya finalizado.
#
# $Date: 2009/05/16 16:48:01 $

#include <sys/regdef.h>
#include <sys/syscall.h>

#ifndef O_RDONLY
#define O_RDONLY 0x00000000 /* open for reading only */
#endif

#ifndef O_WRONLY
#define O_WRONLY 0x00000001 /* open for writing only */
#endif

#ifndef O_CREAT
#define O_CREAT  0x00000200 /* create if nonexistent */
#endif

#ifndef O_TRUNC
#define O_TRUNC  0x00000400 /* truncate to zero length */
#endif

#ifndef SEEK_SET
#define SEEK_SET 0x0        /* set file offset to offset */
#endif

	.text
	.align	2

	.globl	main
	.ent	main
main:
	.frame fp, 48, ra
	.set	noreorder
	.cpload	t9
	.set	reorder
	subu	sp, sp, 48

	.cprestore 32
	sw	ra, 44(sp)
	sw	fp, 40(sp)
	sw	gp, 36(sp)
	move	fp, sp

	# Creamos un archivo para hacer la prueba. Si ya existe, lo
	# truncamos, de tal forma que tenga longitud nula. En caso de
	# no poder abrir el archivo, terminamos con código no nulo.
	#
	li	v0, SYS_open                 # ver dentro de <sys/syscall.h>.
	la	a0, fname                    # a0: file name.
	li	a1, O_WRONLY|O_CREAT|O_TRUNC # a1: flags.
	li	a2, 0644                     # a2: mode.
	syscall

	# Verificamos el retorno de la llamada a SYS_open: si terminó
	# bien, continuamos. De lo contrario, retornamos al sistema.
	#
	bne	a3, zero, exit_error
	sw	v0, 24(fp)     # file descriptor.

	# En este punto, ya tenemos el archivo abierto, listo para ser
	# usado: creamos un huego de 1024 bytes, invocando a SYS_lseek
	# para posicionaros en ese punto, creándose así el hueco.
	#
	li	v0, SYS_syscall
	li	a0, SYS_lseek   # a0: system call code (lseek).
	lw	a1, 24(fp)     # a1: file descriptor ($fp + 0).
	li	a2, 0           # a2: pad (fp + 4).
	li	a3, 1024        # a3: offset (low) (fp + 8).
	sw	zero, 12(fp)	# offset (high) ($fp + 12).
	li	t0, SEEK_SET
	sw	t0, 16(fp)     # whence ($fp + 16).
	sw      zero, 20(fp)   # unused ($fp + 20).
	syscall

	# (Nuevamente,) verificamos el código de retorno de SYS_lseek.
	#
	bne	a3, zero, exit_error

	# Ya estamos posicionados: escribimos un mensaje en el archivo
	# para poder luego verificar que esta marca haya sido colocada
	# en el lugar adecuado (por ejemplo, usando od).
	#
	li	v0, SYS_write   # v0: system call code (lseek).
	lw	a0, 24(fp)     # a0: file descriptor ($fp + 0).
	la	a1, msg         # a1: data pointer.
	li	a2, 3           # a2: data length.
	syscall

	# Verificamos el código de retorno de la llamada al system call
	# SYS_write: esto involucra dos pasos: primero, ver si $a3 tiene
	# valor nulo; y luego verificar que la cantidad de información
	# escrita ($v0), coincida con la cantidad de información enviada.
	#
	bne	a3, zero, exit_error
	bne	v0, 3, exit_error

exit_ok:
	# Finalmente, volvemos al sistema operativo devolviendo un
	# código de retorno nulo.
	#
	# Primero, restauramos los valores de los registros relevantes,
	# y luego destruímos nuestro stack frame.
	#
	move	v0, zero
	move	sp, fp
	lw	ra, 44(sp)
	lw	fp, 40(sp)
	addu	sp, sp, 48
	j	ra

exit_error:
	li	v0, SYS_exit
	li	a0, 1
	syscall
	.end	main

	.rdata
fname:
	.asciiz	"file"
msg:
	.ascii	"123"
