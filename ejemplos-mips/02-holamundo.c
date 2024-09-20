/*
 * 02-holamundo.c - En este caso, mostramos cómo hacer
 * para invocar desde C nuestras rutinas o métodos assembly.
 *
 * Para compilar:
 *
 * $ cc -g -Wall -o x 02-holamundo.c 02-holamundo.S
 *
 * $Date: 2008/04/18 10:38:15 $
 */

#include <unistd.h>

extern size_t mystrlen(const char *);

int
main(int argc, char * const argv[])
{
	char *msg = "Hola mundo.\n";
	write(1, msg, mystrlen(msg));
	return 0;
}
