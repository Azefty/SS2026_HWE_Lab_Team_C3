#  Park System Controller (FPGA - VHDL)

## Project Overview
This project implements a **digital parking lot management system** using **VHDL on an FPGA**. It simulates real-world parking behavior by tracking vehicle entry and exit, managing available spaces, and controlling access when the lot is full.


---

##  Objectives
- Design a parking management system in VHDL
- Implement on **Nexys A7 FPGA (Artix-7)**
- Simulate entry/exit using push buttons
- Track spaces using a **4-bit counter (0–15)**
- Display available spaces on **7-segment display**
- Use LEDs for status indication
- Implement **FSM (Finite State Machine)** control logic
- Develop a **custom PCB** for hardware realization

---

##  System Description

###  Entry Process
- Counter increments
- Display updates available spaces
- Green LED = ON (entry allowed)
- If full → entry blocked

###  Exit Process
- Counter decrements
- Display updates
- If previously full → entry re-enabled

###  Reset
- Counter resets to zero
- System returns to initial state

---

## Architecture

### Main Modules
1. **Control Unit (FSM)**
   - States: `Idle`, `Entry`, `Exit`, `Full`, `Reset`

2. **Counter / Datapath**
   - 4-bit up/down counter (0–15)
   - Overflow/underflow protection

3. **I/O Module**
   - Button debouncing
   - 7-segment display driver
   - LED control

---

## Inputs & Outputs

### Inputs
- Entry button
- Exit button
- Reset button
- Clock (100 MHz)

### Outputs
- 7-segment display (available spaces)
- Green LED (space available)
- Red LED (lot full)
- Optional gate status LED

---

## Hardware Components
- FPGA Board: **Nexys A7 (Artix-7 XC7A100T)**
- Push buttons (Entry, Exit, Reset)
- LEDs (Green, Red)
- 7-segment display
- On-board clock (100 MHz)
- Custom PCB (optional)

---

## Working Principle
The system manages up to **15 parking spaces**:
- Entry increases occupancy
- Exit decreases occupancy
- When full:
  - Red LED ON
  - Entry disabled
- When space frees:
  - Green LED ON
  - Entry enabled

---

## Team Members
- Muhammad Umar Hayat
- Jaleel Ur Rehman
- Efty
- Zulkar Nain Sayeed

---

## Course Info
**Hardware Engineering Lab – SS 2026**  
Supervisor: Prof. Dr.-Ing. Ali Hayek

---

## Future Improvements
- Sensor-based automatic detection
- Mobile app integration
- Real-time monitoring dashboard
- Multi-level parking support
