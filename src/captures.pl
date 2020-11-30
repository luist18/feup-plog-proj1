% Gets the captures of a player.
%
% get_captures(+Player, +MoveBoard, +To, -Captures)
get_captures(Player, MoveBoard, To, Captures) :-
  get_custodial_captures(Player, MoveBoard, To, CustodialCaptures),
  get_strength_captures(Player, MoveBoard, To, StrengthCaptures),
  remove_strength_duplicates(CustodialCaptures, StrengthCaptures, NewStrengthCaptures), !,
  append(CustodialCaptures, NewStrengthCaptures, Captures).

% Gets the custodial captures of a player.
%
% get_custodial_captures(+Player, +Board, +To, -CustodialCaptures)
get_custodial_captures(Player, Board, To, CustodialCaptures) :-
  get_custodial_captures_up(Player, Board, To, UpCaptures), !,
  get_custodial_captures_down(Player, Board, To, DownCaptures), !,
  get_custodial_captures_left(Player, Board, To, LeftCaptures), !,
  get_custodial_captures_right(Player, Board, To, RightCaptures), !,
  append(UpCaptures, DownCaptures, VerticalCaptures),
  append(LeftCaptures, RightCaptures, HorizontalCaptures),
  append(VerticalCaptures, HorizontalCaptures, CustodialCaptures).
 
% Gets the up custodial captures of a player
%
% get_custodial_captures_up(+Player, +Board, +To, -CustodialCaptures)
get_custodial_captures_up(Player, Board, Row-Column, [u-Row1-Column-custodial]) :- 
  Row >= 2,
  next_player(OppositePlayer),
  Row1 is Row - 1,
  get_element(Row1-Column, Board, Element1),
  piece(Element1, _, OppositePlayer, _),
  Row2 is Row - 2,
  get_element(Row2-Column, Board, Element2),
  (
    piece(Element2, _, Player, _);
    piece(Element2, _, none, _)
  ).

get_custodial_captures_up(_, _, _, []) :- !.

% Gets the down custodial captures of a player
%
% get_custodial_captures_down(+Player, +Board, +To, -CustodialCaptures)
get_custodial_captures_down(Player, Board, Row-Column, [d-Row1-Column-custodial]) :- 
  Row =< 6,
  next_player(OppositePlayer),
  Row1 is Row + 1,
  get_element(Row1-Column, Board, Element1),
  piece(Element1, _, OppositePlayer, _),
  Row2 is Row + 2,
  get_element(Row2-Column, Board, Element2),
  (
    piece(Element2, _, Player, _);
    piece(Element2, _, none, _)
  ).

get_custodial_captures_down(_, _, _, []) :- !.

% Gets the left custodial captures of a player
%
% get_custodial_captures_left(+Player, +Board, +To, -CustodialCaptures)
get_custodial_captures_left(Player, Board, Row-Column, [l-Row-Column1-custodial]) :- 
  Column >= 2,
  next_player(OppositePlayer),
  Column1 is Column - 1,
  get_element(Row-Column1, Board, Element1),
  piece(Element1, _, OppositePlayer, _),
  Column2 is Column - 2,
  get_element(Row-Column2, Board, Element2),
  (
    piece(Element2, _, Player, _);
    piece(Element2, _, none, _)
  ).

get_custodial_captures_left(_, _, _, []) :- !.

% Gets the right custodial captures of a player
%
% get_custodial_captures_right(+Player, +Board, +To, -CustodialCaptures)
get_custodial_captures_right(Player, Board, Row-Column, [r-Row-Column1-custodial]) :- 
  Column =< 6,
  next_player(OppositePlayer),
  Column1 is Column + 1,
  get_element(Row-Column1, Board, Element1),
  piece(Element1, _, OppositePlayer, _),
  Column2 is Column + 2,
  get_element(Row-Column2, Board, Element2),
  (
    piece(Element2, _, Player, _);
    piece(Element2, _, none, _)
  ).

get_custodial_captures_right(_, _, _, []) :- !.

% Gets the strength captures of a player
%
% get_strength_captures(+Player, +Board, +To, -StrengthCaptures)
get_strength_captures(Player, Board, To, Captures) :-
  get_strength_captures_up(Player, Board, To, UpCaptures), !,
  get_strength_captures_down(Player, Board, To, DownCaptures), !,
  get_strength_captures_left(Player, Board, To, LeftCaptures), !,
  get_strength_captures_right(Player, Board, To, RightCaptures), !,
  append(UpCaptures, DownCaptures, VerticalCaptures),
  append(LeftCaptures, RightCaptures, HorizontalCaptures),
  append(VerticalCaptures, HorizontalCaptures, Captures).

