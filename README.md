# Advanced VLSI Project Repository

This repository contains the source code, design files, and scripts for an advanced VLSI projects focused on implementing FIR filter architectures with reduced-complexity parallel processing techniques.

## Repository Structure

- **Project 1: Filter Architectures (102 Taps)**
  - **Fully Pipelined FIR Filter**
    - Contains Verilog designs, test benches, and simulation scripts for a Fully Pipelined FIR Filter
  - **Reduced-complexity parallel processing L=2**
    - Contains Verilog designs, test benches, and simulation scripts for a two-level parallel processing FIR filter.
    - Also includes Python scripts for doing polyphase decomposition processing and generating taps parameters.
  - **Reduced-complexity parallel processing L=3**
    - Similar structure as L=2, but for a three-level implementation.
    - Also includes Python scripts for doing polyphase decomposition processing and generating taps parameters.
  - **Reduced-complexity parallel processing L=3 and Fully Pipelined**
    - Copies the coeficients from the Reduced-complexity parallel processing L=3 Design
  - **Unquantized Coefs Comparison**
    - Contains MATLAB scripts for frequency graph comparisons.
    - Python scripts and header files for handling unquantized coefficients.
  - **Noisy Sine Input Generator**
    - Contains MATLAB scripts for Noisy 1 kHz Sinewave in unsigned 16 bit representation for test bench input
    - Outputs graph comparisons between noisy and non-noisy sinewave


## Key Components

- **Verilog Design Files**
  - Multiple levels of pipelined and parallel processing designs (L=2, L=3) implemented in SystemVerilog.
  - Test bench files to validate the filter functionality.
  
- **Python Scripts**
  - Scripts for processing filter coefficients.
  - Tools for quantization of coefficients.
  - Tools for Polyphase Decomposition
  
- **MATLAB Scripts**
  - Mainly used to generate filter coefficients.
  - Used for comparing unquantized and quantized coefficients through graphical analysis.
  
- **Output Files and Databases**
  - Design and synthesis reports, along with incremental database files generated during the design process.

## Getting Started

1. **Simulation and Synthesis:**
   - Use your preferred Verilog simulator to run the test benches provided in the respective project folders. (I used ModelSim-Altera)

2. **Python Scripts:**
   - Navigate to the corresponding Python Scripts directory (found in L=3,L=2,Pipelined, and Unquantized Coefs Comparison folders) to process filter coefficients if they are not already downloaded.
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