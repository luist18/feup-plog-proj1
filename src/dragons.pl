
set_empty_caves(From, Board, NewBoard) :-
  From == 4-0,
  matrix_replace(Board, From, cave_empty, NewBoard).

set_empty_caves(From, Board, NewBoard) :-
  From == 4-4,
  matrix_replace(Board, From, cave_empty, NewBoard).

set_empty_caves(From, Board, NewBoard) :-
  From == 4-8,
  matrix_replace(Board, From, cave_empty, NewBoard).

set_empty_caves(_, Board, Board).

spawn_dragons(Board, NewBoard, NewCaves, NewPieceCount) :-
  spawn_left_dragon(Board, NewBoard, NewCaves, NewPieceCount).

spawn_dragons(NewBoard, NewBoard, NewCaves, NewPieceCount) :- 
  state(_, _, available_caves(NewCaves), NewPieceCount).

spawn_left_dragon(Board, NewBoard, false-C2-C3, NewPieceCount) :-
  state(_, _, available_caves(false-C2-C3), NewPieceCount),
  NewBoard = Board.

spawn_left_dragon(Board, NewBoard, NewCaves, NewPieceCount) :-
  state(Player, _, available_caves(_-C2-C3), pieces_count(white-WhiteCount, black-BlackCount)),
  get_element(3-0, Board, TopElement),
  get_element(5-0, Board, BottomElement),
  get_element(4-1, Board, RightElement),
  piece(TopElement, _, Player, _),
  piece(BottomElement, _, Player, _),
  piece(RightElement, _, Player, _),
  piece(CaveElement, _, Player, 3),
  matrix_replace(Board, 4-0, CaveElement, NewBoard),
  NewCaves = false-C2-C3,
  (
      Player == white,
      NewWhiteCount is WhiteCount + 1,
      NewPieceCount = piece_count(white-NewWhiteCount, black-BlackCount)
      ;
      NewBlackCount is BlackCount + 1,
      NewPieceCount = piece_count(white-WhiteCount, black-NewBlackCount)
  ).

spawn_left_dragon(NewBoard, NewBoard, NewCaves, NewPieceCount) :- 
  state(_, _, available_caves(NewCaves), NewPieceCount).