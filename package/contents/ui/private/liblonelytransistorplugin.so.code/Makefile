all:
	mkdir -p build
	(cd build && qmake ../ && make)
	cp build/*.so ../
clean:
	rm -rf build
