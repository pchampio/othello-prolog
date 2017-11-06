# Othello Prolog

> A fully functional [Othello game](https://en.wikipedia.org/wiki/Reversi), made for the [swi prolog interpreter](http://www.swi-prolog.org/)

<p align="center">
  <a href="https://raw.githubusercontent.com/Drakirus/Sudoku/master/screen.png">
    <img alt="ScreenShot~ prompt" src="./demo.gif">
  </a>
</p>

## Overview

This app allows 2 players to play an Othello game.

> During de pre-game menu the admin can set the 2 players to be ether a human or
> a AIs
>
>
> `-- Set the Player x to be a --`  
>  `1. Human`  
>  `2. Bot (random)   `    ---> A totally random AI. [random.pl](./ai/random.pl)  
>  `3. Bot (minmax)   `    ---> An AI using the min-max algorithm. [minmax.pl](./ai/minmax.pl)  
>  `4. Bot (alphabeta)` ---> An AI using the alpha-beta algorithm. [alphabeta.pl](./ai/alphabeta.pl)

## Things about this implementation

### Heuristic/Evaluation Function 

I used [this](https://courses.cs.washington.edu/courses/cse573/04au/Project/mini1/RUSSIA/Final_Paper.pdf)
excellent heuristic/evaluation function made by some researchers from University of Washington.

This heuristic function is actually a collection of several heuristics
and calculates the utility value of a board position by assigning
different weights to those heuristics.  

These heuristics take into account:

  - The coin parity [here](https://github.com/Drakirus/othello-prolog/blob/05cecc989db8e5ec041380c2ba5f77377fa3f524/ai/heuristic.pl#L22-L34)
  - The mobility [here](https://github.com/Drakirus/othello-prolog/blob/05cecc989db8e5ec041380c2ba5f77377fa3f524/ai/heuristic.pl#L37-L72)
  - The stability [here](https://github.com/Drakirus/othello-prolog/blob/05cecc989db8e5ec041380c2ba5f77377fa3f524/ai/heuristic.pl#L22-L34)
  - corners-captured [here](https://github.com/Drakirus/othello-prolog/blob/05cecc989db8e5ec041380c2ba5f77377fa3f524/ai/heuristic.pl#L22-L34)


### Performance
To ensure the best **performance** and improve the **bot playing** time he Game Engine use [cache.pl](./utils/cache.pl) system.
