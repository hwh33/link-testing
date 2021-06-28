#include <stdlib.h>
#include <stdint.h>

typedef struct {
    size_t reads;
	int lenLastWrite;
	uint8_t* lastWrite;
} Transport;

extern Transport *makeTransport();
extern void freeTransport(Transport *t);