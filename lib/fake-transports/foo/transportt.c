#include <stdlib.h>
#include <stdint.h>

typedef struct Transport {
	size_t reads;
	int lenLastWrite;
	uint8_t* lastWrite;
} Transport;

struct Transport *makeTransport() {
	struct Transport *t = malloc(sizeof(struct Transport));
	return t;
}

void freeTransport(struct Transport *t) {
	if (t->lastWrite != NULL) {
		free(t->lastWrite);
	}
	free(t);
}