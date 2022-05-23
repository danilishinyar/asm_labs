CC := aarch64-linux-gnu-gcc
EXE = lol
.PHONY: build
build: *.s
	$(CC) -g -static -o $(EXE) $^

clean:
	rm -rf $(EXE)

