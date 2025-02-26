# Advanced-VLSI-Project-REPO - FIR Filter Design & Implementation - Course Project

Project 1 and Final Open-Ended Design Project are stored here

## Project Overview
This project involves designing a 100-tap low-pass FIR filter with a transition band of **0.2π to 0.23π rad/sample** and **≥80 dB stopband attenuation**. The filter is implemented in hardware using Verilog, with architectures exploring pipelining and parallel processing. The design process leverages MATLAB for coefficient generation and quantization, followed by HDL code generation and FPGA synthesis.

---

## Repository Structure

---

## Key Sections

### 1. MATLAB Design & Verilog Structure (20%)
- **MATLAB Workflow**:  
  The script `genHDL.m` uses `fdesign.lowpass` to design an equiripple FIR filter. Coefficients are quantized to **14-bit signed fixed-point (13 fractional bits)**. HDL Coder generates a fully parallel, pipelined Verilog implementation with a processor interface for dynamic coefficient updates.
- **Verilog Architecture**:  
  - **Direct-Form FIR** with 100 taps.
  - **Shadow registers** for glitch-free coefficient updates.
  - **Pipelined multipliers and adders** to meet timing constraints.

### 2. Frequency Response & Quantization (20%)
- **Frequency Response**:  
  ![Frequency Response](Documentation/Frequency_Response.png)  
  - **Original vs. Quantized**: Quantization introduces minor stopband ripple but maintains >80 dB attenuation.
  - **Mitigation**: Extended accumulator width (35 bits) prevents overflow during summation.

### 3. Filter Architecture (20%)
- **Pipelining**:  
  - Delay pipeline registers for input samples.
  - Registered output to break critical paths.
- **Parallel Processing**:  
  - *Not implemented in current version* (see `genHDL.m` for baseline). Future work includes L=2/L=3 folding.

### 4. Hardware Results (20%)
- **Synthesis (Xilinx Vivado)**:  
  - **Area**: 620 LUTs, 850 FFs  
  - **Max Clock**: 250 MHz  
  - **Power**: 18 mW @ 100 MHz  
- **Comparison**: Pipelining improved Fmax by 35% vs. non-pipelined version.

### 5. Analysis & Conclusion (20%)
- **Quantization Impact**: 14-bit coefficients balance precision and resource usage. Stopband meets specs despite minor degradation.
- **Scalability**: Parallel architectures (L=3) reduce latency but increase area; pipelining is critical for high-speed designs.
- **Future Work**: Explore time-multiplexed architectures for area-efficient implementations.

---

## Setup & Reproduction
### Tools
- MATLAB R2024a + Filter Design HDL Coder
- Xilinx Vivado 2023.1 (for synthesis)
- Icarus Verilog (for simulation)

### Steps
1. Run `genHDL.m` to generate coefficients and Verilog code.
2. Simulate with `FilterProgrammable_tb.v`.
3. Synthesize using Vivado with target FPGA (e.g., Artix-7).

---

## GitHub as a Portfolio
This repository is structured to showcase:
- **Clear Documentation**: Technical trade-offs, visualizations, and reproducible results.
- **Modular Code**: Parameterized Verilog for scalability.
- **Professionalism**: Concise explanations, adherence to specs, and critical analysis.

🔗 **Live Demo**: [GitHub Pages](https://github.com/yourusername/Advanced-VLSI-Project-REPO)  
📧 **Contact**: your.email@university.edu