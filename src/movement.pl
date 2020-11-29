make_move(From, To, Element, UpdatedBoard) :-
  state(_, Board, _, _),
  matrix_replace(Board, From, empty, TmpBoard),
  matrix_replace(TmpBoard, To, Element, UpdatedBoard).

validate_move(From, To) :-
  state(Player, Board, _, _),
  get_element(From, Board, Piece),
  is_piece_selectable(Piece, Player),
  has_different_positions(From, To),
  is_valid_basic_move(From, To),
  move_no_jumping(From, To).

is_piece_selectable(Piece, Player) :-
  piece(Piece, _, Player, _).

has_different_positions(From, To) :-
  From \= To.

is_valid_basic_move(FromRow-FromColumn, ToRow-ToColumn) :-
  FromRow =:= ToRow;
  FromColumn =:=ToColumn.

is_horizontal_move(FromRow-_, FromRow-_) :- !.

move_no_jumping_horizontal(To, To) :-
  state(_, Board, _, _),
  get_element(To, Board, empty), !.

move_no_jumping_horizontal(FromRow-FromColumn, ToRow-ToColumn) :-
  state(_, Board, _, _),
  (
      FromColumn < ToColumn, % move from left to right
      NewFromColumn is FromColumn + 1
      ;
      NewFromColumn is FromColumn - 1
  ), !,
  get_element(FromRow-NewFromColumn, Board, Piece),
  Piece == empty, !,
  move_no_jumping_horizontal(FromRow-NewFromColumn, ToRow-ToColumn), !.

move_no_jumping_vertical(To, To) :-
  state(_, Board, _, _),
  get_element(To, Board, empty), !.

move_no_jumping_vertical(FromRow-FromColumn, ToRow-ToColumn) :-
  state(_, Board, _, _),
  (
      FromRow < ToRow, % move from top to bottom
      NewFromRow is FromRow + 1
      ;
      NewFromRow is FromRow - 1
  ), !,
  get_element(NewFromRow-FromColumn, Board, Piece),
  Piece == empty, !,
  move_no_jumping_vertical(NewFromRow-FromColumn, ToRow-ToColumn), !.

move_no_jumping(From, To) :-
  is_horizontal_move(From, To),
  move_no_jumping_horizontal(From, To), !.
      
move_no_jumping(From, To) :-
  move_no_jumping_vertical(From, To), !.