/*
 * 03-stooge_sort.c - Prueba de stooge_sort.S. La idea,
 * es invocar sucesivamente a stooge_sort(), usando datos
 * progresivamente más complejos.
 *
 * Para compilar:
 *
 * $ cc -g -Wall -o x 03-stooge_sort.c 03-stooge_sort.S.
 *
 * $Date: 2008/04/18 19:58:31 $
 */

#include <stdio.h>
#include <string.h>
#include <sys/types.h>

extern void stooge_sort(int *, size_t, size_t);

static void
print(const char *prefix, int *array, size_t n)
{
	const char *comma = "";

	if (prefix != 0)
		printf("%s", prefix);
	while (n-- > 0) {
		printf("%s%d", comma, *array++);
		comma = ", ";
	}
	printf(".\n");
}

int
main(int argc, char * const argv[])
{
	int array[] = {6, 8, 3, 9, 1, 2, 7, 5, 4, 0};

#define SORT_AND_PRINT(what, len)                      \
	do {                                           \
		int copy[10];                          \
		memcpy(copy, what, len * sizeof(int)); \
		print("in : ", copy, len);             \
		stooge_sort(copy, 0, len - 1);         \
		print("out: ", copy, len);             \
	} while (0)

	SORT_AND_PRINT(array, 1);
	SORT_AND_PRINT(array, 2);
	SORT_AND_PRINT(array, 3);
	SORT_AND_PRINT(array, 4);
	SORT_AND_PRINT(array, 5);
	SORT_AND_PRINT(array, 6);
	SORT_AND_PRINT(array, 7);
	SORT_AND_PRINT(array, 8);
	SORT_AND_PRINT(array, 9);
	SORT_AND_PRINT(array, 10);

	return 0;
}
