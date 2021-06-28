package main

/*
#cgo CFLAGS: -I.
#cgo LDFLAGS: -L. -ltransport
#include "libtransport.h"
*/
import "C"
import (
	"fmt"
	"os"
	"unsafe"
)

func toGoSlice(b []byte) C.GoSlice {
	return C.GoSlice{
		unsafe.Pointer(&b[0]), C.longlong(len(b)), C.longlong(cap(b)),
	}
}

func main() {
	msg := "hello, transport"
	fmt.Println("initializing transport")
	t := C.NewTransport()
	defer C.FreeTransport(t)
	fmt.Println("writing")
	wreturn := C.Write(t, toGoSlice([]byte(msg)))
	fmt.Println("done writing")
	if wreturn.r1 != C.GoInt(0) {
		fmt.Println("write err:", wreturn.r1)
		os.Exit(1)
	}
	b := make([]byte, len(msg))
	fmt.Println("reading")
	rreturn := C.Read(t, toGoSlice(b))
	fmt.Println("done reading")
	if rreturn.r1 != C.GoInt(0) {
		fmt.Println("read err:", rreturn.r1)
		os.Exit(1)
	}
	fmt.Println("msg:", string(b)) // TODO: try to use r.r0 (n)
}
