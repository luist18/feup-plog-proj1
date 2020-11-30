game_loop :-
    retractall(state(_, _, _, _)),
    testBoard(InitialBoard),
    assert(state(white, InitialBoard, available_caves(true-true-true), pieces_count(white-8, black-8))),
    repeat,
        state(Player, Board, Caves, PiecesCount),
        %write('\33\[2J'),
        display_board(Board),
        player_turn(NextBoard, NewCaves, NewPieceCount),
        next_player(NextPlayer),
        retract(state(Player, Board, Caves, PiecesCount)),
        assert(state(NextPlayer, NextBoard, available_caves(NewCaves), NewPieceCount)),
        end_of_game(2), !,
    show_result.

next_player(Player) :-
    state(white, _, _, _),
    Player = black, !.

next_player(white) :- !.

end_of_game(N) :-
    N > 10, write('End game'), nl.

show_result :- 
    nl, write('GAME FINISHED').

player_turn(UpdatedBoard, NewCaves, NewPieceCount) :-
    state(Player, Board, available_caves(Caves), PiecesCount),
    write('Player: '), write(Player), nl,
    repeat,
        write('Select the piece to move...'), nl,
        read_move(From),
        write('Select the position to move...'), nl,
        read_move(To),
        (
            validate_move(From, To)
            ;
            write('Invalid move!'), nl,
            fail
        ), !,
    get_element(From, Board, Piece),
    make_move(From, To, Piece, MoveBoard),
    get_captures(MoveBoard, To, Captures),
    ask_capture(Captures, To, MoveBoard, CaptureBoard, PiecesCount, CapturePiecesCount),
    spawn_dragons(CaptureBoard, Caves, PiecesCount, UpdatedBoard, NewCaves, NewPieceCount), !.
    %set_empty_caves(From, DragonsBoard, UpdatedBoard).
    %analyzeCaptures(TempBoard, Player, position(New_Column, New_Row), CustodialCaptures, StrengthCaptures),
    %write('POWER CAPTURES: '), write(CustodialCaptures),nl,
    %write('STRENGTH CAPTURES: '), write(StrengthCaptures),nl,
    %applyCaptures(TempBoard, Player, position(New_Column, New_Row), CustodialCaptures, StrengthCaptures, TempBoard2), !,

decrease_pieces(white, pieces_count(white-Current, B), pieces_count(white-New, B)) :-
    New is Current - 1.

decrease_pieces(black, pieces_count(A, black-Current), pieces_count(A, black-New)) :-
    New is Current - 1.

ask_capture([], _, Board, Board, PiecesCount, PiecesCount) :- !.

ask_capture(Captures, To, Board, CaptureBoard, PiecesCount, NewPiecesCount) :-
    state(Player, _, _, _),
    display_board(Board),
    read_capture(Captures, Capture),
    apply_capture(Player, Capture, To, Board, CaptureBoard), !,
    decrease_pieces(Player, PiecesCount, NewPiecesCount), !.

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