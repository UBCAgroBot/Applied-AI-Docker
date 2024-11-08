import onnxruntime as ort
import numpy as np

def test_onnxruntime_cuda():
    # Load a simple ONNX model (example: a random small model)
    # You can use any ONNX model file here
    model_path = "path/to/your/model.onnx"  # Replace with your actual model path

    # Check if CUDA is available for ONNX Runtime
    providers = ort.get_available_providers()
    if 'CUDAExecutionProvider' not in providers:
        print("ONNX Runtime CUDAExecutionProvider not available.")
        return

    # Load the model with CUDA
    ort_session = ort.InferenceSession(model_path, providers=['CUDAExecutionProvider'])

    # Create a dummy input based on the model's input shape
    # For example, assuming the model expects input shape (1, 3, 224, 224)
    dummy_input = np.random.randn(1, 3, 224, 224).astype(np.float32)
    inputs = {ort_session.get_inputs()[0].name: dummy_input}

    # Run inference
    results = ort_session.run(None, inputs)
    print("ONNX Runtime CUDA test passed. Inference performed on GPU.")

test_onnxruntime_cuda()

# You can download pre-trained models from ONNX Model Zoo or export a PyTorch model to ONNX.