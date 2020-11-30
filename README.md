# feup-plog-proj1<!-- omit in toc -->

## Class 2 T2_Three_Dragons_5<!-- omit in toc -->

- Fábio Miliano Prinsloo Moreira ([up201806296](mailto:up201806296@fe.up.pt))
- José Luís Sousa Tavares ([up201809679](mailto:up201809679@fe.up.pt))  

## Table of contents<!-- omit in toc -->
- [1. Installation and running](#1-installation-and-running)
- [2. The game: _Three Dragons_](#2-the-game-three-dragons)
  - [2.1. The board](#21-the-board)
  - [2.2. Gameplay](#22-gameplay)
    - [2.2.1. Gameflow](#221-gameflow)
    - [2.2.2. Variants](#222-variants)
    - [2.2.3. Gameplay notes](#223-gameplay-notes)
- [3. Game logic](#3-game-logic)
  - [3.1. Representation of the game state](#31-representation-of-the-game-state)
  - [3.2. Menus and visual representation of the state](#32-menus-and-visual-representation-of-the-state)
    - [3.2.1. The initial menu](#321-the-initial-menu)
    - [3.2.2. The authors menu](#322-the-authors-menu)
    - [3.2.3. The game mode menu](#323-the-game-mode-menu)
    - [3.2.4. The game menu and game state](#324-the-game-menu-and-game-state)
  - [3.3. List of valid moves](#33-list-of-valid-moves)
    - [3.3.1. Getting all player pieces](#331-getting-all-player-pieces)
    - [3.3.2. Computing valid moves](#332-computing-valid-moves)
    - [3.3.3. Final predicate](#333-final-predicate)
  - [3.4. Play execution](#34-play-execution)
    - [3.4.1. Capturing](#341-capturing)
    - [3.4.2. Dragon spawning](#342-dragon-spawning)
  - [3.5. End of game](#35-end-of-game)
  - [3.6. Board evaluation](#36-board-evaluation)
  - [3.7. Computer move](#37-computer-move)
    - [3.7.1. Easy mode](#371-easy-mode)
    - [3.7.2. Normal mode](#372-normal-mode)
    - [3.7.3. Computer capturing play variant](#373-computer-capturing-play-variant)
- [4. Conclusions](#4-conclusions)
- [5. Bibliography](#5-bibliography)

## 1. Installation and running

In order to run the game you must have *Sicstus Prolog 4.6* or higher installed in your computer. Having so, consult the main file `threeDragons.pl` and then call the predicate `play`.

1. Consult `threeDragons.pl` file.
```prolog
:- consult('threeDragons.pl').
```

2. Call the predicate `play`.
```prolog
:- play.
```

## 2. The game: _Three Dragons_

[_Three Dragons_](https://boardgamegeek.com/boardgame/306972/three-dragons) is a 2-player board game, created by [Scott Allen Czysz](https://drive.google.com/drive/folders/1xNoHSM08SChVW2TWtzU8Qje6m7hxrEYh), a board game designer. The game is inspired by ancient custodial capture board games, such as Tablut, with some differences:

1. The pieces have a related strength value. Only a stronger piece can capture a weaker piece;
2. There are three dragon caves in the board which allow players to get stronger pieces.

The latest version of the game is v0.40 released in 19th February 2020. The official Google Drive folder of the creator can be [accessed here](https://drive.google.com/drive/folders/1xNoHSM08SChVW2TWtzU8Qje6m7hxrEYh).

### 2.1. The board

The board consists a 9x9 square board with a mountain at each corner, three dragon caves in the middle row spaced with three squares, 8 white dices and 8 black dices (or any arbitrary color).

![initial-board](documentation/board.png)

### 2.2. Gameplay

#### 2.2.1. Gameflow

1. White move first.
2. At each turn the player must move a piece orthogonally any number of squares. Pieces may not overlap any mountain, dragon cave or game pieces.
3. A capture occurs when a player surrounds an opponent's piece on two opposite sides, or one player piece and a mountain or dragon cave. The enemy piece is removed.
4. The winner is declared when the opponent is reduced to only one piece.


#### 2.2.2. Variants

1. Capture by strength: occurs when the player move their piece to the side of a opponent's weaker piece. The opponent's piece is removed and the player's piece is weakened by 1 level.
2. Surrounding a dragon cave results in obtaining an extra playing piece (**summoning a dragon**). The side caves adds an extra 3 level piece to the player and the center cave an extra 5 level piece. 

#### 2.2.3. Gameplay notes

1. If a player moves their piece between two opponent pieces the piece **is not captured**.
2. It is only possible to obtain 3 dragons (1 for each cave).
3. The player can decide between a 'normal capture' or 'level capture'.
4. A player can capture multiple pieces with 'normal capture' but only one with 'level capture'.

## 3. Game logic

The following sections are going to explain how the game itself works and the logic behind its main predicates and state.

### 3.1. Representation of the game state

The game state is hold in a fact called `current_state(State)`. This state is responsible for storing useful information through out a player move.

The life cycle of a state at each player move consists in:

1. An initial play state. Where the state can be the initial state if the current play is the first one, or the previous state otherwise.
2. Mutation into multiple intermediate states, at the middle of each play the state is mutated into temporary valid states to perform board actions (piece moving, dragon spawning, etc...).
3. A final state. This state is obtained after performing all play actions having so a final valid state that is going to be used in the next play if the game does not end.

The game state of Three Dragons has information about the current player, the board, the cave state and the pieces count of each player.

```prolog
state(Player, Board, Caves, PiecesCount).
```

The `Player` is an atom that has two possible values: `white` and `black`.

The `Board` is a matrix which each element represents the piece in each row and column.

The `Caves` is a fact that holds the state of the three caves, from left to right. The initial state of `Caves` is `available_caves(true-true-true)`.

The `PiecesCount` is also a fact that holds the pieces count of both white and black pieces. The initial state of `PiecesCount` is `pieces_count(white-8, black-8)`. The pieces count are represented as a pair in order to improve readability.

### 3.2. Menus and visual representation of the state

The game has 4 menus: the initial menu, the authors menu, the game mode menu and the game menu.

#### 3.2.1. The initial menu

The initial menu allows the user to select an option to play the game or check the game implementation authors.

```
    Welcome to Three Dragons

    1. Play
    2. Authors
    3. Exit

Choose an option:
```

#### 3.2.2. The authors menu

The authors menu is self explanatory. It shows the authors names.

```
      Authors

- Fabio Moreira
- Luis Tavares
```

#### 3.2.3. The game mode menu

The game mode menu is accessed when `1. Play` is selected in the initial menu. This menu asks the user which game mode they want to play. The current game modes available are:

- Human vs Human
- Human vs Computer (easy)
- Human vs Computer (normal)
- Computer vs Computer

```
          Three Dragons
        Select a gamemode


    1. Human vs Human
    2. Human vs Computer (easy)
    3. Human vs Computer (normal)
    4. Computer vs Computer

Choose an option:
```

#### 3.2.4. The game menu and game state

The game menu is shown after a game mode is selected and after each human or computer move. This menu consists in a board with column and row indicators, the current player to play and the pieces count of each player. This information is obtained from the current state.

```
 | A  | B  | C  | D  | E  | F  | G  | H  | I  |
_______________________________________________
1| M  | B3 | B2 | B2 | B2 | B2 | B2 | B3 | M  |
_______________________________________________
2|    |    |    |    | B4 |    |    |    |    |
_______________________________________________
3|    |    |    |    |    |    |    |    |    |
_______________________________________________
4|    |    |    |    |    |    |    |    |    |
_______________________________________________
5| CA |    |    |    | CA |    |    |    | CA |
_______________________________________________
6|    |    |    |    |    |    |    |    |    |
_______________________________________________
7|    |    |    |    |    |    |    |    |    |
_______________________________________________
8|    |    |    |    | W4 |    |    |    |    |
_______________________________________________
9| M  | W3 | W2 | W2 | W2 | W2 | W2 | W3 | M  |
_______________________________________________

Player: white
Player pieces: white-8, black-8
```

Each player piece is represented by the initial letter of its name and the value of the piece. The mountains are represented as a `M` and the caves as `CA` if the cave is available and as `CE` if the cave is empty (*ie.,* if the cave was already used).

After showing the board if the current player is and human the game asks for a column and row and checks its integrity.

```
Select the piece to move...
Next move row: 9
Next move column: B
Select the position to move...
Next move row: 8
Next move column: B
```

In this case the piece `W3` of the example board above is going to be moved one row up.

There is a character validation predicate [`read_move(Position)` in `input.pl`] which assures that the position read is a valid position (checks bounds).

### 3.3. List of valid moves

The predicate `valid_moves(+GameState, +Player, -ListOfMoves).` computes all valid moves of a player. This predicate was implemented in two steps:

1. Get all player pieces.
2. For each piece compute valid moves.

The result of the predicate `-ListOfMoves` is a list of pairs `FromRow-FromColumn/ToRow-ToColumn`.

#### 3.3.1. Getting all player pieces

The predicate `findall_player_pieces(+Board, +Player, -Pieces).` is responsible for getting all player pieces. It calls the predicate `findall` with to check if the piece in the board is a piece of the `Player`.

```prolog
% Checks wther a piece belongs to a player in a certain position.
%
% is_player_piece(+Board, +Player, +Position)
is_player_piece(Board, Player, Position) :-
  get_element(Position, Board, Piece),
  piece(Piece, _, Player, _).

% Finds all the player pieces in the board.
%
% findall_player_pieces(+Board, +Player, -Pieces) 
findall_player_pieces(Board, Player, Pieces) :-
  findall(Position, is_player_piece(Board, Player, Position), Pieces).
```

#### 3.3.2. Computing valid moves

A move is valid if is not out of bounds, the from position is different from the to position, is orthogonally, and has no jumps (*ie.,* has no pieces in the path to its destination).

```prolog
% Gets a valid move.
%
% valid_move_to(+State, +Board, +Player, +From, -Move) 
valid_move_to(State, Board, Player, From, Row-Column) :-
  get_element(From, Board, Piece),
  is_piece_selectable(Piece, Player),
  gen(Row, Column),
  check_bounds(Row-Column),
  has_different_positions(From, Row-Column),
  is_valid_basic_move(From, Row-Column),
  move_no_jumping(State, From, Row-Column).
```

The predicate `gen(-Row, -Column).` generates all possible combinations of player positions in the board.

#### 3.3.3. Final predicate

Thus the final predicate `valid_moves(+GameState, +Player, -ListOfMoves).` computes all player pieces and then calls an helper predicate to compute all valid moves from a player piece.

```prolog
% Finds all valid moves.
%
% findall_valid_moves_to(+State, +Board, +Player, +From, -Moves)
findall_valid_moves_to(State, Board, Player, From, Moves) :-
  findall(From/To, valid_move_to(State, Board, Player, From, To), Moves).

valid_moves_helper(_, _, _, [], []).

% Iterates over a list to find valid moves.
%
% valid_moves_helper(+State, +Board, +Player, +Moves, -List)
valid_moves_helper(State, Board, Player, [H|T], List) :-
  findall_valid_moves_to(State, Board, Player, H, Moves),
  valid_moves_helper(State, Board, Player, T, List2),
  append(List2, Moves, UnsortedList),
  sort(UnsortedList, List).

% Gets all valid moves of a player.
%
% valid_moves(+State, +Player, -List)
valid_moves(State, Player, List) :-
  state(_, Board, _, _) = State,
  findall_player_pieces(Board, Player, Pieces),
  valid_moves_helper(State, Board, Player, Pieces, List).
```

### 3.4. Play execution

The play execution is divided in two steps: capture handling and cave handling. 

Note: A piece is only moved after being successfully validated. From now on, it is taken that at this point the piece is already validated and there is no need for extra validation.

After moving the piece to its final position it is necessary to compute its captures, if exist, and possible dragon spawning.

#### 3.4.1. Capturing

Getting the captures of a piece is simple process. Firstly the custodial captures are computed and then the strength captures. If there is already a custodial capture in the direction of a strength capture then the strength capture is discarded.

```prolog
% Gets the captures of a player.
%
% get_captures(+Player, +MoveBoard, +To, -Captures)
get_captures(Player, MoveBoard, To, Captures) :-
  get_custodial_captures(Player, MoveBoard, To, CustodialCaptures),
  get_strength_captures(Player, MoveBoard, To, StrengthCaptures),
  remove_strength_duplicates(CustodialCaptures, StrengthCaptures, NewStrengthCaptures), !,
  append(CustodialCaptures, NewStrengthCaptures, Captures).
```

The predicate `remove_strength_duplicates(+CustodialCaptures, +StrengthCaptures, -Captures)` makes sure that there are no duplicate strength captures in the same direction of a custodial capture. The strength captures are discarded since its more advantageous to capture a piece without decreasing the players piece.

If there are more than one custodial captures available then they are made automatically. On the other side, if there are more strength captures available than custodial captures available the game asks the user to select the capture.

#### 3.4.2. Dragon spawning

At the end of each move dragon spawning is checked, the predicate always succeeds even if there are no dragons spawned. 

```prolog
% Spawns the dragons.
%
% spawn_dragons(+Board, +Caves, +PiecesCount, -NewBoard, -NewCaves, -NewPieceCount)
spawn_dragons(Board, Caves, PiecesCount, NewBoard, NewCaves, NewPieceCount) :-
  spawn_left_dragon(Board, Caves, PiecesCount, LeftBoard, LeftCaves, LeftPieceCount),
  spawn_right_dragon(LeftBoard, LeftCaves, LeftPieceCount, RightBoard, RightCaves, RightPieceCount),
  spawn_middle_dragon(RightBoard, RightCaves, RightPieceCount, NewBoard, NewCaves, NewPieceCount).
```

At the end of the predicate a new board, cave state and piece count state is computed.

A more detailed description of each dragon spawning is available in the [dragons file](/src/dragons.pl).

After this predicate there is a need to check if a move was made from a cave in order to set the cave piece to `CE` (cave empty). This process is made with the `set_empty_caves` predicate.

This predicate checks if a play was performed from a cave, if so, sets the from position to `CE`.

```prolog
% Sets the caves empty after a move from it.
%
% set_emtpy_caves(+From, +Board, -NewBoard)
set_empty_caves(From, Board, NewBoard) :-
  From == 4-0,
  matrix_replace(Board, From, cave_empty, NewBoard).

% Sets the caves empty after a move from it.
%
% set_emtpy_caves(+From, +Board, -NewBoard)
set_empty_caves(From, Board, NewBoard) :-
  From == 4-4,
  matrix_replace(Board, From, cave_empty, NewBoard).

% Sets the caves empty after a move from it.
%
% set_emtpy_caves(+From, +Board, -NewBoard)
set_empty_caves(From, Board, NewBoard) :-
  From == 4-8,
  matrix_replace(Board, From, cave_empty, NewBoard).

% Sets the caves empty after a move from it.
%
% set_emtpy_caves(+From, +Board, -NewBoard)
set_empty_caves(_, Board, Board).
```

### 3.5. End of game

The end of the game is reached when a player is reduced to only one piece. Since the state holds the player pieces the predicate `game_over(+GameState, -Winner).` is fairly simple.

```prolog
% Checks if a game is over.
%
% game_over(+State, -Winner)
game_over(state(_, _, _, PiecesCount), Winner) :-
    pieces_count(white-WhiteCount, _) = PiecesCount,
    WhiteCount =:= 1,
    Winner = black.

% Checks if a game is over.
%
% game_over(+State, -Winner)
game_over(state(_, _, _, PiecesCount), Winner) :-
    pieces_count(_, black-BlackCount) = PiecesCount,
    BlackCount =:= 1,
    Winner = white.
```

### 3.6. Board evaluation

The board evaluation is made with the piece count of each player. This is, the player value is as higher as the difference between its pieces and its opponents pieces.

Example: if the white player has 6 pieces and the black player has 3 pieces the white value is 6-3=3 and the black value is 3-6=-3.

The next move should always aim to increase the player value by decreasing the opponents pieces.

```prolog
% Computes the value of a player.
%
% value(+State, +Player, -Value)
value(State, white, Value) :-
    state(_, _, _, pieces_count(white-WhiteCount, black-BlackCount)) = State,
    Value is WhiteCount - BlackCount.

% Computes the value of a player.
%
% value(+State, +Player, -Value)
value(State, black, Value) :-
    state(_, _, _, pieces_count(white-WhiteCount, black-BlackCount)) = State,
    Value is BlackCount - WhiteCount.
```

### 3.7. Computer move

The computer move is different according to its difficulty. If the difficulty is easy the move is a completely random valid move. If the difficulty is normal then the move is the move that aims to better improve the player's value. 

#### 3.7.1. Easy mode

As said, the selected move is completely random within the valid moves.

```prolog
% Chooses a move in the easy mode (random).
%
% choose_move(+State, +Player, easy, -Move)
choose_move(State, Player, easy, Move) :-
  init_random_state,
  valid_moves(State, Player, Moves),
  random_member(Move, Moves).
```

The predicate `init_random_state` is placed in `utils.pl` and assures the move *complete* randomness.

#### 3.7.2. Normal mode

The normal mode is greedy mode. This mode aims to find the move that better improves the player's value. If no move improves the value then a random move is selected. If more than one moves improve equally the value then a random move from those is selected.

```prolog
% Chooses a move in the easy mode (gredy and random).
%
% choose_move(+State, +Player, normal, -Move)
choose_move(State, Player, normal, Move) :-
  init_random_state,
  valid_moves(State, Player, ValidMoves),
  choose_normal_move_helper(State, Player, ValidMoves, NormalMoves),
  sort(NormalMoves, SortedMoves),
  reverse(SortedMoves, Moves),
  nth0(0, Moves, Value/_),
  repeat,
  random_member(Value/Move, Moves), !.

% Computes the value of each move.
%
% choose_normal_move_helper(+State, +Player, +Moves, -ValueMoves) 
choose_normal_move_helper(State, Player, [Move|T], [Value/Move|TR]) :-
  move(State, Move, NewGameState),
  value(NewGameState, Player, Value),
  choose_normal_move_helper(State, Player, T, TR).

choose_normal_move_helper(_, _, [], []).
```

#### 3.7.3. Computer capturing play variant

Since the computer cannot ask the user to select which capture to make, if there are more than one capture types available the computer always chooses the custodial capture.

## 4. Conclusions

The project development wasn't quite easy since there is only a PLOG practical class per a pair of weeks. Thus, the project involved much more homework than expected.

It is the first contact that we have with Prolog and some problems raised from that in the beginning. However, throughout the semester we were able to familiarize ourselves with the language and become more comfortable with it. The hardest part, as expected, was to think about the development of our program in a non-imperative way.

With this said, we believe we managed to comply with all the objectives planned for this project, resulting in a fully functional game.

## 5. Bibliography

- Tre drager – version 0.40. 19 February 2020. Obtained 10 October 2020, from https://drive.google.com/drive/folders/1xNoHSM08SChVW2TWtzU8Qje6m7hxrEYh
