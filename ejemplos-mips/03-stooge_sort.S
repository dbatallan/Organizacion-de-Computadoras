/* 
 * 03-stooge_sort.S - Implementación MIPS del siguiente método:
 *
 * void
 * stooge_sort(int *array, size_t i, size_t j)
 * {
 *         ssize_t k = (j - i + 1)/3;
 * 
 * #define SWAP(type, x, y)        \
 *         do {                    \
 *                 type tmp = (x); \
 *                 (x) = (y);      \
 *                 (y) = tmp;      \
 *         } while (0)
 * 
 *         if (i == j)
 *                 return;
 *         if (array[i] > array[j])
 *                 SWAP(int, array[i], array[j]);
 *         if (i + 1 < j) {
 *                 stooge_sort(array, i, j - k);
 *                 stooge_sort(array, i + k, j);
 *                 stooge_sort(array, i, j - k);
 *         }
 * }
 *
 * Notar, que este código no contempla la posibilidad de
 * código independiente de la posición (PIC). Eso será
 * objeto de análisis en los ejemplos que siguen.
 *
 * $Date: 2015/10/06 13:25:18 $
 */

#include <sys/regdef.h>

	.text
	.align	2
	.globl	stooge_sort
	.ent	stooge_sort
stooge_sort:
	.frame	fp, 48, ra
	.set	noreorder
	.cpload	t9
	.set	reorder
	subu	sp, sp, 48
	.cprestore 32
	sw	ra,  40(sp)
	sw	fp, 36(sp)
	move	fp, sp
	sw	gp,  32(sp)
	sw	a0, 48(sp)
	sw	a1, 52(sp)
	sw	a2, 56(sp)

	# Local area: array, i, j, k.
	#
	sw	a0,   16(sp) # array
	sw	a1,   20(sp) # i
	sw	a2,   24(sp) # j
	sw	zero, 28(sp) # k

	/*
	 * k = (j - i + 1)/3
	 */
	lw	t0, 24(sp) # t0: j
	lw	t1, 20(sp) # t1: i
	subu	t0, t0, t1 # t0: j - i
	addiu	t0, t0, 1  # t0: j - i + 1
	li	t2, 3      # t2: 3
	divu	t0, t0, t2 # t0: (j - i + 1)/3
	sw	t0, 28(sp) # k = (j - i + 1)/3

	/*
	 * if (i == j)
	 *         return;
	 */
	lw	t0, 20(sp)
	lw	t1, 24(sp)
	beq	t0, t1, return

	/*
	 *  if (array[i] > array[j])
	 *          SWAP(int, array[i], array[j]);
	 */
	lw	t0, 16(sp) # t0: array
	lw	t1, 20(sp) # t1: i
	sll	t1, t1, 2
	addu	t0, t0, t1 # t0: &array[i]

	lw	t2, 16(sp) # t2: array
	lw	t3, 24(sp) # t3: j
	sll	t3, t3, 2
	addu	t2, t2, t3 # t2: &array[j]

	lw	t4, 0(t0)  # t4: array[i]
	lw	t5, 0(t2)  # t5: array[j]
	ble	t4, t5, if2

SWAP:
	sw	t5, 0(t0)
	sw	t4, 0(t2)

if2:
	/*
	 * if (i + 1 < j)
	 */
	lw	t0, 20(sp) # t0: i
	addiu	t0, t0, 1  # t0: i + 1
	lw	t1, 24(sp) # t1: j
	bgeu	t0, t1, return

recursion:
	/*
	 * stooge_sort(array, i, j - k);
	 */
	lw	a0, 16(sp) # a0: array
	lw	a1, 20(sp) # a1: i
	lw	a2, 24(sp) # a2: j
	lw	t0, 28(sp) # t0: k
	subu	a2, a2, t0 # a2: j - k
	jal	stooge_sort

	/*
	 * stooge_sort(array, i + k, j);
	 */
	lw	a0, 16(sp) # a0: array
	lw	a1, 20(sp) # a1: i
	lw	t0, 28(sp) # t0: k
	addu	a1, a1, t0 # a1: i + k
	lw	a2, 24(sp) # a2: j
	jal	stooge_sort

	/*
	 * stooge_sort(array, i, j - k);
	 */
	lw	a0, 16(sp) # a0: array
	lw	a1, 20(sp) # a1: i
	lw	a2, 24(sp) # a2: j
	lw	t0, 28(sp) # t0: k
	subu	a2, a2, t0 # a2: j - k
	jal	stooge_sort

return:
	# Destruimos el frame.
	#
	move	sp, fp
	lw	fp, 36(sp)
	lw	ra,  40(sp)
	addu	sp, sp, 48

	# Retorno.
	#
	j	ra
	.end	stooge_sort
