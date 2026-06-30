# Parking System Controller (FPGA – VHDL)

Password-protected parking lot controller implemented in VHDL and tested on a **Nexys A7-100T (Artix-7)** FPGA.

## Overview
Tracks vehicle entry/exit, manages 15 parking spaces, and only allows entry after a correct password is verified. Status is shown on a 7-segment display and LEDs.

## Features
- Password-gated entry using 4 switches (SW0–SW3)
- Occupancy counter (0–15) with full-lot protection
- 7-segment display: rightmost digits = available spaces, leftmost = `A` (accepted) / `E` (wrong password)
- LED status indicators
- Debounced push buttons (entry, exit, reset, verify)

## Controls
| Button | Function |
|--------|----------|
| BTNU | Entry |
| BTND | Exit |
| BTNC | Reset |
| BTNL | Verify password |

## LEDs
| LED | Meaning |
|-----|---------|
| LED0 | Space available |
| LED1 | Parking full |
| LED2 | Password accepted |
| LED3 | Password rejected |

## How It Works
1. Set the password on SW[3:0] and press **BTNL** to verify.
2. Correct code → display shows `A`, entry enabled for one vehicle.
3. Wrong code → display shows `E`, entry blocked.
4. **BTNU** registers entry (only after verification), **BTND** registers exit.
5. Available spaces = 15 − occupied, shown live on the display.

## Hardware
- Nexys A7-100T (Artix-7 XC7A100T)
- 100 MHz on-board clock
- Push buttons, switches, LEDs, 7-segment display
- Custom PCB concept (in progress, Altium)


## Status
Simulated, synthesized, implemented, and tested on hardware. PCB design in progress.

## Team
- Muhammad Umar Hayat
- Jaleel Ur Rehman
- Efty
- Zulkar Nain Sayeed

## Course
Hardware Engineering Lab – SS 2026
Supervisor: Prof. Dr.-Ing. Ali Hayek

