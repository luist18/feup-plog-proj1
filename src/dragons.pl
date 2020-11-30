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

% Spawns the dragons.
%
% spawn_dragons(+Board, +Caves, +PiecesCount, -NewBoard, -NewCaves, -NewPieceCount)
spawn_dragons(Board, Caves, PiecesCount, NewBoard, NewCaves, NewPieceCount) :-
  spawn_left_dragon(Board, Caves, PiecesCount, LeftBoard, LeftCaves, LeftPieceCount),
  spawn_right_dragon(LeftBoard, LeftCaves, LeftPieceCount, RightBoard, RightCaves, RightPieceCount),
  spawn_middle_dragon(RightBoard, RightCaves, RightPieceCount, NewBoard, NewCaves, NewPieceCount).

% Spawns a single dragon.
%
% spawn_left_dragon(+Board, +Caves, +PiecesCount, -NewBoard, -NewCaves, -NewPieceCount)
spawn_left_dragon(Board, true-C2-C3, pieces_count(white-WhiteCount, black-BlackCount), NewBoard, NewCaves, NewPieceCount) :-
  current_state(state(Player, _, _, _)),
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
      NewPieceCount = pieces_count(white-NewWhiteCount, black-BlackCount)
      ;
      NewBlackCount is BlackCount + 1,
      NewPieceCount = pieces_count(white-WhiteCount, black-NewBlackCount)
  ).

% Spawns a single dragon.
%
% spawn_left_dragon(+Board, +Caves, +PiecesCount, -NewBoard, -NewCaves, -NewPieceCount)
spawn_left_dragon(Board, Caves, Pieces, Board, Caves, Pieces) :- !.

% Spawns a single dragon.
%
% spawn_right_dragon(+Board, +Caves, +PiecesCount, -NewBoard, -NewCaves, -NewPieceCount)
spawn_right_dragon(Board, C1-C2-true, pieces_count(white-WhiteCount, black-BlackCount), NewBoard, NewCaves, NewPieceCount) :-
  current_state(state(Player, _, _, _)),
  get_element(3-8, Board, TopElement),
  get_element(5-8, Board, BottomElement),
  get_element(4-7, Board, LeftElement),
  piece(TopElement, _, Player, _),
  piece(BottomElement, _, Player, _),
  piece(LeftElement, _, Player, _),
  piece(CaveElement, _, Player, 3),
  matrix_replace(Board, 4-8, CaveElement, NewBoard),
  NewCaves = C1-C2-true,
  (
      Player == white,
      NewWhiteCount is WhiteCount + 1,
      NewPieceCount = pieces_count(white-NewWhiteCount, black-BlackCount)
      ;
      NewBlackCount is BlackCount + 1,
      NewPieceCount = pieces_count(white-WhiteCount, black-NewBlackCount)
  ).

% Spawns a single dragon.
%
% spawn_right_dragon(+Board, +Caves, +PiecesCount, -NewBoard, -NewCaves, -NewPieceCount)
spawn_right_dragon(Board, Caves, Pieces, Board, Caves, Pieces) :- !.

% Spawns a single dragon.
%
% spawn_middle_dragon(+Board, +Caves, +PiecesCount, -NewBoard, -NewCaves, -NewPieceCount)
spawn_middle_dragon(Board, C1-true-C3, pieces_count(white-WhiteCount, black-BlackCount), NewBoard, NewCaves, NewPieceCount) :-
  current_state(state(Player, _, _, _)),
  get_element(3-4, Board, TopElement),
  get_element(5-4, Board, BottomElement),
  get_element(4-3, Board, LeftElement),
  get_element(4-5, Board, RightElement),
  piece(TopElement, _, Player, _),
  piece(BottomElement, _, Player, _),
  piece(LeftElement, _, Player, _),
  piece(RightElement, _, Player, _),
  piece(CaveElement, _, Player, 5),
  matrix_replace(Board, 4-4, CaveElement, NewBoard),
  NewCaves = C1-true-C3,
  (
      Player == white,
      NewWhiteCount is WhiteCount + 1,
      NewPieceCount = pieces_count(white-NewWhiteCount, black-BlackCount)
      ;
      NewBlackCount is BlackCount + 1,
      NewPieceCount = pieces_count(white-WhiteCount, black-NewBlackCount)
  ).

% Spawns a single dragon.
%
% spawn_middle_dragon(+Board, +Caves, +PiecesCount, -NewBoard, -NewCaves, -NewPieceCount)
spawn_middle_dragon(Board, Caves, Pieces, Board, Caves, Pieces) :- !.