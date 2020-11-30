is_player_piece(Board, Player, Position) :-
  get_element(Position, Board, Piece),
  piece(Piece, _, Player, _).

findall_player_pieces(Board, Player, Pieces) :-
  findall(Position, is_player_piece(Board, Player, Position), Pieces).

valid_move_to(State, Board, Player, From, Row-Column) :-
  get_element(From, Board, Piece),
  is_piece_selectable(Piece, Player),
  gen(Row, Column),
  check_bounds(Row-Column),
  has_different_positions(From, Row-Column),
  is_valid_basic_move(From, Row-Column),
  move_no_jumping(State, From, Row-Column).

findall_valid_moves_to(State, Board, Player, From, Moves) :-
  findall(From-To, valid_move_to(State, Board, Player, From, To), Moves).
  
valid_moves_helper(_, _, _, [], []).

valid_moves_helper(State, Board, Player, [H|T], List) :-
  findall_valid_moves_to(State, Board, Player, H, Moves),
  valid_moves_helper(Board, Player, T, List2),
  append(List2, Moves, UnsortedList),
  sort(UnsortedList, List).

valid_moves(State, Player, List) :-
  state(_, Board, _, _) = State,
  findall_player_pieces(Board, Player, Pieces),
  valid_moves_helper(State, Board, Player, Pieces, List).