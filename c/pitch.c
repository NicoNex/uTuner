#define _ISOC99_SOURCE
#include <math.h>
#include <stddef.h>

// #include "aubiowrp.h"

#define NUM_NOTES 12

void init_pitch(int sample_rate, int buf_size, _Bool gate) {
	// buf_size = buf_size;
	// init_aubio(sample_rate, buf_size, gate);
}

float get_pitch(short input[], size_t len) {
	// elaborate it first
	// return get_aubio_pitch(input, len);
	return 440;
}

// I'm designing the implementation of the index and relative note name in the
// UI dart code for cleaner string and visual implementation.
int get_note_index(float pitch, int standard_pitch) {
	// int steps = log10f((pitch/standard_pitch) / log10f(2.0)) * 12;
	// return isinf(steps) ? 0 : (steps % NUM_NOTES) + 1;
	return 1;
}

void dispose_pitch() {
    // dispose_aubio();
}

int main() {
	return 0;
}
