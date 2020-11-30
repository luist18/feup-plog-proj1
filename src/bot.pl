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
  findall(From/To, valid_move_to(State, Board, Player, From, To), Moves).

valid_moves_helper(_, _, _, [], []).

valid_moves_helper(State, Board, Player, [H|T], List) :-
  findall_valid_moves_to(State, Board, Player, H, Moves),
  valid_moves_helper(State, Board, Player, T, List2),
  append(List2, Moves, UnsortedList),
  sort(UnsortedList, List).

valid_moves(State, Player, List) :-
  state(_, Board, _, _) = State,
  findall_player_pieces(Board, Player, Pieces),
  valid_moves_helper(State, Board, Player, Pieces, List).

move(State, From/To, NewGameState) :-
  state(Player, Board, available_caves(Caves), PiecesCount) = State,
  get_element(From, Board, Piece),
  make_move(Board, From, To, Piece, MoveBoard),
  get_captures(Player, MoveBoard, To, Captures),
  bot_capture(Player, Captures, To, MoveBoard, CaptureBoard, PiecesCount, CapturePiecesCount),
  spawn_dragons(CaptureBoard, Caves, CapturePiecesCount, DragonsBoard, NewCaves, NewPieceCount), !,
  set_empty_caves(From, DragonsBoard, UpdatedBoard),
  NewGameState = state(Player, UpdatedBoard, available_caves(NewCaves), NewPieceCount).

bot_capture(Player, Captures, To, MoveBoard, CaptureBoard, PiecesCount, CapturePiecesCount) :-
  findall(D-R-C-custodial, (member(D-R-C-custodial, Captures)), CustodialCaptures),
  findall(D-R-C, (member(D-R-C-strength, Captures)), StrengthCaptures),
  length(CustodialCaptures, CustodialLength),
  length(StrengthCaptures, StrengthLength),
  (
    CustodialLength >= 1,
    apply_custodial_captures(CustodialCaptures, To, MoveBoard, CaptureBoard, PiecesCount, CapturePiecesCount)
    ;
    StrengthLength > 0,
    random_member(Capture, StrengthCaptures),
    apply_strength_capture(Player, Capture, To, MoveBoard, CaptureBoard),
    decrease_pieces(Player, PiecesCount, CapturePiecesCount)
    ;
    CaptureBoard = MoveBoard,
    CapturePiecesCount = PiecesCount
  ).

choose_move(State, Player, easy, Move) :-
  valid_moves(State, Player, Moves),
  random_member(Move, Moves).

choose_move(State, Player, normal, Move) :-
  valid_moves(State, Player, ValidMoves),
  choose_normal_move_helper(State, Player, ValidMoves, NormalMoves),
  sort(NormalMoves, SortedMoves),
  reverse(SortedMoves, Moves),
  nth0(0, Moves, _/Move).

choose_normal_move_helper(State, Player, [Move|T], [Value/Move|TR]) :-
  move(State, Move, NewGameState),
  value(NewGameState, Player, Value),
  choose_normal_move_helper(State, Player, T, TR).

choose_normal_move_helper(_, _, [], []).