# Graininess Assessment in Printed Matter

This repository contains all the digitized samples, functions, and variables used in the experiments for the thesis titled "Graininess Assessment in Printed Matter."

## Project Description

This thesis explores the assessment of graininess in printed matter by reviewing the state of the art and analyzing two metrics: the monochromatic graininess score proposed in the 2017 ISO/IEC 24790 standard, and the color graininess score $S_{CG}$ described in the new ISO/TC 18621-22 standard released in May 2024.

The study examines the advantages and weaknesses of each metric, evaluating their effectiveness in differentiating levels of graininess across colored printed samples. Three sets of printed samples, produced by distinct printing combinations to achieve varying levels of graininess, were prepared for this analysis. Additionally, the $S_{CG}$ metric was evaluated using a new set of samples printed with the 320-Chart defined in the ISO standard and the Fogra MediaWedge, a test chart currently used for printing combinations evaluation. The samples were printed with synthetic noise to simulate graininess, added to analyze the correlation of their graininess scores with human perception.

The findings indicate that ISO/TC 18621-22 outperforms ISO/IEC 24790, particularly in its consistency and ability to assess colored prints, addressing a significant limitation of the earlier standard. We propose methodological changes to the $S_{CG}$ metric that enhance its correlation with human perception and optimize the accuracy of score categorization. We demonstrate the effectiveness of using the MediaWedge as the test chart for CMYK printing combinations, with new thresholds for categorizing graininess scores into six categories (A to F), improving accuracy from 0.5 to 0.97. Finally, a Sigmoid function is introduced to map the graininess scores to a grading scale from 0 to 100, with lower scores indicating grainier images and higher scores indicating more uniform images.

This proposed methodology of a mapped graininess score (MG-Score) provides a perceptually uniform assessment of image quality based on perceived graininess. The MG-Score includes a perceptual categorization to describe the appearance of the prints based on their graininess levels.

## Repository Structure

The repository is organized into three main folders:

### 1. Samples
This folder contains all the digitized samples used for the experiments. Each sample is provided in a suitable format for analysis.

### 2. Functions
This folder includes all the `.m` and `.py` files and functions used to evaluate the samples and measure graininess. These scripts implement the methodologies discussed in the thesis and can be used to replicate the experiments.

### 3. Variables
This folder contains all the `.mat` variables used in the functions. These variables include necessary data for running the functions and performing the graininess assessments.

## Usage

1. **Clone the Repository:**
   ```
   git clone https://github.com/your-username/graininess-assessment.git
   ```

2. **Navigate to the Repository:**
   ```
   cd graininess-assessment
   ```

3. **Explore the Folders:**
   - **Samples:** Contains the digitized sample images.
   - **Functions:** Contains MATLAB and Python scripts for evaluation.
   - **Variables:** Contains `.mat` files with variables needed for the scripts.

4. **Run the Scripts:**
   - Ensure you have the necessary software installed (MATLAB or Python with required libraries).
   - Follow the instructions in the scripts to run the evaluations and measure graininess.

## Contact

For any questions or further information, please contact [domerchan@hotmail.com](mailto:domerchan@hotmail.com).
