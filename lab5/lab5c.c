#include "lab5.h"

void blurImage(unsigned char* inputData, unsigned char* outputData, unsigned char* matrix, int width, int height, int channels, int matr_offset){
    long int c = 0;
    long int res = 0;
    for(int y = 0; y < height; y++){
        for(int x = 0; x < width; x++){
            for(int k = 0; k < channels; k++){
            if(((x <= matr_offset) || (x >= width - matr_offset)) || ((y <= matr_offset) || (y >= height - matr_offset))){
                outputData[k + x * channels + y * channels * width] = inputData[k + x * channels + y * channels * width];
                continue;
            }
            c = 0;
            res = 0;
            for(int i = -matr_offset; i <= matr_offset; ++i){
                for(int j = -matr_offset; j <= matr_offset; ++j){
                c += inputData[k + (x + j)*channels + (y + i) * width * channels] * matrix[matr_offset + j + (matr_offset + i)*5];
                }
            }
            res = c / sigma;
            if (res < 255)
                outputData[k + x * channels + y * channels * width] = res;
            else
                outputData[k + x * channels + y * channels * width] = 255;
            }
        }
    }
}


void timing(){
   char inputList[5][15] = {"imgs/pic1.jpeg", "imgs/pic2.jpeg", "imgs/pic3.jpeg", "imgs/pic4.jpeg", "imgs/pic5.jpeg"};
   char outputList[5][15] = {"imgs/res1.jpeg", "imgs/res2.jpeg", "imgs/res3.jpeg", "imgs/res4.jpeg", "imgs/res5.jpeg"};
   clock_t t;
   int matr_offset = 2;
   unsigned char matrix[N] = {1,4,6,4,1,
                              4,16,24,16,4,
                              6,24,36,24,6,
                              4,16,24,16,4,
                              1,4,6,4,1};
   double time;
   int width, channels, height;
   unsigned char* inputData = NULL;
   unsigned char* outputData = NULL;
   for(int i = 0; i < 5; ++i){
       printf("---image %d---\n", i + 1);
       inputData = stbi_load(inputList[i], &width, &height, &channels, 0);
       outputData = malloc(height*channels*width);
       t = clock();
       Asm_blurImage(inputData, outputData, matrix, width, height, channels, matr_offset);
       t = clock() - t;
       time = ((double)t) / CLOCKS_PER_SEC;
       printf("Asm: %f\n", time);
       t = clock();
       blurImage(inputData, outputData, matrix, width, height, channels, matr_offset);
       t = clock() - t;
       time = ((double)t) / CLOCKS_PER_SEC;
       printf("C:   %f\n", time);
       stbi_write_jpg(outputList[i], width, height, channels, outputData, 100);
       stbi_image_free(inputData);
       free(outputData);
   }
}

int main(int argc, char** argv){
    if (argc == 1){
        timing();
        exit(1);
    }
    if (argc != 3){
        fprintf(stderr, "Usage: %s <input_file> <output_file>\n", argv[0]);
        exit(-1);
    }
    char* input = argv[1];
    char* output = argv[2];
    if (access(input, F_OK) != 0){//test for file existance
        fprintf(stderr, "Input file doesn't exist\n");
        exit(-1);
    }
    int fd = open(output, O_WRONLY | O_CREAT | O_TRUNC, 0666);
    if(fd < 0){
        fprintf(stderr, "Can't open output file\n");
        exit(-1);
    }
    close(fd);
    int matr_offset = sqrt(N) / 2;
    unsigned char matrix[N] = {1, 4, 6, 4, 1,
                       4, 16, 24, 16, 4,
                      6, 24, 36, 24, 6,
                       4, 16, 24, 16, 4,
                       1, 4, 6, 4, 1};
    int width, height, channels;
    unsigned char* inputData = NULL;
    inputData = stbi_load(input, &width, &height, &channels, 0);
    if(!inputData){
        fprintf(stderr, "Can't load image\n");
        exit(-1);
    }
    unsigned char* outputData = NULL;
    outputData = malloc(width*height*channels);
    if (outputData == NULL){
        fprintf(stderr, "Failed to allocate memory\n");
        exit(-1);
    }
    Asm_blurImage(inputData, outputData, matrix, width, height, channels, matr_offset);
    stbi_write_jpg(output, width, height, channels, outputData, 100);
    stbi_image_free(inputData);
    free(outputData);
}
