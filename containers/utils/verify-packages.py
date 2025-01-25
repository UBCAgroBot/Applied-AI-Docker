import subprocess
import os
import numpy as np

def log_success(message):
    print(f"✅ {message}")

def log_error(message):
    print(f"❌ {message}")

def test_cupy_cuda():
    try:
        import cupy as cp
        log_success("CuPy imported successfully.")
        try:
            version = cp.cuda.runtime.runtimeGetVersion()
            log_success(f"CuPy CUDA runtime version: {version}")
            
            a = cp.random.rand(1000, 1000, dtype=cp.float32)
            b = cp.random.rand(1000, 1000, dtype=cp.float32)
            c = a + b
            log_success("CuPy CUDA test passed. Array operation performed on GPU.")

        except cp.cuda.runtime.CUDARuntimeError as e:
            log_error(f"CuPy CUDA test failed: {e}")
    except ImportError as e:
        log_error(f"CuPy import failed: {e}")

def test_onnxruntime_cuda():
    try:
        import onnxruntime as ort
        log_success("ONNX Runtime imported successfully.")
        try:
            providers = ort.get_available_providers()
            if 'CUDAExecutionProvider' in providers:
                log_success("ONNX Runtime CUDAExecutionProvider available.")
            else:
                log_error("ONNX Runtime CUDAExecutionProvider not available.")
        except Exception as e:
            log_error(f"ONNX Runtime test failed: {e}")
    except ImportError as e:
        log_error(f"ONNX Runtime import failed: {e}")

def test_opencv_cuda():
    try:
        import cv2
        log_success("OpenCV imported successfully.")
        try:
            if cv2.cuda.getCudaEnabledDeviceCount() == 0:
                log_error("No CUDA-enabled GPU detected by OpenCV.")
                return

            image = np.random.randint(0, 256, (512, 512, 3), dtype=np.uint8)
            gpu_image = cv2.cuda_GpuMat()
            gpu_image.upload(image)

            log_success("OpenCV CUDA test passed. Image uploaded to GPU and processed.")
        except Exception as e:
            log_error(f"OpenCV test failed: {e}")
    except ImportError as e:
        log_error(f"OpenCV import failed: {e}")

def test_pycuda():
    try:
        import pycuda.autoinit
        import pycuda.driver as drv
        from pycuda.compiler import SourceModule
        log_success("PyCUDA imported successfully.")
        try:
            a = np.random.randn(1000).astype(np.float32)
            b = np.random.randn(1000).astype(np.float32)
            c = np.zeros_like(a)

            mod = SourceModule("""
            __global__ void add(float *a, float *b, float *c) {
                int idx = threadIdx.x + blockIdx.x * blockDim.x;
                c[idx] = a[idx] + b[idx];
            }
            """)
            add = mod.get_function("add")
            add(drv.In(a), drv.In(b), drv.Out(c), block=(1000, 1, 1), grid=(1, 1))

            if np.allclose(c, a + b):
                log_success("PyCUDA test passed. Kernel executed on GPU.")
            else:
                log_error("PyCUDA test failed. Kernel output mismatch.")
        except Exception as e:
            log_error(f"PyCUDA test failed: {e}")
    except ImportError as e:
        log_error(f"PyCUDA import failed: {e}")

def test_pytorch_cuda():
    try:
        import torch
        log_success("PyTorch imported successfully.")
        try:
            if not torch.cuda.is_available():
                log_error("CUDA is not available in PyTorch.")
                return

            log_success(f"CUDA version in PyTorch: {torch.version.cuda}")
            log_success(f"Device name: {torch.cuda.get_device_name(0)}")
            
            tensor = torch.rand(1000, 1000).to("cuda")
            result = tensor * tensor
            log_success("PyTorch CUDA test passed. Tensor operation performed on GPU.")
        except Exception as e:
            log_error(f"PyTorch test failed: {e}")
    except ImportError as e:
        log_error(f"PyTorch import failed: {e}")

def test_pyzed():
    try:
        import pyzed.sl as sl
        log_success("PyZED imported successfully.")
    except ImportError as e:
        log_error(f"PyZED import failed: {e}")

def check_ros2():
    try:
        ros2_setup_script = "/opt/ros/humble/setup.bash"
        if not os.path.exists(ros2_setup_script):
            log_error("ROS 2 setup script not found. Verify installation path.")
            return

        log_success("Sourcing ROS 2 environment...")
        subprocess.check_call(f"ros2 doctor", shell=True, executable="/bin/bash")
        log_success("ROS 2 is functioning correctly.")
    except subprocess.CalledProcessError as e:
        log_error(f"ROS 2 test failed: {e}")
    except FileNotFoundError:
        log_error("ROS 2 is not installed or not in the system PATH.")
    except Exception as e:
        log_error(f"ROS2 test failed: {e}")

def test_ultralytics_cuda():
    try:
        from ultralytics import YOLO
        log_success("Ultralytics YOLO imported successfully.")
        try:
            model = YOLO("yolov5s.pt").to("cuda")
            image = np.random.randint(0, 255, (640, 640, 3), dtype=np.uint8)
            results = model.predict(image)
            log_success("Ultralytics YOLOv5 CUDA test passed. Inference performed on GPU.")
        except Exception as e:
            log_error(f"Ultralytics YOLOv5 CUDA test failed: {e}")
    except ImportError as e:
        log_error(f"Ultralytics import failed: {e}")

# Run tests
test_ultralytics_cuda()
check_ros2()
test_cupy_cuda()
test_onnxruntime_cuda()
test_opencv_cuda()
test_pycuda()
test_pytorch_cuda()
test_pyzed()
