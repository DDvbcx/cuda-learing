#include <stdio.h>
#include <sys/time.h>
#include <cuda_runtime.h>
#include <math.h>
#include <device_launch_parameters.h>
#define BLOCK_DIM 1024
#define max_function(a, b) ((a) > (b) ? (a) : (b))

double get_walltime()
{
    struct timeval tp;
    gettimeofday(&tp, NULL);
    return (double)(tp.tv_sec + tp.tv_usec * 1e-6)
}

// Kernel for expanding the input tensor to match the output tensor
__global__ void _expand_kernel(float *input, float *output, int nDims,
                               int outputsize, int *inputShape,
                               int *outputShape) {
    int outputIdx = blockIdx.x * blockDim.x + threadIdx.x; // Linear index for output array

    if (outputIdx < outputsize) { // Boundary check
        int inputIdx = 0;  // Index in the input array
        int temp = 1;      // Cumulative multiplier for input indices
        int tmp = 1;       // Temporary value for current dimension index
        int v = outputIdx; // Current output index to process

        for (int i = nDims - 1; i >= 0; --i) {
            if (i == 0) {
                tmp = v; // Handle the first dimension
            } else {
                tmp = v % outputShape[i]; // Calculate dimension index
            }

            if (inputShape[i] == 1) {
                // Broadcasting: input dimension is 1, so index is always 0
                inputIdx += 0;
            } else {
                // Map the current output index to input index
                inputIdx += tmp * temp;
            }

            temp *= inputShape[i];
            v = v / outputShape[i];
        }

        // Assign the input value to the corresponding output index
        output[outputIdx] = input[inputIdx];
    }
}

// Host function to launch the kernel and handle memory management
void expand(float *cpu_input, float *cpu_output, int nDims, int inputsize,
            int outputsize, int *cpu_inputShape, int *cpu_outputShape) {
    double st, ela;
    st = get_walltime();

    // Define grid and block dimensions
    int num_blocks = ceil(outputsize / (double)BLOCK_DIM);
    dim3 block_dim(BLOCK_DIM, 1, 1);
    dim3 grid_dim(num_blocks, 1, 1);

    // Allocate memory on the device
    float *input, *output;
    cudaMalloc((void **)&input, inputsize * sizeof(float));
    cudaMalloc((void **)&output, outputsize * sizeof(float));
    cudaMemcpy(input, cpu_input, inputsize * sizeof(float), cudaMemcpyHostToDevice);

    int *inputShape, *outputShape;
    cudaMalloc((void **)&inputShape, nDims * sizeof(int));
    cudaMalloc((void **)&outputShape, nDims * sizeof(int));
    cudaMemcpy(inputShape, cpu_inputShape, nDims * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(outputShape, cpu_outputShape, nDims * sizeof(int), cudaMemcpyHostToDevice);

    // Record kernel execution time
    cudaEvent_t start, stop;
    float ker_time = 0;
    cudaEventCreate(&start);
    cudaEventCreate(&stop);
    cudaEventRecord(start, 0);

    // Launch the kernel
    _expand_kernel<<<grid_dim, block_dim>>>(input, output, nDims, outputsize,
                                            inputShape, outputShape);

    cudaEventRecord(stop, 0);
    cudaEventSynchronize(stop);
    cudaEventElapsedTime(&ker_time, start, stop);

    // Copy the results back to the host
    cudaMemcpy(cpu_output, output, outputsize * sizeof(float), cudaMemcpyDeviceToHost);

    // Free device memory
    cudaFree(input);
    cudaFree(output);
    cudaFree(inputShape);
    cudaFree(outputShape);

    ela = get_walltime() - st;

    printf("kernel time: %.4f s, total time: %.4f s\n", ker_time / 1000., ela);
}

// Main function
int main() {
    float *cpu_input, *cpu_output;
    int nDims = 4;
    int cpu_inputShape[] = {2, 1, 1, 2};
    int cpu_outputShape[] = {2, 2, 2, 2};

    int inputsize = 1, outputsize = 1;
    for (int i = 0; i < nDims; i++) {
        inputsize *= cpu_inputShape[i];
        outputsize *= cpu_outputShape[i];
    }

    // Allocate host memory
    cpu_input = (float *)malloc(inputsize * sizeof(float));
    cpu_output = (float *)malloc(outputsize * sizeof(float));

    // Initialize the input array
    for (int i = 0; i < inputsize; i++) {
        cpu_input[i] = i;
    }

    // Perform the expand operation
    expand(cpu_input, cpu_output, nDims, inputsize, outputsize, cpu_inputShape, cpu_outputShape);

    // Verify the results
    float result[] = {0, 1, 0, 1, 0, 1, 0, 1, 2, 3, 2, 3, 2, 3, 2, 3};
    float error = 0;
    for (int i = 0; i < outputsize; i++) {
        error = fmax(error, fabs(result[i] - cpu_output[i]));
    }

    printf("Max error: %.4e\n", error);

    // Free host memory
    free(cpu_input);
    free(cpu_output);

    return 0;
}
