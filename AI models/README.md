# AI Models Repository

This repository contains two Jupyter notebooks for processing and analyzing task-related data:

1. **`Ocr_extraction.ipynb`**: Handles optical character recognition (OCR) for extracting task details from images.
2. **`Date_time_predictor.ipynb`**: Predicts optimal task scheduling based on user tasks and survey data.

AI_Models
│
├── Ocr_extraction.ipynb
└── Date_time_predictor.ipynb


## Getting Started

### Prerequisites

- Python 3.10 or higher
- Jupyter Notebook
- Required Python packages (listed in the notebooks)

### Setup

1. Clone the repository:

    ```bash
    git clone https://github.com/ChaariMahmoud/Smart-Calendar.git
    ```

2. Navigate to the repository folder:

    ```bash
    cd Smart-Calendar/AI\ models
    ```

3. Install the required Python packages. The required packages are listed in each notebook. You can manually install them using `pip`, for example:

    ```bash
    pip install numpy opencv-python torch easyocr google-generativeai
    ```

### Using the Notebooks

1. Start Jupyter Notebook:

    ```bash
    jupyter notebook
    ```

2. Open and run the notebooks:

    - **`Ocr_extraction.ipynb`**: This notebook demonstrates how to perform OCR on images to extract task details. It includes code for decoding base64 images, extracting text, and interacting with the Gemini API for task extraction.

    - **`Date_time_predictor.ipynb`**: This notebook focuses on predicting optimal task schedules based on user tasks and survey data. It includes code for querying task and survey data, preparing prompts for the Gemini API, and predicting task times.

## Acknowledgments

- **Gemini API**: For generative text modeling.
- **EasyOCR**: For optical character recognition.


## Contributing

Contributions are welcome! Please submit a pull request or open an issue to discuss potential changes.
