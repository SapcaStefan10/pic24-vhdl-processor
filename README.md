# PIC24 VHDL Processor Architecture

A complete 16-bit processor design based on the **PIC24** architecture, implemented in **VHDL** and verified using **Xilinx ISE** and **ModelSim**.

---

## 📌 Overview
This project presents the hardware implementation of a custom 16-bit micro-architecture. It includes a modular design containing a functional Arithmetic Logic Unit (ALU), a Control Unit for instruction decoding, internal register management, memory control logic, and dedicated testbenches for simulation verification.

---

## 🛠️ Architecture & Main Modules

The repository contains the following core hardware components:

* **ALU (`ALU.vhd`):** Implements arithmetic operations, bitwise logic functions, and hardware flag generation (Zero, Carry, Negative, Overflow).
* **Control Unit (`ctrl.vhd`):** Decodes instruction opcodes and controls execution flow and internal data routing.
* **Register File (`File_Regs.vhd`):** Manages read/write access to internal general-purpose registers.
* **Memory Modules (`DataMem.vhd`, `ROM32x24.vhd`):** Handles data memory operations and program memory instruction fetches (`ROM_C`, `ROM_N`, `ROM_OV`, `ROM_Z`, etc.).
* **Program Counter & Flow (`ProgCnt.vhd`, `PC_Update.vhd`):** Updates and maintains instruction pointers based on jumps, branches, and sequential execution.
* **Multiplexers (`MUX2V16.vhd`, `MUX_Reg_Dest.vhd`):** Route data paths dynamically between ALU, registers, and memory.

---

## 🧪 Simulation & Testing
Verification was performed via testbenches in ModelSim to validate functional correctness across instruction cycles:

* `tb_PIC24_ALL.vhd` – Full-system integration testbench.
* `tb_PIC24_SPECIFIC.vhd` & `tb_PIC24_Z.vhd` – Targeted instruction and flag verification testbenches.

---

## 🔧 Tools & Environment
* **Language:** VHDL
* **Synthesis & Implementation:** Xilinx ISE
* **Simulation & Waveform Analysis:** ModelSim
