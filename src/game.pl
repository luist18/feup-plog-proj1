initial(State) :-
    initial_board(InitialBoard),
    State = state(white, InitialBoard, available_caves(true-true-true), pieces_count(white-2, black-5)).

game_loop(GameMode) :-
    retractall(current_state(state(_, _, _, _))),
    initial(InitialState),
    assert(current_state(InitialState)),
    repeat,
        current_state(state(Player, Board, Caves, PiecesCount)),
        clear_move(Player),
        display_board(Board),
        (
            GameMode == player_vs_player,
            player_vs_player(NextBoard, NewCaves, NewPieceCount)
            ;
            GameMode == player_vs_easy_bot,
            player_vs_easy_bot(NextBoard, NewCaves, NewPieceCount)
        ),
        next_player(NextPlayer),
        retract(current_state(state(Player, Board, Caves, PiecesCount))),
        assert(current_state(state(NextPlayer, NextBoard, available_caves(NewCaves), NewPieceCount))),
        current_state(CurrentState),
        game_over(CurrentState, Winner), !,
    show_result(Winner).

next_player(Player) :-
    current_state(state(white, _, _, _)),
    Player = black, !.

next_player(white) :- !.

game_over(state(_, _, _, PiecesCount), Winner) :-
    pieces_count(white-WhiteCount, _) = PiecesCount,
    WhiteCount =:= 1,
    Winner = black.

game_over(state(_, _, _, PiecesCount), Winner) :-
    pieces_count(_, black-BlackCount) = PiecesCount,
    BlackCount =:= 1,
    Winner = white.

value(State, white, Value) :-
    state(_, _, _, pieces_count(white-WhiteCount, black-BlackCount)) = State,
    Value is WhiteCount - BlackCount.

value(State, black, Value) :-
    state(_, _, _, pieces_count(white-WhiteCount, black-BlackCount)) = State,
    Value is BlackCount - WhiteCount.

show_result(Winner) :- 
    current_state(state(_, Board, _, _)),
    write('\33\[2J'),
    display_board(Board),
    nl,
    format('The player with the ~w pieces has won!', [Winner]).

player_vs_player(UpdatedBoard, NewCaves, NewPieceCount) :-
    current_state(CurrentState),
    state(Player, Board, available_caves(Caves), PiecesCount) = CurrentState,
    pieces_count(PlayerPiecesWhite, PlayerPiecesBlack) = PiecesCount,
    nl, format('Player: ~w', [Player]), nl,
    format('Player pieces: ~w, ~w', [PlayerPiecesWhite, PlayerPiecesBlack]), nl, nl,
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
    make_move(Board, From, To, Piece, MoveBoard),
    get_captures(Player, MoveBoard, To, Captures),
    ask_capture(Captures, To, MoveBoard, CaptureBoard, PiecesCount, CapturePiecesCount),
    spawn_dragons(CaptureBoard, Caves, CapturePiecesCount, DragonsBoard, NewCaves, NewPieceCount), !,
    set_empty_caves(From, DragonsBoard, UpdatedBoard).

player_vs_easy_bot(UpdatedBoard, NewCaves, NewPieceCount) :-
    current_state(CurrentState),
    state(Player, Board, available_caves(Caves), PiecesCount) = CurrentState,
    pieces_count(PlayerPiecesWhite, PlayerPiecesBlack) = PiecesCount,
    nl, format('Player: ~w', [Player]), nl,
    format('Player pieces: ~w, ~w', [PlayerPiecesWhite, PlayerPiecesBlack]), nl, nl,
    (
        Player == white,
        ask_player_move(From-To),
        get_element(From, Board, Piece),
        make_move(Board, From, To, Piece, MoveBoard),
        get_captures(Player, MoveBoard, To, Captures),
        ask_capture(Captures, To, MoveBoard, CaptureBoard, PiecesCount, CapturePiecesCount),
        spawn_dragons(CaptureBoard, Caves, CapturePiecesCount, DragonsBoard, NewCaves, NewPieceCount), !,
        set_empty_caves(From, DragonsBoard, UpdatedBoard)
        ;
        choose_move(CurrentState, Player, easy, Move),
        move(CurrentState, Move, state(_, UpdatedBoard, NewCaves, NewPieceCount))
    ).

ask_player_move(From-To) :-
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
        ), !.

player_vs_normal_bot.

bot_vs_bot.