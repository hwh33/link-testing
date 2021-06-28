package main

/*
#cgo CFLAGS: -I.
#cgo LDFLAGS: -L. -lmagicnumber
#include "libmagicnumber.h"
*/
import "C"

import (
	"fmt"
)

func main() {
	fmt.Println(C.MagicNumber())
}
