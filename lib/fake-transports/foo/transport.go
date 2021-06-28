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
	"fmt"
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
	fmt.Println("writing")
	lastWrite := make([]byte, len(b))
	copy(lastWrite, b)

	t.lastWrite = (*C.uint8_t)(unsafe.Pointer(&lastWrite[0]))
	return len(b), 0
}

//export Read
func Read(t *C.Transport, b []byte) (n int, err int) {
	fmt.Println("reading")
	t.reads++
	lastWrite := C.GoBytes(unsafe.Pointer(&t.lastWrite), t.lenLastWrite)
	n = copy(b, lastWrite)
	// TODO: modify t.lastWrite based on n
	return n, 0
}

func main() {}
