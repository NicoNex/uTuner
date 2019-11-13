#include "aubio.h"
#include "mathutils.h"


struct data {
	aubio_pitch_t *o;
	fvec_t *input;
	fvec_t *pitch;
	_Bool noise_gate; // consider remove
};


struct data data;


void init_aubio(int sample_rate, int buf_size, _Bool noise_gate) {
	uint32_t hop = buf_size / 4;

    data.o = new_aubio_pitch("vinfast", buf_size, hop, sample_rate);
    data.input = new_fvec(hop);
    data.pitch = new_fvec(1);
    data.noise_gate = noise_gate;
    aubio_pitch_set_unit(data.o, "Hz");
}

// Input is the data taken from the mic.
float get_aubio_pitch(short input[], size_t len) {
	if (len != data.input->length)
		return len;

	for (uint_t i = 0; i < len; i++)
		fvec_set_sample(data.input, input[i], i);

	if (data.noise_gate && aubio_silence_detection(data.input, 45))
		return 0;

	aubio_pitch_do(data.o, data.input, 0);
	return fvec_get_sample(data.pitch, 0);
}

void dispose_aubio() {
	del_aubio_pitch(data.o);
	del_fvec(data.pitch);
	del_fvec(data.input);
	aubio_cleanup();
}
