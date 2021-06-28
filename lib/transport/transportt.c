#include <stdlib.h>
#include <stdint.h>
#include <string.h>

typedef struct Transport {
	size_t reads;
	int lenLastWrite;
	uint8_t* lastWrite;
} Transport;

struct Transport *makeTransport() {
	struct Transport *t = malloc(sizeof(struct Transport));
	t->lenLastWrite = 0;
	t->lastWrite = NULL;
	return t;
}

void setLastWrite(struct Transport *t, int len, uint8_t *lastWrite) {
	if (t->lastWrite) {
		free(t->lastWrite);
	} 
	if (len == 0) {
		return;
	}
	t->lastWrite = malloc(len * sizeof(uint8_t));
	t->lenLastWrite = len;
	memcpy(t->lastWrite, lastWrite, len * sizeof(uint8_t));
}

void freeTransport(struct Transport *t) {
	if (t->lastWrite) {
		free(t->lastWrite);
	}
	free(t);
}