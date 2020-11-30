make_move(Board, From, To, Element, UpdatedBoard) :-
  matrix_replace(Board, From, empty, TmpBoard),
  matrix_replace(TmpBoard, To, Element, UpdatedBoard).

validate_move(From, To) :-
  current_state(State),
  state(Player, Board, _, _) = State,
  get_element(From, Board, Piece),
  is_piece_selectable(Piece, Player),
  has_different_positions(From, To),
  is_valid_basic_move(From, To),
  move_no_jumping(State, From, To).

is_piece_selectable(Piece, Player) :-
  piece(Piece, _, Player, _).

has_different_positions(From, To) :-
  From \= To.

is_valid_basic_move(FromRow-FromColumn, ToRow-ToColumn) :-
  FromRow =:= ToRow;
  FromColumn =:=ToColumn.

is_horizontal_move(FromRow-_, FromRow-_) :- !.

check_bounds(Row-Column) :-
  Row >= 0,
  Row =< 8,
  Column >= 0,
  Column =< 8.

move_no_jumping_horizontal(State, To, To) :-
  state(_, Board, _, _) = State,
  get_element(To, Board, empty), !.

move_no_jumping_horizontal(State, FromRow-FromColumn, ToRow-ToColumn) :-
  state(_, Board, _, _) = State,
  (
      FromColumn < ToColumn, % move from left to right
      NewFromColumn is FromColumn + 1
      ;
      NewFromColumn is FromColumn - 1
  ), !,
  get_element(FromRow-NewFromColumn, Board, Piece),
  Piece == empty, !,
  move_no_jumping_horizontal(State, FromRow-NewFromColumn, ToRow-ToColumn), !.

move_no_jumping_vertical(State, To, To) :-
  state(_, Board, _, _) = State,
  get_element(To, Board, empty), !.

move_no_jumping_vertical(State, FromRow-FromColumn, ToRow-ToColumn) :-
  state(_, Board, _, _) = State,
  (
      FromRow < ToRow, % move from top to bottom
      NewFromRow is FromRow + 1
      ;
      NewFromRow is FromRow - 1
  ), !,
  get_element(NewFromRow-FromColumn, Board, Piece),
  Piece == empty, !,
  move_no_jumping_vertical(State, NewFromRow-FromColumn, ToRow-ToColumn), !.

move_no_jumping(State, From, To) :-
  is_horizontal_move(From, To),
  move_no_jumping_horizontal(State, From, To), !.
      
move_no_jumping(State, From, To) :-
  move_no_jumping_vertical(State, From, To), !.