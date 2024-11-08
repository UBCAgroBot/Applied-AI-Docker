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