pitch.o:
	gcc -lm -c pitch.c

dylib:
	gcc -dynamiclib -lm pitch.o -o ../pitch.dylib

clean:
	rm -f pitch.o ../pitch.dylib
