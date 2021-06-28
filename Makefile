TR_DIR = lib/transport
MN_DIR = cmd/magicnumber
TD_DIR = cmd/transportdemo

MN_SRCS = $(shell find ./lib/magicnumber -type f -name "*.go")

TRANSPORTT_SRCS = $(TR_DIR)/transportt.c $(TR_DIR)/libtransportt.h
TRANSPORT_SRCS = $(TR_DIR)/libtransport.so $(TR_DIR)/libtransport.h
TD_SRCS = $(TD_DIR)/libtransport.h $(TD_DIR)/libtransport.so $(TD_DIR)/libtransportt.h $(TD_DIR)/libtransportt.so

.PHONY: magicnumber clean-magicnumber transportdemo clean-transportdemo clean

clean: clean-magicnumber clean-transportdemo

# magicnumber

$(MN_DIR)/libmagicnumber.h $(MN_DIR)/libmagicnumber.so: $(MN_SRCS)
	go build -buildmode=c-shared -o=$(MN_DIR)/libmagicnumber.so ./lib/magicnumber

magicnumber: $(MN_DIR)/libmagicnumber.h $(MN_DIR)/libmagicnumber.so
	@cd $(MN_DIR) && go run .

clean-magicnumber:
	rm -f $(MN_DIR)/libmagicnumber*

# transportdemo

$(TR_DIR)/libtransportt.so: $(TRANSPORTT_SRCS)
	cd $(TR_DIR) && gcc -fPIC -shared -o libtransportt.so transportt.c

$(TRANSPORT_SRCS): $(TR_DIR)/libtransportt.so $(TR_DIR)/libtransportt.h $(TR_DIR)/transport.go
	cd $(TR_DIR) && go build -buildmode=c-shared -o libtransport.so .

$(TD_SRCS): $(TRANSPORT_SRCS) $(TRANSPORTT_SRCS)
	cp $(TR_DIR)/libtransport* $(TD_DIR)

transportdemo: $(TD_SRCS)
	@cd $(TD_DIR) && go run .

clean-transportdemo:
	rm -f $(TR_DIR)/*.so $(TR_DIR)/libtransport.h $(TD_DIR)/libtransport*