
- [x] Implement a working sound manager that allows adding, playing and stopping sounds without manually using raylib functions for sounds.
    - [x] Implement indexing a map or something that is like a dict in zig using strings instead of i32 for acquiring a specific sound that is inside of that storage.
    - [x] Add error handling for adding sounds that already exists in the storage, and then also for if the name isnt in the storage then error out.


- [ ] Implement another lose state wherein it combines both the current lose state and the one where the player would lose when they catches bad apples in gray.
    - [ ] In addition, add a powerup system wherein golden apples have a chance to fall, and would grant the player's 5 additional points.

- [ ] Add a working win state wherein the player was able to catch amount of apples at the alloted time limit.
- [ ] Based on the current game state, Implement a working state management wherein there's the seemless switch between main-menu, play state, pause menu and game over states.
    - [ ] First Improve upon the current game over screen and allow the player's to retry the game or back to the main menu.
