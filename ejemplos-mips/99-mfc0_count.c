/*
 * 99-mfc0_count.c - Intenta leer el contador de ciclos del
 * coprocesador MIPS #0. Normalmente, este registro sólo se
 * puede leer cuando el procesador corre con mayor nivel de
 * privilego; en ese caso, el sistema debería generar una
 * excepción adecuadamente (por ejemplo, lanzando SIGILL).
 *
 * $Date: 2007/10/05 16:31:18 $
 */ 

#include <stdio.h>
#include <unistd.h>
#include <sys/select.h>

#ifndef MIPS_CP0_COUNT
#define MIPS_CP0_COUNT "$9"
#endif

int
main(int argc, char * const argv[])
{
	unsigned count;

#define MSLEEP(ms)                                  \
	do {                                        \
		struct timeval tv = {0L, ms*1000L}; \
		select(0, NULL, NULL, NULL, &tv);   \
	} while (0)

	while (1) {
		__asm__ __volatile__ (
			"mfc0 %0, " MIPS_CP0_COUNT "\n\t"
			: "=r" (count)
			:
		);

		printf("count: %u cycles.\n", count);
		MSLEEP(100);
	}

	return 0;
}
