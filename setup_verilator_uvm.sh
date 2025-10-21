#!/bin/bash
# -----------------------------------------------------------------------------
# setup_verilator_uvm.sh
#
# MIT License
# 
# Copyright (c) Jayaraman R P  
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
# -----------------------------------------------------------------------------


set -e  # Exit on error
set -o pipefail

# Step 0: Check for required system tools
for cmd in python3 git pip; do
    if ! command -v $cmd &> /dev/null; then
        echo "Error: $cmd not found. Please install it first."
        exit 1
    fi
done

echo "=== Step 1: Creating Python virtual environment ==="
python3 -m venv verilator_venv
source verilator_venv/bin/activate

echo "=== Step 2: Installing Python dependencies ==="
pip install --upgrade pip

# Install Verilator Python wrapper (pyverilator)
pip install verilator

# Check if verilator is installed properly (via pip, this may not be system-wide verilator)
echo "=== Step 3: Checking Verilator version ==="
if verilator --version &>/dev/null; then
    verilator --version
    echo "✅ Verilator is installed."
else
    echo "❌ Verilator not found or failed to install. Check your installation."
    exit 1
fi

# Step 4: Clone the repos
echo "=== Step 4: Cloning Git repositories ==="

# Clone RTL2UVM
if [ ! -d "RTL2UVM" ]; then
    git clone https://github.com/rpjayaraman/RTL2UVM.git
fi

echo "=== Step 5: Installing Python modules for RTL2UVM ==="

pip install pyslang argparse tabulate google.generativeai pygraphviz

# These modules are part of the standard library, so no pip install required:
# re, logging, os, shutil, time

echo "✅ All Python modules installed."

echo "=== Step 6: Running rtl2uvm.py ==="

cd RTL2UVM

if [ -f "sample_dut.sv" ]; then
    python rtl2uvm.py -t sample_dut.sv -m verilator
else
    echo "⚠️  sample_dut.sv not found in RTL2UVM directory. Please provide the RTL file."
fi

echo "=== Step 7: Running Verilator ==="
cd sample_dut_verilator

start_time=$(date +%s)

make all

end_time=$(date +%s)
runtime=$((end_time - start_time))

echo "🕒 Verilator-UVM run completed in ${runtime} seconds."

echo "🎉 Verilator+UVM installed and Ran successfully!"

