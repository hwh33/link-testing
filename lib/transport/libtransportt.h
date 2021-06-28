#include <stdlib.h>
#include <stdint.h>

typedef struct {
    size_t reads;
	int lenLastWrite;
	uint8_t* lastWrite;
} Transport;

extern Transport *makeTransport();
extern void setLastWrite(Transport *t, int len, uint8_t *lastWrite);
extern void freeTransport(Transport *t);