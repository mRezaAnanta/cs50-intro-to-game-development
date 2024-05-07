TODO:

- Add a `Powerup` class to the game that spawns a powerup (images located at the bottom of the sprite sheet in the distribution code). This `Powerup` should spawn randomly, be it on a timer or when the Ball hits a `Block` enough times, and gradually descend toward the player. Once collided with the `Paddle`, two more `Ball`s should spawn and behave identically to the original, including all collision and scoring points for the player. Once the player wins and proceeds to the `VictoryState` for their current level, the `Ball`s should reset so that there is only one active again.
-
