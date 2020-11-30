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

% Moves a player piece to a position. 
%
% move(+State, +Position, -NewGameState)
move(State, From/To, NewGameState) :-
  state(Player, Board, available_caves(Caves), PiecesCount) = State,
  get_element(From, Board, Piece),
  make_move(Board, From, To, Piece, MoveBoard),
  get_captures(Player, MoveBoard, To, Captures),
  bot_capture(Player, Captures, To, MoveBoard, CaptureBoard, PiecesCount, CapturePiecesCount),
  spawn_dragons(CaptureBoard, Caves, CapturePiecesCount, DragonsBoard, NewCaves, NewPieceCount), !,
  set_empty_caves(From, DragonsBoard, UpdatedBoard),
  NewGameState = state(Player, UpdatedBoard, available_caves(NewCaves), NewPieceCount).

% Checks and applies a bot capture.
%
% bot_capture(+Player, +Captures, +To, +MoveBoard, -CaptureBoard, +PiecesCpint, -CapturePiecesCount)
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
    random_member(_-R-C, StrengthCaptures),
    apply_strength_capture(Player, R-C, To, MoveBoard, CaptureBoard),
    decrease_pieces(Player, PiecesCount, CapturePiecesCount)
    ;
    CaptureBoard = MoveBoard,
    CapturePiecesCount = PiecesCount
  ).

% Chooses a move in the easy mode (random).
%
% choose_move(+State, +Player, easy, -Move)
choose_move(State, Player, easy, Move) :-
  init_random_state,
  valid_moves(State, Player, Moves),
  random_member(Move, Moves).

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