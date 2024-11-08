import pycuda.autoinit
import pycuda.driver as drv
import numpy as np
from pycuda.compiler import SourceModule

def test_pycuda():
    # Initialize input arrays on the host (CPU)
    a = np.random.randn(1000).astype(np.float32)
    b = np.random.randn(1000).astype(np.float32)
    c = np.zeros_like(a)

    # CUDA kernel code for element-wise addition
    mod = SourceModule("""
    __global__ void add(float *a, float *b, float *c) {
        int idx = threadIdx.x + blockIdx.x * blockDim.x;
        c[idx] = a[idx] + b[idx];
    }
    """)

    # Get the kernel function from the compiled module
    add = mod.get_function("add")

    # Run the kernel (1000 threads, in 1 block)
    add(drv.In(a), drv.In(b), drv.Out(c), block=(1000, 1, 1), grid=(1, 1))

    # Verify the result
    if np.allclose(c, a + b):
        print("PyCUDA test passed. Kernel executed on GPU.")
    else:
        print("PyCUDA test failed.")

test_pycuda()