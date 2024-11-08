import cv2
import numpy as np

def test_opencv_cuda():
    if cv2.cuda.getCudaEnabledDeviceCount() == 0:
        print("No CUDA-enabled GPU detected by OpenCV.")
        return

    # Generate a random image
    image = np.random.randint(0, 256, (512, 512, 3), dtype=np.uint8)

    # Upload image to GPU
    gpu_image = cv2.cuda_GpuMat()
    gpu_image.upload(image)

    # Perform a CUDA-accelerated blur operation
    blurred_image = cv2.cuda.createGaussianFilter(gpu_image.type(), -1, (15, 15), 0).apply(gpu_image)

    # Download result back to CPU
    result = blurred_image.download()
    print("OpenCV CUDA test passed. Image processed on GPU.")

test_opencv_cuda()
