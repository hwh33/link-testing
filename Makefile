FOO_DIR = lib/fake-transports/foo
TD_DIR = cmd/transportdemo

LIBMN_SRCS = $(shell find ./lib/magicnumber -type f -name "*.go")
LIBFOO_SRCS = $(shell find ./lib/fake-transports/foo -type f -name "*.go")

TRANSPORTT_SRCS = $(FOO_DIR)/transportt.c $(FOO_DIR)/libtransportt.h
TRANSPORT_SRCS = $(FOO_DIR)/libtransport.so $(FOO_DIR)/libtransport.h
TD_SRCS = $(TD_DIR)/libtransport.h $(TD_DIR)/libtransport.so $(TD_DIR)/libtransportt.h $(TD_DIR)/libtransportt.so

.PHONY: print-magicnumber transportdemo clean-transportdemo

# magicnumber

cmd/magicnumber/libmagicnumber.h cmd/magicnumber/libmagicnumber.so: $(LIBMN_SRCS)
	go build -buildmode=c-shared -o=cmd/magicnumber/libmagicnumber.so ./lib/magicnumber

print-magicnumber: cmd/magicnumber/libmagicnumber.h cmd/magicnumber/libmagicnumber.so
	@cd cmd/magicnumber && go run .

# transportdemo

$(FOO_DIR)/libtransportt.so: $(TRANSPORTT_SRCS)
	cd $(FOO_DIR) && gcc -fPIC -shared -o libtransportt.so transportt.c

$(TRANSPORT_SRCS): $(FOO_DIR)/libtransportt.so $(FOO_DIR)/libtransportt.h
	cd $(FOO_DIR) && go build -buildmode=c-shared -o libtransport.so .

$(TD_SRCS): $(TRANSPORT_SRCS) $(TRANSPORTT_SRCS)
	cp $(FOO_DIR)/libtransport* $(TD_DIR)

transportdemo: $(TD_SRCS)
	@cd cmd/transportdemo && go run .

clean-transportdemo:
	rm $(FOO_DIR)/*.so $(FOO_DIR)/libtransport.h $(TD_DIR)/libtransport*