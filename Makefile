FOO_DIR = lib/fake-transports/foo
MN_DIR = cmd/magicnumber
TD_DIR = cmd/transportdemo

MN_SRCS = $(shell find ./lib/magicnumber -type f -name "*.go")

TRANSPORTT_SRCS = $(FOO_DIR)/transportt.c $(FOO_DIR)/libtransportt.h
TRANSPORT_SRCS = $(FOO_DIR)/libtransport.so $(FOO_DIR)/libtransport.h
TD_SRCS = $(TD_DIR)/libtransport.h $(TD_DIR)/libtransport.so $(TD_DIR)/libtransportt.h $(TD_DIR)/libtransportt.so

.PHONY: magicnumber clean-magicnumber transportdemo clean-transportdemo clean

clean: clean-magicnumber clean-transportdemo

# magicnumber

$(MN_DIR)/libmagicnumber.h $(MN_DIR)/libmagicnumber.so: $(MN_SRCS)
	go build -buildmode=c-shared -o=$(MN_DIR)/libmagicnumber.so ./lib/magicnumber

magicnumber: $(MN_DIR)/libmagicnumber.h $(MN_DIR)/libmagicnumber.so
	@cd $(MN_DIR) && go run .

clean-magicnumber:
	rm $(MN_DIR)/libmagicnumber*

# transportdemo

$(FOO_DIR)/libtransportt.so: $(TRANSPORTT_SRCS)
	cd $(FOO_DIR) && gcc -fPIC -shared -o libtransportt.so transportt.c

$(TRANSPORT_SRCS): $(FOO_DIR)/libtransportt.so $(FOO_DIR)/libtransportt.h $(FOO_DIR)/transport.go
	cd $(FOO_DIR) && go build -buildmode=c-shared -o libtransport.so .

$(TD_SRCS): $(TRANSPORT_SRCS) $(TRANSPORTT_SRCS)
	cp $(FOO_DIR)/libtransport* $(TD_DIR)

transportdemo: $(TD_SRCS)
	@cd $(TD_DIR) && go run .

clean-transportdemo:
	rm $(FOO_DIR)/*.so $(FOO_DIR)/libtransport.h $(TD_DIR)/libtransport*