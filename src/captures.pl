get_captures(MoveBoard, To, Captures) :-
  get_custodial_captures(MoveBoard, To, CustodialCaptures),
  get_strength_captures(MoveBoard, To, StrengthCaptures),
  remove_strength_duplicates(CustodialCaptures, StrengthCaptures, NewStrengthCaptures), !,
  append(CustodialCaptures, NewStrengthCaptures, Captures).

get_custodial_captures(Board, To, CustodialCaptures) :-
  state(Player, _, _, _),
  get_custodial_captures_up(Player, Board, To, UpCaptures), !,
  get_custodial_captures_down(Player, Board, To, DownCaptures), !,
  get_custodial_captures_left(Player, Board, To, LeftCaptures), !,
  get_custodial_captures_right(Player, Board, To, RightCaptures), !,
  append(UpCaptures, DownCaptures, VerticalCaptures),
  append(LeftCaptures, RightCaptures, HorizontalCaptures),
  append(VerticalCaptures, HorizontalCaptures, CustodialCaptures).
 
get_custodial_captures_up(Player, Board, Row-Column, [u-Row1-Column-custodial]) :- 
  Row >= 2,
  next_player(OppositePlayer),
  Row1 is Row - 1,
  get_element(Row1-Column, Board, Element1),
  piece(Element1, _, OppositePlayer, _),
  Row2 is Row - 2,
  get_element(Row2-Column, Board, Element2),
  piece(Element2, _, Player, _).

get_custodial_captures_up(_, _, _, []) :- !.

get_custodial_captures_down(Player, Board, Row-Column, [d-Row1-Column-custodial]) :- 
  Row =< 6,
  next_player(OppositePlayer),
  Row1 is Row + 1,
  get_element(Row1-Column, Board, Element1),
  piece(Element1, _, OppositePlayer, _),
  Row2 is Row + 2,
  get_element(Row2-Column, Board, Element2),
  piece(Element2, _, Player, _).

get_custodial_captures_down(_, _, _, []) :- !.

get_custodial_captures_left(Player, Board, Row-Column, [l-Row-Column1-custodial]) :- 
  Column >= 2,
  next_player(OppositePlayer),
  Column1 is Column - 1,
  get_element(Row-Column1, Board, Element1),
  piece(Element1, _, OppositePlayer, _),
  Column2 is Column - 2,
  get_element(Row-Column2, Board, Element2),
  piece(Element2, _, Player, _).

get_custodial_captures_left(_, _, _, []) :- !.

get_custodial_captures_right(Player, Board, Row-Column, [r-Row-Column1-custodial]) :- 
  Column =< 6,
  next_player(OppositePlayer),
  Column1 is Column + 1,
  get_element(Row-Column1, Board, Element1),
  piece(Element1, _, OppositePlayer, _),
  Column2 is Column + 2,
  get_element(Row-Column2, Board, Element2),
  piece(Element2, _, Player, _).

get_custodial_captures_right(_, _, _, []) :- !.

get_strength_captures(Board, To, Captures) :-
  state(Player, _, _, _),
  get_strength_captures_up(Player, Board, To, UpCaptures), !,
  get_strength_captures_down(Player, Board, To, DownCaptures), !,
  get_strength_captures_left(Player, Board, To, LeftCaptures), !,
  get_strength_captures_right(Player, Board, To, RightCaptures), !,
  append(UpCaptures, DownCaptures, VerticalCaptures),
  append(LeftCaptures, RightCaptures, HorizontalCaptures),
  append(VerticalCaptures, HorizontalCaptures, Captures).

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

remove_strength_duplicates(CustodialCaptures, [Direction-Row-Column-Type|T], [Direction-Row-Column-Type|TR]) :-
  \+member(Direction-_-_-_, CustodialCaptures),
  remove_strength_duplicates(CustodialCaptures, T, TR).

remove_strength_duplicates(CustodialCaptures, [_|T], TR) :-
  remove_strength_duplicates(CustodialCaptures, T, TR).

remove_strength_duplicates(_, [], []).