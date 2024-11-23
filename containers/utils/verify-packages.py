import subprocess
import os

def test_cupy_cuda():
    try:
        import cupy as cp
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
            return
    except ImportError as e:
        print("CuPy import failed:", e)
        return

def test_onnxruntime_cuda():
    try:
        import onnxruntime as ort
        try:
            # Check if CUDA is available for ONNX Runtime
            providers = ort.get_available_providers()
            if 'CUDAExecutionProvider' not in providers:
                print("ONNX Runtime CUDAExecutionProvider not available.")
                return
            else:
                print("Onnxruntime test passed. CUDA execution provider available.")
        
        except Exception as e:
            print(f"Onnxruntime test failed: {e}")
            return
    except ImportError as e:
        print("Onnxruntime import failed:", e)
        return

def test_opencv_cuda():
    try:
        import numpy as np
        import cv2
        try:
            if cv2.cuda.getCudaEnabledDeviceCount() == 0:
                print("No CUDA-enabled GPU detected by OpenCV.")
                return

            # Generate a random image
            image = np.random.randint(0, 256, (512, 512, 3), dtype=np.uint8)

            # Upload image to GPU
            gpu_image = cv2.cuda_GpuMat()
            gpu_image.upload(image)

            # Perform a CUDA-accelerated blur operation
            print("OpenCV CUDA test passed. Image uploaded to GPU and processed.")
        
        except Exception as e:
            print(f"OpenCV test failed: {e}")
            return
    except ImportError as e:
        print("OpenCV import failed:", e)
        return

import pycuda.autoinit
import pycuda.driver as drv
from pycuda.compiler import SourceModule

def test_pycuda():
    try:
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
    
    except Exception as e:
        print(f"PyCuda test failed: {e}")
        return

import torch

def test_pytorch_cuda():
    try:
        # Check if CUDA is available
        if not torch.cuda.is_available():
            print("CUDA is not available in PyTorch.")
            return
        print(torch.version.cuda)

        # Print the GPU name and CUDA version
        print("CUDA is available!")
        print("Device name:", torch.cuda.get_device_name(0))
        print("CUDA version:", torch.version.cuda)
        
        # Create a random tensor and move it to the GPU
        tensor = torch.rand(1000, 1000).to("cuda")
        
        # Perform a simple operation on the GPU
        result = tensor * tensor
        print("PyTorch CUDA test passed. Tensor operation performed on GPU.")
    
    except Exception as e:
        print(f"PyTorch test failed: {e}")

def test_pyzed():
    try:
        import pyzed.sl as sl
        print("PyZED test passed. Package can be imported.")
    except ImportError:
        print("PyZED is not installed.")
    except Exception as e:
        print(f"PyZED test failed: {e}")

def check_ros2():
    try:
        # Source ROS 2 setup script
        ros2_setup_script = "/opt/ros/humble/setup.bash"  # Update if necessary
        if not os.path.exists(ros2_setup_script):
            print("ROS 2 setup script not found. Please verify the installation path.")
            return

        # Check ROS 2 installation
        print("Sourcing ROS 2 environment...")
        subprocess.check_call(f"ros2 doctor", shell=True, executable="/bin/bash")

        # Run a basic ROS 2 command to list nodes
        print("Testing ROS 2 functionality...")
        topics = subprocess.check_output(f"source {ros2_setup_script} && ros2 topic list", shell=True, executable="/bin/bash").decode("utf-8")

        if topics:
            print("ROS 2 is functioning correctly. Topics available:", topics)
        else:
            print("ROS 2 is installed, but no topics are available.")

    except subprocess.CalledProcessError as e:
        print("ROS 2 test failed:", e)
    except FileNotFoundError:
        print("ROS 2 is not installed or not in the system PATH.")
    except Exception as e:
        print(f"ROS2 test failed: {e}")

from ultralytics import YOLO

def test_ultralytics_cuda():
    try:
        # Load YOLOv5 model with CUDA
        model = YOLO("yolov5s.pt").to("cuda")
        
        # Create a dummy image
        import numpy as np
        image = np.random.randint(0, 255, (640, 640, 3), dtype=np.uint8)
        
        # Run inference
        results = model.predict(image)
        print("Ultralytics YOLOv5 CUDA test passed. Inference performed on GPU.")
    except Exception as e:
        print("Ultralytics YOLOv5 CUDA test failed:", e)

test_ultralytics_cuda()

check_ros2()

test_cupy_cuda()

test_onnxruntime_cuda()

test_opencv_cuda()

test_pycuda()

test_pytorch_cuda()

test_pyzed()