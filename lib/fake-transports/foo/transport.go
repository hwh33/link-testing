package main

/*
#cgo CFLAGS: -I.
#cgo LDFLAGS: -L. -ltransportt
#include "libtransportt.h"
#include <stdlib.h>
#include <stdint.h>
*/
import "C"

import (
	"unsafe"
)

//export NewTransport
func NewTransport() *C.Transport {
	t := C.makeTransport()
	return t
}

//export FreeTransport
func FreeTransport(t *C.Transport) {
	C.freeTransport(t)
}

//export Write
func Write(t *C.Transport, b []byte) (n int, err int) {
	C.setLastWrite(t, C.int(len(b)), (*C.uint8_t)(unsafe.Pointer(&b[0])))
	return len(b), 0
}

//export Read
func Read(t *C.Transport, b []byte) (n int, err int) {
	t.reads++
	lastWrite := C.GoBytes(unsafe.Pointer(t.lastWrite), t.lenLastWrite)
	n = copy(b, lastWrite)
	// TODO: modify t.lastWrite based on n
	return n, 0
}

func main() {}
