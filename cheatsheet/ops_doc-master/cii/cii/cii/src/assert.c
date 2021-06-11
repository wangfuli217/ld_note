#include "assert.h"

const except_t AssertFailedException       = {"AssertFailedException"};

void (assert)(int e) {
	assert(e);
}
