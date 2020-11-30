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
    spawn_dragons(CaptureBoard, Caves, CapturePiecesCount, DragonsBoard, NewCaves, NewPieceCount), !,
    set_empty_caves(From, DragonsBoard, UpdatedBoard).

decrease_pieces(white, pieces_count(white-Current, B), pieces_count(white-New, B)) :-
    New is Current - 1.

decrease_pieces(black, pieces_count(A, black-Current), pieces_count(A, black-New)) :-
    New is Current - 1.