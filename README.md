# Xenos Project v.1
#### Video Demo:  [Watch here](https://www.youtube.com/watch?v=5o_Xc60hjsQ)

#### Description:
Xenos Project is a handcrafted, self-drawn 2D isometric arena-style game developed using Lua and the Love2D game engine. This game features a wave-based survival mode where players face increasingly challenging waves of enemies. The project leverages Keyslam's workspace template for organization and efficiency.

The game structure is meticulously divided into separate files for ease of maintenance and readability. Each file has a clear purpose and follows a naming convention that ensures functions and variables are self-explanatory. This approach minimizes the need for excessive comments, promoting clean and elegant code. However, comments are used judiciously where necessary to enhance understanding.

The `main.lua` file is designed to contain only a few local variables, with most global variables defined here. It delegates the bulk of the functionality to specific functions located in separate files. This modular approach facilitates easier maintenance, tweaking, debugging, and balancing by avoiding hardcoded numbers and instead using variables defined at the top of the scripts.

- **audio.lua**: This file loads all game audio in a single function, which is called during `love.load`. This centralized approach ensures all audio assets are managed consistently.
- **images.lua**: Similar to `audio.lua`, this file handles the loading of all images, including logic for sprite frame loading.
- **player_behavior.lua**: Manages all player-related functions, such as movement, attacks, sprite updates based on player status, and interactions with other entities.
- **goblin_behavior.lua**: Handles goblin-related functions, including respawning and item drops.
- **misc.lua**: Manages miscellaneous logic, such as drawing hitboxes on keypress, handling game boundaries, applying damage effects, managing enemy waves, collision detection, and drawing non-player/enemy sprites.

Enemies and drops are organized into tables and iterated upon within functions, treating each as a separate entity even though they share the same spawning code. Significant effort has been invested in making the code aesthetic, modular, and tidy, paving the way for future modifications and additions.

#### Gameplay:
Controls:
- **WASD**: Movement
- **Mouse Click**: Attack
- **Space**: Dodge (with cooldown)
- **K**: Enter debug mode (currently displays hitboxes)

The game features endless waves of enemies, with the number and spawn rate tied to the wave number. Each wave's start is displayed on-screen, challenging players to survive and defeat as many enemies as possible. The dodge mechanic adds a strategic element, allowing players to escape danger or engage aggressively, but it comes with a cooldown and a visual indicator (an anime-esque drop of sweat on the character's head).

#### Installation:
To install and run the Xenos Project, follow these steps:

1. **Prerequisites**:
   - Ensure you have [Love2D](https://love2d.org/) installed on your system.

2. **Steps**:
   1. Clone the repository:
      ```bash
      git clone https://github.com/yourusername/xenos-project.git
      ```
   2. Navigate to the project directory:
      ```bash
      cd xenos-project
      ```
   3. Run the game using Love2D:
      ```bash
      love game
      ```
Alternatively, executables are located within the /game/makelove-build folder

#### Configuration:
Configuration settings are minimal and primarily handled through variables defined at the top of each script. These settings allow for easy adjustment of game parameters such as player speed, enemy spawn rates, and audio volume.

#### Contributing:
We welcome contributions from the community. If you wish to contribute, please follow these guidelines:

1. Fork the repository.
2. Create a new branch (`git checkout -b feature/your-feature`).
3. Commit your changes (`git commit -m 'Add some feature'`).
4. Push to the branch (`git push origin feature/your-feature`).
5. Open a pull request.

Please adhere to the coding standards and conventions outlined in the repository.

#### License:
This project is licensed under the MIT License. See the `LICENSE` file for details.

#### Authors and Acknowledgements:
- **Kacper Kubiak** - Developer
- **Special Thanks**:
  - Jay, for the countless hours spent together in the world we built and the tears we shed.
  - Keyslam, for the invaluable workspace template and support.

#### FAQ:
**Q: What inspired the Xenos Project?**
A: The project was inspired by a fantasy-esque text-based role-play and will further be developed as a side hobby. The original version started as a CS50 final project.

**Q: Where can I find the assets used in the game?**
A: The audio assets are sourced from Pixabay, and the sprites are self-drawn using Piskelapp.

**Q: How can I get help or support?**
A: For support, please contact us at [marcuskolvador@gmail.com](mailto:marcuskolvador@gmail.com).

#### Extra Info:
Xenos Project is a passion project that will continue to evolve as a side hobby beyond its current scope. The game uses open-source audio from Pixabay.com and self-drawn sprites created with Piskelapp.com. The project's structure and environment are based on Keyslam's VSCode Game Template.

#### Roadmap:
Future development plans include:
- Introducing new enemy types with unique behaviors.
- Adding power-ups and special abilities for the player.
- Implementing a scoring system and leaderboards.
- Enhancing graphics and sound effects for a more immersive experience.

Stay tuned for updates and new features as the project progresses.

#### Changelog:
### [Version 1.0] - 2024-12-06
- Initial release with basic gameplay mechanics, including movement, attacks, dodging, and wave-based enemy spawning.
- Debug mode with hitbox display.
