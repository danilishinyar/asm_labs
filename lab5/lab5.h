#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <unistd.h>
#include <math.h>
#include <time.h>
#define STB_IMAGE_IMPLEMENTATION
#include "stb/stb_image.h"
#define STB_IMAGE_WRITE_IMPLEMENTATION
#include "stb/stb_image_write.h"
#define N 25
#define sigma 256
#ifndef GaussianBlur
#define GaussianBlur

void blurImage(unsigned char* inputData, unsigned char* outputData, unsigned char* matrix, int width, int height, int channels, int matr_offset);
void Asm_blurImage(unsigned char* inputData, unsigned char* outputData, unsigned char* matrix, int width, int height, int channels, int matr_offset);
void timing();
#endif
