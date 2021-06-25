package main

/*
#cgo CFLAGS: -I.
#cgo LDFLAGS: -L. -lfoo
#include "libfoo.h"
*/
import "C"

import (
	"fmt"
)

func main() {
	fmt.Println(C.MagicNumber())
}
