# 487-Final-Project

# Project Name: Snake Game

## Project Description
This project implements an engaging game on the Nexys A7 FPGA board where the player controls a snake to collect as many points as possible within a limited time. The character, maneuvered using push buttons or switches, traverses a 2D field displayed on a VGA screen. Points are randomly generated at different locations across the game field, challenging the player to move around and collect them before the timer runs out. The system employs a finite state machine to handle the player's movements, game state, and scoring logic. An algorithm ensures that points appear in unpredictable areas. As the player accumulates points, the score is dynamically updated and displayed onscreen, providing real-time feedback on progress. The game's visual and audio feedback, coupled with the random distribution of points, ensures an exciting and immersive experience for the player.

. The game utilizes various peripherals of the Nexys board to create a fully interactive experience. The required external components include:
- VGA Connector: To display the game on a monitor.
- Speaker Module: To output sound effects when the snake eats an apple or the game ends.

### Block Diagram / Finite State Machine Diagram
The finite state machine (FSM) governing the game's movement operates through a series of well-defined states that control the character's movement. The FSM begins in the Reset state, which initializes the game by placing the character in its starting position and setting the game to Paused mode. In this mode, the game awaits player input. Once any of the directional controls (push buttons or switches) are pressed, the FSM transitions to the corresponding movement state: Up, Down, Left, or Right, allowing the player to navigate the character across the game field. Each movement state updates the character's position accordingly, and after 30 seconds of playtime, the FSM reverts to the Paused state. This cycle continues until the player manually resets the game, which brings the FSM back to the Reset state, restarting the gameplay. The use of these clearly defined states ensures smooth character movement while providing periodic pauses to increase the game's challenge and pace.

### High-Level System Description
The system includes the following major components:
1. **VGA Controller**: Manages the display output to the VGA monitor.
2. **Random Number Generator**: Provides random positions for apples on the game board.
3. **Snake Logic**: Controls the movement    of the snake.

## Steps to Implement
### Vivado Project Setup
1. **Clone the Repository**
2. **Open Vivado**:
   - Load the project file
   - Ensure the Nexys board is properly connected.
3. **Build and Run**:
   - Compile the project and upload it to the Nexys board.
   - Monitor the output on the connected VGA display.

### Nexys Board
1. **Input Configuration**: Directional buttons configured to control snake direction.
2. **Output Configuration**: VGA output configured through the `vga_sync.vhd` module.
3. **Constraints File Configuration**:
   - Map game control buttons to specific FPGA pins in the `.xdc` file.

## Inputs and Outputs
Inputs:

Push Buttons/Switches: Used to control the movement of the character across the game field. For instance, each button corresponds to a direction (up, down, left, right) that allows players to maneuver the character to collect points.
Reset Button: Resets the game to its initial state, clearing the score and repositioning the character at the starting point.
Outputs:

VGA Display: Displays the 2D game field on the screen, including the character, randomly generated points, and the current score.
### Project Demonstration
#### Images


#### Videos
##### Device
https://drive.google.com/file/d/1eKQDRKHWZ2DkjqVYu7lID2pMoXg0rC8x/view?usp=sharing
##### Screen
https://drive.google.com/file/d/1SSnZ8U67tuGP3ZttloGeoLAvMOxmJnI0/view?usp=sharing
## Modifications
### Pong Lab
We got inspired for this project based on lab 6 pong game. We implemented our own system for character movement, updating the ball and bat concept. Instead of hitting a ball, players can now navigate a character around a field and gather randomly generated points. Furthermore, we expanded the functionality of the original VGA driver by including new graphical components on the game field, such as a timer, scoring display, and random point generating. In addition, we modified the Pong's original finite state machine architecture, which controlled scoring and other movement states, to allow it to support additional modes unique to this particular game, such the pause state. 

## Summary of Process
### Team Contributions
-  Focused on VGA output and synchronization.
-  Developed the snake logic and game controls.

### Timeline of Work
1. **Week 1**: Initial setup and basic VGA display.
2. **Week 2**: Integrated snake logic and input handling.

### Challenges and Solutions
1. **Challenge**: Difficulty in synchronizing the VGA refresh rate.
   - **Solution**: Adjusted the timing parameters in `vga_sync.vhd`.

2. **Challenge**: Random number generator was not producing expected randomness.
   - **Solution**: Modified the `rng.vhd` logic to improve randomness.

## Source Code
All source code is provided in organized `.vhd` and `.xdc` files:
- `apple_n_snake.vhd`
- `vga_sync.vhd`
- `snake.vhd`
- `rng.vhd`


Each file is commented thoroughly to explain its function and structure.
