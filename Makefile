all: gen build

gen: clean
	mkdir -p src
	mkdir -p include
	asn1c asn/*.asn1 -fno-constraints -no-gen-OER -no-gen-PER -no-gen-example -fcompound-names -fwide-types -D src
	# rm src/per_*.c
	# rm src/xer_*.c
	sed -i "s/timegm/mktime/g" src/*
	mv src/*.h include/

build:
	mkdir -p build
	$(CC) $(CFLAGS) -c src/*.c -Iinclude -Os -DASN_DISABLE_OER_SUPPORT -DASN_DISABLE_PER_SUPPORT
	mv *.o build/
	ar rcs libpkcs7.a build/*.o

clean:
	rm -rf src include build libpkcs7.a

.PHONY: build clean gen
