LIBFOO_SRCS = $(shell find ./lib/foo -type f -name "*.go")

.PHONY: print-magicnumber

cmd/magicnumber/libfoo.h cmd/magicnumber/libfoo.so: $(LIBFOO_SRCS)
	go build -buildmode=c-shared -o=cmd/magicnumber/libfoo.so ./lib/foo

print-magicnumber: cmd/magicnumber/libfoo.h cmd/magicnumber/libfoo.so
	@cd cmd/magicnumber && go run .