% Gets the up strength captures of a player
%
% get_strength_captures_up(+Player, +Board, +To, -StrengthCaptures)
get_strength_captures_up(Player, Board, Row-Column, [u-Row1-Column-strength]) :-
  Row >= 1,
  next_player(OppositePlayer),
  get_element(Row-Column, Board, PlayerPiece),
  piece(PlayerPiece, _, Player, PlayerValue),
  Row1 is Row - 1,
  get_element(Row1-Column, Board, OppositePiece),
  piece(OppositePiece, _, OppositePlayer, OppositeValue),
  PlayerValue > OppositeValue.

get_strength_captures_up(_, _, _, []).

% Gets the down strength captures of a player
%
% get_strength_captures_down(+Player, +Board, +To, -StrengthCaptures)
get_strength_captures_down(Player, Board, Row-Column, [d-Row1-Column-strength]) :-
  Row =< 7,
  next_player(OppositePlayer),
  get_element(Row-Column, Board, PlayerPiece),
  piece(PlayerPiece, _, Player, PlayerValue),
  Row1 is Row + 1,
  get_element(Row1-Column, Board, OppositePiece),
  piece(OppositePiece, _, OppositePlayer, OppositeValue),
  PlayerValue > OppositeValue.

get_strength_captures_down(_, _, _, []).

% Gets the left strength captures of a player
%
% get_strength_captures_left(+Player, +Board, +To, -StrengthCaptures)
get_strength_captures_left(Player, Board, Row-Column, [l-Row-Column1-strength]) :-
  Column >= 1,
  next_player(OppositePlayer),
  get_element(Row-Column, Board, PlayerPiece),
  piece(PlayerPiece, _, Player, PlayerValue),
  Column1 is Column - 1,
  get_element(Row-Column1, Board, OppositePiece),
  piece(OppositePiece, _, OppositePlayer, OppositeValue),
  PlayerValue > OppositeValue.

get_strength_captures_left(_, _, _, []).

% Gets the right strength captures of a player
%
% get_strength_captures_right(+Player, +Board, +To, -StrengthCaptures)
get_strength_captures_right(Player, Board, Row-Column, [r-Row-Column1-strength]) :-
  Column =< 7,
  next_player(OppositePlayer),
  get_element(Row-Column, Board, PlayerPiece),
  piece(PlayerPiece, _, Player, PlayerValue),
  Column1 is Column + 1,
  get_element(Row-Column1, Board, OppositePiece),
  piece(OppositePiece, _, OppositePlayer, OppositeValue),
  PlayerValue > OppositeValue.

get_strength_captures_right(_, _, _, []).

% Removes the duplicate custodial and strength captures.
%
% remove_strength_duplicates(+CustodialCaptures, +StrengthCaptures, -Captures)
remove_strength_duplicates(CustodialCaptures, [Direction-Row-Column-Type|T], [Direction-Row-Column-Type|TR]) :-
  \+member(Direction-_-_-_, CustodialCaptures),
  remove_strength_duplicates(CustodialCaptures, T, TR).

% Removes the duplicate custodial and strength captures.
%
% remove_strength_duplicates(+CustodialCaptures, +StrengthCaptures, -Captures)
remove_strength_duplicates(CustodialCaptures, [_|T], TR) :-
  remove_strength_duplicates(CustodialCaptures, T, TR).

remove_strength_duplicates(_, [], []).

ask_capture([], _, Board, Board, PiecesCount, PiecesCount) :- !.

% Asks the player to perform a capture.
%
% ask_capture(+Captures, +To, +Board, -CaptureBoard, +PiecesCount, -NewPiecesCount)
ask_capture([Capture], To, Board, CaptureBoard, PiecesCount, NewPiecesCount) :-
  current_state(state(Player, _, _, _)),
  apply_capture(Player, Capture, To, Board, CaptureBoard), !,
  decrease_pieces(Player, PiecesCount, NewPiecesCount), !.

