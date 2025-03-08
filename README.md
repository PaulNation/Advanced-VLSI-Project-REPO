# Advanced VLSI Project Repository

This repository contains the source code, design files, and scripts for an advanced VLSI project focused on implementing FIR filter architectures with reduced-complexity parallel processing techniques.

## Repository Structure

- **Project 1: Filter Architectures**
  - **Reduced-complexity parallel processing L=2**
    - Contains Verilog designs, test benches, and simulation scripts for a two-level parallel processing FIR filter.
    - Includes a dedicated `VerilogFilterArchitectureDesign` folder with design files and output reports.
  - **Reduced-complexity parallel processing L=3**
    - Similar structure as L=2, but for a three-level implementation.
    - Also includes Python scripts for processing coefficients and generating simulation parameters.
  - **Unquantized Coefs Comparison**
    - Contains MATLAB scripts for frequency graph comparisons.
    - Python scripts and header files for handling unquantized coefficients.

## Key Components

- **Verilog Design Files**
  - Multiple levels of parallel processing designs (L=2, L=3) implemented in SystemVerilog.
  - Test bench files to validate the filter functionality.
  
- **Python Scripts**
  - Scripts for generating and processing filter coefficients.
  - Tools for quantization and comparison of coefficients.
  
- **MATLAB Scripts**
  - Used for comparing unquantized and quantized coefficients through graphical analysis.
  
- **Output Files and Databases**
  - Design and synthesis reports, along with incremental database files generated during the design process.

## Getting Started

1. **Simulation and Synthesis:**
   - Use your preferred Verilog simulator to run the test benches provided in the respective project folders.
   - Synthesis tools may be required to work with the design databases and reports.

2. **Python Scripts:**
   - Navigate to the corresponding Python Scripts directory (found in both L=3 and Unquantized Coefs Comparison folders) to process filter coefficients.
   - Ensure you have the necessary Python environment configured.

3. **MATLAB Analysis:**
   - Open MATLAB and run the provided scripts in the Unquantized Coefs Comparison/MATLAB folder to visualize the frequency response and compare coefficients.

## Prerequisites

- **Verilog/SystemVerilog Simulator:** For simulation of the FIR filter designs.
- **Synthesis Tools:** Such as Quartus or Vivado, if synthesis is required.
- **Python 3.x:** Along with necessary libraries (e.g., NumPy) for running the coefficient scripts.
- **MATLAB:** For executing the analysis scripts.


## GitHub as a Portfolio
This repository is structured to showcase:
- **Clear Documentation**: Technical trade-offs, visualizations, and reproducible results.
- **Modular Code**: Parameterized Verilog for scalability.
- **Professionalism**: Concise explanations, adherence to specs, and critical analysis.

🔗 **Live Demo**: [GitHub Pages](https://github.com/PaulNation/Advanced-VLSI-Project-REPO)  
📧 **Contact**: nievep@rpi.edu