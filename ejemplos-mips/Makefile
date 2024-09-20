PROGS  = 00-holamundo 01-holamundo 02-holamundo 03-stooge_sort 04-lseek 05-io
CFLAGS = -g -Wall

all: $(PROGS)
	:

00-holamundo: 00-holamundo.S
	$(CC) $(CFLAGS) -o $@ $<

01-holamundo: 01-holamundo.S
	$(CC) $(CFLAGS) -o $@ $<

02-holamundo: 02-holamundo.c 02-holamundo.S
	$(CC) $(CFLAGS) -o $@ 02-holamundo.c 02-holamundo.S

03-stooge_sort: 03-stooge_sort.c 03-stooge_sort.S
	$(CC) $(CFLAGS) -o $@ 03-stooge_sort.c 03-stooge_sort.S

04-lseek: 04-lseek.S
	$(CC) $(CFLAGS) -o $@ $<

05-io: 05-io.S
	$(CC) $(CFLAGS) -o $@ $<

clean:
	rm -f $(PROGS) *.so *.o *.a *.core
