# **EdgeNet**
A robust edge detection and line-fitting pipeline designed for precision in image processing tasks. By combining custom convolution kernels for edge enhancement and the RANSAC algorithm for line detection, it delivers accurate and reliable results in applications such as computer vision, object detection, and feature extraction.

## **Visual Results**
| **Before RANSAC** | **After RANSAC** |
|--------------------|------------------|
| <img width="200" alt="before" src="https://github.com/user-attachments/assets/e3b64cca-7e45-4b48-b3c4-37fc05ba463f" /> | <img width="200" alt="after" src="https://github.com/user-attachments/assets/6d4d1b4d-a511-4ef4-966f-5d75e9580032" /> |

## **Features**
- **Custom Convolution Kernels:** Enhances edges with adjustable weights for precise detection.
- **RANSAC Algorithm:** Detects lines robustly by iteratively fitting models to edge points and rejecting outliers.
- **Flexible Parameters:** Supports tuning of thresholds for edge detection and RANSAC fitting.
