#ifndef AUBIOWRP_H_
#define AUBIOWRP_H_

void init_aubio(int sample_rate, int buf_size, _Bool noise_gate);
float get_aubio_pitch(short input[], size_t len);
void dispose_aubio();

#endif