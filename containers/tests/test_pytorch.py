import torch

def test_pytorch_cuda():
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

# Run the test
test_pytorch_cuda()