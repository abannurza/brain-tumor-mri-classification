# Brain Tumor MRI Classification Using Texture Features and Multilayer Perceptron

This repository contains a MATLAB-based brain tumor classification project using MRI images and texture-based feature extraction. The proposed system combines **Gabor Filter** and **Discrete Wavelet Transform (DWT)** for feature extraction, and uses **Multilayer Perceptron (MLP)** for multiclass classification.

## Overview
Brain tumors are serious medical conditions that require early detection and accurate diagnosis to support proper treatment. In this project, a brain tumor classification system was developed using coronal MRI images and texture-based features. The system is designed to assist early detection by combining image preprocessing, feature extraction, and neural network-based classification.

## Dataset
This project is based on a **"Brain MRI ND-5 Dataset" sourced from IEEE DataPort**.

The original dataset contains brain MRI images from three imaging planes:
- Axial
- Coronal
- Sagittal

For this study, only **coronal MRI images** were selected and used in the classification stage.

### Classes
The classification task includes 3 classes:
- Glioma
- Meningioma
- Pituitary

### Data Used in This Study
The final dataset used for classification consists of:
- **1000 glioma images**
- **1000 meningioma images**
- **1000 pituitary images**

Total:
- **3000 coronal MRI images**

### Note
The full raw dataset from IEEE DataPort is not completely uploaded in this repository.  
To keep the repository concise and organized, only the selected data used in this study are included.

## Preprocessing
Before feature extraction, all MRI images go through the following preprocessing steps:
- Image resizing to **256 × 256 pixels**
- Grayscale conversion
- Image enhancement using **adaptive histogram equalization** (`adapthisteq`)

These steps are performed to standardize the input images and improve texture visibility for further analysis.

## Feature Extraction
This project uses two texture-based feature extraction methods:

### 1. Gabor Filter
Gabor Filter is used to capture local texture information based on spatial frequency and orientation.

- Filter bank configuration: **2 scales and 4 orientations**
- Produces **512 features** for each image

### 2. Discrete Wavelet Transform (DWT)
DWT is used to extract frequency-based texture information from MRI images.

- Wavelet used: **Daubechies 4 (db4)**
- Decomposition level: **Level 2**
- Subbands used:
  - A2
  - H2
  - V2
  - D2
  - H1
  - V1
  - D1
- Statistical features extracted from each subband:
  - Mean
  - Standard Deviation
  - Energy

This process produces **21 features** for each image.

### Combined Features
The final feature vector used as input to the classifier contains:
- **533 features**
  - 512 Gabor features
  - 21 DWT features

## Classification
Classification is performed using **Multilayer Perceptron (MLP)**.

### Training Algorithms
Two MLP training algorithms are compared:
- **Levenberg–Marquardt (LM)**
- **Scaled Conjugate Gradient (SCG)**

### Hidden Node Variations
The MLP model is tested using four hidden node configurations:
- 5 hidden nodes
- 10 hidden nodes
- 15 hidden nodes
- 20 hidden nodes

### Evaluation Strategy
Each model configuration is evaluated through:
- **10 runs**
- **10-fold cross-validation**
- Data split for each fold:
  - **90% training**
  - **5% validation**
  - **5% testing**

### Evaluation Metrics
The performance of the models is analyzed using:
- Performance plot
- Confusion Matrix
- ROC Curve
- Training, validation, and testing accuracy

## Best Model
The best-performing model in this study is:

**Levenberg–Marquardt (LM) with 20 Hidden Nodes**

### Average Performance
- Training Accuracy: **95.54%**
- Validation Accuracy: **85.00%**
- Testing Accuracy: **85.09%**

### Best Run
- Training Accuracy: **96.9%**
- Validation Accuracy: **90.0%**
- Testing Accuracy: **88.7%**

These results show that the combination of **Gabor Filter**, **DWT**, and **MLP** provides strong performance for multiclass brain tumor classification based on MRI images.

## MATLAB App Implementation
The best model was successfully implemented into a **MATLAB App** to support practical image classification.

The app allows users to:
- Load an MRI image
- Run tumor classification
- Display the predicted class
- Show confidence/probability results
- Reset the interface for a new prediction

## Tools and Technologies
- MATLAB R2022a
- Gabor Filter
- Discrete Wavelet Transform (DWT)
- Multilayer Perceptron (MLP)
- Medical Image Processing
- Pattern Recognition

## Suggested Repository Structure
```text
brain-tumor-mri-classification/
├── README.md
├── code/
│   ├── preprocessing/
│   ├── feature_extraction/
│   ├── classification/
│   └── app/
├── dataset/
├── results/
└── models/
