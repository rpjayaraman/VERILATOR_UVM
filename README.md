# 🚀 Verilator + UVM Automation Script

This project provides an automated setup for integrating [Verilator](https://www.veripool.org/verilator/) with the UVM using [RTL2UVM](https://github.com/rpjayaraman/RTL2UVM) framework. It prepares a Python environment, installs dependencies, and runs a sample DUT through UVM generation and Verilator simulation.

---

## 📋 Features

- Creates a Python virtual environment
- Installs all required Python packages
- Installs the Verilator
- Clones the RTL2UVM repository
- Converts a sample SystemVerilog module into a UVM testbench
- Runs Verilator simulation using generated code

---

## 🛠️ Requirements

Make sure the following tools are installed **system-wide** before running the script:

- `python3`
- `pip`
- `git`
- `make`
- `verilator` (system-wide installation is required for simulation)
- C++ compiler (`g++`)
- `graphviz` and related libraries for `pygraphviz`

---

## 📦 Installation & Usage

 **Clone this repository**
   ```bash
   git clone https://github.com/rpjayaraman/VERILATOR_UVM/
   cd VERILATOR_UVM/
```
   
Make the script executable

```bash
chmod +x setup_verilator.sh
Run the script
```

📂 Project Structure After Setup

```bash
├── setup_verilator_uvm.sh        # Main setup script
├── verilator_venv/               # Python virtual environment
├── RTL2UVM/                      # Cloned RTL2UVM repo
│   ├── sample_dut.sv             # Sample DUT (SystemVerilog)
│   ├── rtl2uvm.py                # UVM generator
│   └── sample_dut_verilator/    # Generated Verilator-compatible files
│       ├── Makefile
│       └── obj_dir/ (output files)
```

### 🧪 Running Your Own RTL Design
Replace the sample_dut.sv file inside the RTL2UVM/ directory with your own RTL module, and rerun the relevant steps (or modify the script accordingly).

```bash

cp your_module.sv RTL2UVM/sample_dut.sv
cd RTL2UVM
python rtl2uvm.py -t sample_dut.sv -m verilator
cd sample_dut_verilator
make all
```

📌 Python Dependencies
Installed automatically by the script:

verilator

pyslang

argparse

tabulate

google.generativeai

pygraphviz

System Python libraries used (no need to install):

os, shutil, time, re, logging
