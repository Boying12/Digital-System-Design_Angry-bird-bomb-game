# Digital-System-Design_Angry-bird-bomb-game
📌 Overview

This project implements a hardware-based Angry Birds game using digital system design concepts. The system integrates multiple input/output peripherals, including switches, push buttons, keyboard input, LEDs, seven-segment displays, and a graphical screen interface, to create an interactive gameplay experience .

The design is implemented on an FPGA platform and demonstrates the integration of control logic, datapath design, and real-time display generation.

⚙️ System Architecture

The system is composed of the following key modules:

Input Control Module
Handles switches, push buttons, and keyboard inputs
Decodes user commands (bird selection, launch control, direction)
Game Control Unit (FSM)
Controls game states (idle, setup, launch, motion, result)
Manages level transitions and win/lose conditions
Datapath / Motion Engine
Computes bird trajectories
Updates object positions on each clock cycle
Handles collision detection
Display Module
Grid-based rendering system (coordinate mapping)
Outputs game state to screen
Output Control
Seven-segment display → game info (level, height, remaining birds)
LED → win/lose indication (different blinking patterns)
🎯 Game Features
Level 1
Select bird type (Red / Fast)
Adjustable launch height
Red bird:
Parabolic-like motion (up then down)
Fast bird:
Horizontal motion with constant speed
Collision detection:
Stops when hitting obstacle, pig, or boundary
Win condition:
Clear all obstacles before birds run out
Level 2
Additional bird types (including Bomb bird)
Direction control (horizontal / vertical)
Bomb bird:
Explodes and clears surrounding area (3×3 grid)
Resource management:
Remaining birds displayed on seven-segment
Special rule:
Hitting the crown pig → instant win
🎮 Input / Output Mapping
Inputs
Switches
Level selection
Bird type / quantity
Launch direction (Level 2)
Push Buttons
Adjust launch height / position
Launch trigger
Reset
Keyboard
Bird selection (R / Y / B)
Outputs
Seven-Segment Display
Level
Launch height / direction
Remaining birds
LED
Win → continuous blinking
Lose → one cycle then off
Screen
2D grid-based game map (real-time updates)
🧠 Design Concepts

This project demonstrates several key digital design concepts:

Finite State Machine (FSM) design
Synchronous sequential logic
Datapath and control separation
Real-time system behavior (clock-driven updates)
Hardware-based game logic implementation
Peripheral integration on FPGA
🛠️ Implementation
Language: Verilog
Platform: FPGA
Design Flow:
Functional design (FSM + datapath)
Simulation and verification
Hardware implementation
FPGA demo validation
📊 Key Challenges
Synchronizing multiple input sources
Designing flexible trajectory logic for different birds
Implementing collision detection in hardware
Managing real-time display updates
Balancing complexity and hardware resource usage
🚀 Future Improvements
More levels and map variations
Enhanced physics model
Sound effects integration
Improved UI/UX on display
Optimization for timing and area
