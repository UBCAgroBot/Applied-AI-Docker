import cupy as cp

def test_cupy_cuda():
    print(cp.cuda.runtime.runtimeGetVersion())
    try:
        # Create two random arrays on the GPU
        a = cp.random.rand(1000, 1000, dtype=cp.float32)
        b = cp.random.rand(1000, 1000, dtype=cp.float32)
        
        # Perform an element-wise addition
        c = a + b
        print("CuPy CUDA test passed. Array operation performed on GPU.")

    except cp.cuda.runtime.CUDARuntimeError as e:
        print("CuPy CUDA test failed:", e)

test_cupy_cuda()