% Asks the player to perform a capture.
%
% ask_capture(+Captures, +To, +Board, -CaptureBoard, +PiecesCount, -NewPiecesCount)
ask_capture(Captures, To, Board, CaptureBoard, PiecesCount, NewPiecesCount) :-
  findall(X-A-B-Y, (member(X-A-B-Y, Captures), Y==custodial), CustodialCaptures),
  findall(X1-A1-B1-Y1, (member(X1-A1-B1-Y1, Captures), Y1==strength), StrengthCaptures),
  length(CustodialCaptures, AmountCustodial),
  length(StrengthCaptures, AmountStrength), 
  AmountCustodial \= AmountStrength,
  write('Custodial Captures: '), write(CustodialCaptures), nl,
  write('Strength Captures: '), write(StrengthCaptures), nl,
  (
    length(StrengthCaptures, 0) , apply_custodial_captures(CustodialCaptures, To, Board, CaptureBoard, PiecesCount, NewPiecesCount)
    ;
    length(CustodialCaptures, 0), apply_strength_captures(StrengthCaptures, To, Board, CaptureBoard, PiecesCount, NewPiecesCount)
    ;
    repeat,
    read_char('Please choose one (c - custodial, s - strength)\n', Input),
      (
        Input == 'c',
        apply_custodial_captures(CustodialCaptures, To, Board, CaptureBoard, PiecesCount, NewPiecesCount)
        ; 
        Input == 's',
        apply_strength_captures(StrengthCaptures, To, Board, CaptureBoard, PiecesCount, NewPiecesCount)
      ), !
  ).

% Asks the player to perform a capture.
%
% ask_capture(+Captures, +To, +Board, -CaptureBoard, +PiecesCount, -NewPiecesCount)
ask_capture(Captures, To, Board, CaptureBoard, PiecesCount, NewPiecesCount) :-
  current_state(state(Player, _, _, _)),
  display_board(Board),
  read_capture(Captures, Capture),
  apply_capture(Player, Capture, To, Board, CaptureBoard), !,
  decrease_pieces(Player, PiecesCount, NewPiecesCount), !.

apply_custodial_captures([], _, Board, Board, PiecesCount, PiecesCount).

apply_custodial_captures([H|T], To, Board, NewBoard, PiecesCount, NewPiecesCount) :- 
  current_state(state(Player, _,_,_)),
  apply_capture(Player, H, To, Board, UpdatedBoard),
  decrease_pieces(Player, PiecesCount, SecondPiecesCount),
  apply_custodial_captures(T, _, UpdatedBoard, NewBoard, SecondPiecesCount, NewPiecesCount).

apply_strength_captures(Captures, To, Board, NewBoard, PiecesCount, NewPiecesCount) :-
  read_capture(Captures, Capture),
  current_state(state(Player,_,_,_)),
  decrease_pieces(Player, PiecesCount, NewPiecesCount),
  apply_capture(Player, Capture, To, Board, NewBoard ).


apply_capture(_, _-Row-Column-custodial, _, Board, CaptureBoard) :-
    apply_custodial_capture(Row-Column, Board, CaptureBoard).

apply_capture(Player, _-Row-Column-strength, To, Board, CaptureBoard) :-
    apply_strength_capture(Player, Row-Column, To, Board, CaptureBoard).

apply_custodial_capture(Capture, Board, CaptureBoard) :-
    matrix_replace(Board, Capture, empty, CaptureBoard).

apply_strength_capture(Player, Capture, To, Board, CaptureBoard) :-

    get_element(Capture, Board, CaptureElement),
    piece(CaptureElement, _, _, CaptureValue),
    get_element(To, Board, ToElement),
    piece(ToElement, _, _, Value),
    Value > CaptureValue,
    NewValue is Value - 1,
    piece(NewPiece, _, Player, NewValue),
    matrix_replace(Board, To, NewPiece, HelperBoard),
    matrix_replace(HelperBoard, Capture, empty, CaptureBoard).

% Descreases the pieces of the opposite player
%
% decrease_pieces(+Player, +PiecesCount, -NewPiecesCount)
decrease_pieces(black, pieces_count(white-Current, B), pieces_count(white-New, B)) :-
    New is Current - 1.

% Descreases the pieces of the opposite player
%
% decrease_pieces(+Player, +PiecesCount, -NewPiecesCount)
decrease_pieces(white, pieces_count(A, black-Current), pieces_count(A, black-New)) :-
    New is Current - 1.