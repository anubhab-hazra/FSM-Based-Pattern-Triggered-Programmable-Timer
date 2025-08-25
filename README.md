# FSM-Based Pattern-Triggered Programmable Timer

This project implements a **programmable digital timer** in **Verilog HDL**, built step by step from smaller modules into a complete design.  
It demonstrates the integration of **finite state machines (FSMs)**, **sequence detection**, **shift registers**, and **counters** to achieve a configurable delay mechanism.

---

## Project Overview
The timer works as follows:

1. **Pattern Detection**  
   - Listens to the serial input stream.  
   - Starts when the bit-sequence **`1101`** is detected.  

2. **Programmable Delay Input**  
   - After the start sequence, shifts in **4 bits (MSB first)**.  
   - These 4 bits represent `delay[3:0]`, which determines the timer duration.  

3. **Counting Phase**  
   - The FSM asserts the `counting` signal.  
   - Counts for exactly **(delay + 1) × 1000 clock cycles**.  
     - Example: `delay=0` → 1000 cycles  
     - Example: `delay=5` → 6000 cycles  
   - The output `count[3:0]` shows the remaining delay value:  
     - `delay` for 1000 cycles  
     - `delay-1` for the next 1000 cycles  
     - … until reaching `0`.  

4. **Completion & Acknowledgement**  
   - Asserts `done` to indicate timeout.  
   - Waits for user acknowledgment via the `ack` signal.  
   - Resets to idle, ready to detect the next **`1101`** sequence.  

---

## Key Features
- ✅ Sequence detection FSM (`1101`)  
- ✅ Shift register for programmable delay loading  
- ✅ Down counter with 1000-cycle granularity  
- ✅ Countdown output (`count[3:0]`)  
- ✅ Done/acknowledgment handshake for controlled restart  
- ✅ Fully synchronous design with reset  

---

## Project Structure
- **Shift Register (Component 1):** Serial load & decrement logic  
- **Sequence Detector FSM (Component 2):** Detects `1101` pattern  
- **FSM Delay Control (Component 3):** Enables shifting for 4 cycles  
- **Integrated FSM Controller (Component 4):** Controls shifting, counting & done states  
- **Final Timer (Component 5):** Full design combining all modules  

---

## Applications
- Digital stopwatch/timer units  
- Configurable delay circuits  
- Introductory **FSM + counter design** project for learning Verilog  

