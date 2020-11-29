game_loop :-
    retractall(state(_, _, _, _)),
    testBoard(InitialBoard),
    assert(state(white, InitialBoard, available_caves(true-true-true), pieces_count(white-8, black-8))),
    repeat,
        state(Player, Board, available_caves(Caves), _),
        write('\33\[2J'),
        display_board(Board),
        player_turn(NextBoard, NewCaves, NewPieceCount),
        next_player(NextPlayer),
        retract(state(Player, Board, available_caves(Caves), _)),
        assert(state(NextPlayer, NextBoard, available_caves(NewCaves), NewPieceCount)),
        end_of_game(2), !,
    show_result.

next_player(Player) :-
    state(white, _, _, _),
    Player = black.

next_player(white).

end_of_game(N) :-
    N > 10, write('End game'), nl.

show_result :- 
    nl, write('GAME FINISHED').

player_turn(UpdatedBoard, NewCaves, NewPieceCount) :-
    state(Player, Board, _, _),
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
    make_move(From, To, Piece, MoveBoard), !,
    spawn_dragons(MoveBoard, DragonsBoard, NewCaves, NewPieceCount),
    set_empty_caves(From, DragonsBoard, UpdatedBoard).
    %analyzeCaptures(TempBoard, Player, position(New_Column, New_Row), CustodialCaptures, StrengthCaptures),
    %write('POWER CAPTURES: '), write(CustodialCaptures),nl,
    %write('STRENGTH CAPTURES: '), write(StrengthCaptures),nl,
    %applyCaptures(TempBoard, Player, position(New_Column, New_Row), CustodialCaptures, StrengthCaptures, TempBoard2), !,
    %check_normal_captures(TempBoard, Player, position(New_Column, New_Row), TempBoard2), !,
    %spawnDragons(TempBoard2, Player, UpdatedBoard, available_caves(C1-C2-C3), available_caves(X1-X2-X3)), !.

% Represents a piece of the board.
%
% piece(Name, TextRepresentation, Player, Value).
piece(empty, '    ', none, 0).
piece(black1, ' B1 ', black, 1).
piece(black2, ' B2 ', black, 2).
piece(black3, ' B3 ', black, 3).
piece(black4, ' B4 ', black, 4).
piece(black5, ' B5 ', black, 5).
piece(white1, ' W1 ', white, 1).
piece(white2, ' W2 ', white, 2).
piece(white3, ' W3 ', white, 3).
piece(white4, ' W4 ', white, 4).
piece(white5, ' W5 ', white, 5).
piece(mountain, ' M  ', none, 0).
piece(cave_available, ' CA ', none, 0).
piece(cave_empty, ' CE ', none, 0).

% Succeeds if player can capture a piece.
%
% is_element_capturable(+Player, +Piece)
is_element_capturable(1, black1).
is_element_capturable(1, black2).
is_element_capturable(1, black3).
is_element_capturable(1, black4).
is_element_capturable(1, black5).

is_element_capturable(2, white1).
is_element_capturable(2, white2).
is_element_capturable(2, white3).
is_element_capturable(2, white4).
is_element_capturable(2, white5).

%==============SPAWN DRAGONS================================

%White dragon
spawnLeftDragon(Board, 1, UpdatedBoard, Available, NewAvailability) :-
    %make sure dragon didn't spawn yet
    /*extract_element(0,4, Board, Element),
    Element == cave, */
    Available == true,
    %check element above the cave
    extract_element(0, 3, Board, Element1 ),
    is_white_piece(Element1),
    %check element below the cave
    extract_element(0, 5, Board, Element2 ),
    is_white_piece(Element2),
    %check element to the right of the cave
    extract_element(1, 4, Board, Element3 ),
    is_white_piece(Element3),
    %There are three white pieces surrounding the cave. Must spawn white dragon
    replaceElement(4,0, white3, Board, UpdatedBoard),
    NewAvailability = false.
    
%Black Dragon
spawnLeftDragon(Board, 2, UpdatedBoard, Available, NewAvailability) :-
    %make sure dragon didn't spawn yet
    /*extract_element(0,4, Board, Element),
    Element == cave, */
    Available == true,
    %check element above the cave
    extract_element(0, 3, Board, Element1),
    is_black_piece(Element1),
    %check element below the cave
    extract_element(0, 5, Board, Element2 ),
    is_black_piece(Element2),
    %check element to the right of the cave
    extract_element(1, 4, Board, Element3 ),
    is_black_piece(Element3),
    %There are three black pieces surrounding the cave. Must spawn black dragon
    replaceElement(4,0, black3, Board, UpdatedBoard),
    NewAvailability = false.

spawnLeftDragon(Board, _, UpdatedBoard, false, false) :-
    extract_element(0,4,Board, Element),
    Element == empty,
    replaceElement(4,0,cave, Board, UpdatedBoard).
spawnLeftDragon(Board, _, Board, Av, Av).


%White dragon
spawnMiddleDragon(Board, 1, UpdatedBoard, Available, NewAvailability) :-
    %make sure dragon didn't spawn yet
    /*extract_element(4,4, Board, Element),
    Element == cave, */
    Available == true, 
    %check element above the cave
    extract_element(4, 3, Board, Element1 ),
    is_white_piece(Element1),
    %check element below the cave
    extract_element(4, 5, Board, Element2 ),
    is_white_piece(Element2),
    %check element to the right of the cave
    extract_element(5, 4, Board, Element3 ),
    is_white_piece(Element3),
    %check element to the left of the cave
    extract_element(3, 4, Board, Element4 ),
    is_white_piece(Element4),
    %There are four white pieces surrounding the cave. Must spawn white dragon
    replaceElement(4,4, white5, Board, UpdatedBoard),
    NewAvailability = false.

%Black dragon
spawnMiddleDragon(Board, 2, UpdatedBoard, Available, NewAvailability) :-
    %make sure dragon didn't spawn yet
    /*extract_element(4,4, Board, Element),
    Element == cave, */
    Available == true, 
    %check element above the cave
    extract_element(4, 3, Board, Element1 ),
    is_black_piece(Element1),
    %check element below the cave
    extract_element(4, 5, Board, Element2 ),
    is_black_piece(Element2),
    %check element to the right of the cave
    extract_element(5, 4, Board, Element3 ),
    is_black_piece(Element3),
    %check element to the left of the cave
    extract_element(3, 4, Board, Element4 ),
    is_black_piece(Element4),
    %There are four black pieces surrounding the cave. Must spawn black dragon
    replaceElement(4,4, black5, Board, UpdatedBoard),
    NewAvailability = false.

spawnMiddleDragon(Board, _ , UpdatedBoard, false, false) :-
    extract_element(4,4, Board, Element),
    Element == empty,
    replaceElement(4,4, cave, Board, UpdatedBoard).
spawnMiddleDragon(Board, _, Board, Av, Av).

%White dragon
spawnRightDragon(Board, 1, UpdatedBoard, Available, NewAvailability) :-
    %make sure dragon didn't spawn yet
    /*extract_element(8,4, Board, Element),
    Element == cave, */
    Available == true,
    %check element above the cave
    extract_element(8, 3, Board, Element1 ),
    is_white_piece(Element1),
    %check element below the cave
    extract_element(8, 5, Board, Element2 ),
    is_white_piece(Element2),
    %check element to the left of the cave
    extract_element(7, 4, Board, Element3 ),
    is_white_piece(Element3),
    %There are three white pieces surrounding the cave. Must spawn white dragon
    replaceElement(4,8, white3, Board, UpdatedBoard),
    NewAvailability = false.
    


%Black dragon
spawnRightDragon(Board, 2, UpdatedBoard, Available, NewAvailability) :-
    %make sure dragon didn't spawn yet
    /*extract_element(8,4, Board, Element),
    Element == cave, */
    Available==true, 
    %check element above the cave
    extract_element(8, 3, Board, Element1 ),
    is_black_piece(Element1),
    %check element below the cave
    extract_element(8, 5, Board, Element2 ),
    is_black_piece(Element2),
    %check element to the left of the cave
    extract_element(7, 4, Board, Element3 ),
    is_black_piece(Element3),
    %There are three black pieces surrounding the cave. Must spawn black dragon
    replaceElement(4,8, black3, Board, UpdatedBoard),
    NewAvailability = false.


spawnRightDragon(Board, _, UpdatedBoard, false, false) :-
    extract_element(8,4,Board, Element),
    Element == empty,
    replaceElement(4,8, cave, Board, UpdatedBoard).


spawnRightDragon(Board, _, Board,Av, Av).

is_black_piece(black1).
is_black_piece(black2).
is_black_piece(black3).
is_black_piece(black4).
is_black_piece(black5).

is_white_piece(white1).
is_white_piece(white2).
is_white_piece(white3).
is_white_piece(white4).
is_white_piece(white5).


%====================================================================
%CAPTURES START HERE

%AnalyzeCaptures(Board, Player, position(Column, Row), CustodialCaptures, StrengthCaptures)
%Get all the possible directions in which normalCaptures can happen - CustodialCaptures List
%Get all the possible directions in which strength captures can occur - StrengthCaptures List (up,down, left, right)
analyzeCaptures(Board, Player, position(Column, Row),CustodialCaptures, StrengthCaptures) :-
    analyzeNormalUpCapture(Board, Player, position(Column, Row), CaptureList),
    analyzeNormalDownCapture(Board, Player, position(Column, Row), CaptureList2),
    analyzeNormalLeftCapture(Board, Player, position(Column, Row), CaptureList3),
    analyzeNormalRightCapture(Board, Player, position(Column, Row), CaptureList4),
    append(CaptureList, CaptureList2, TempList),
    append(TempList, CaptureList3, TempList2),
    append(TempList2, CaptureList4, CustodialCaptures),

    analyzeStrengthUpCapture(Board, Player, position(Column, Row), StrengthList),
    analyzeStrengthDownCapture(Board, Player, position(Column, Row), StrengthList2),
    analyzeStrengthLeftCapture(Board, Player, position(Column, Row), StrengthList3),
    analyzeStrengthRightCapture(Board, Player, position(Column, Row), StrengthList4),
    append(StrengthList, StrengthList2, TempStrengthList),
    append(TempStrengthList, StrengthList3, TempStrengthList2),
    append(TempStrengthList2, StrengthList4, StrengthCaptures).



%Check if a normal capture is possible upwards from the current position
analyzeNormalUpCapture(Board, Player, position(Column, Row), [up]) :-
    Row >= 2,
    RowAbove is Row-1,
    extract_element(Column, RowAbove, Board, Element),
    is_element_capturable(Player, Element),
    %Get element above the enemy
    OtherRow is Row-2,
    extract_element(Column, OtherRow, Board, Element1),
    Element1 \= empty, 
    \+is_element_capturable(Player, Element1).
    
%If not, make sure predicate succeeds and returns empty list
analyzeNormalUpCapture(_Board, _Player, _position, []).

%Check if a normal capture is possible downwards from the current position
analyzeNormalDownCapture(Board, Player, position(Column,Row), [down]) :-
    Row =< 6,
    RowBelow is Row+1,
    extract_element(Column, RowBelow, Board, Element),
    is_element_capturable(Player, Element),
    %Get element below the enemy
    OtherRow is Row+2,
    extract_element(Column, OtherRow, Board, Element1),
    Element1 \= empty, 
    \+is_element_capturable(Player, Element1).

%If not, make sure predicate succeeds and returns empty list
analyzeNormalDownCapture(_Board, _Player, _position, []).

%Check if a normal capture is possible leftwards from the current position
analyzeNormalLeftCapture(Board, Player, position(Column, Row), [left]) :-
    Column >= 2,
    ColumnToTheLeft is Column-1,
    extract_element(ColumnToTheLeft, Row, Board, Element),
    is_element_capturable(Player, Element),
    %Get element above the enemy
    OtherColumn is Column-2,
    extract_element(OtherColumn, Row, Board, Element1),
    Element1 \= empty, 
    \+is_element_capturable(Player, Element1).

%If not, make sure predicate succeeds and returns empty list
analyzeNormalLeftCapture(_Board, _Player, _position, []).

%Check if a normal capture is possible rightwards from the current position
analyzeNormalRightCapture(Board, Player, position(Column, Row), [right]) :-
    Column =< 6,
    ColumnToTheRight is Column+1,
    extract_element(ColumnToTheRight, Row, Board, Element),
    is_element_capturable(Player, Element),
    %Get element below the enemy
    OtherColumn is Column+2,
    extract_element(OtherColumn, Row, Board, Element1),
    Element1 \= empty, 
    \+is_element_capturable(Player, Element1).
%If not, make sure predicate succeeds and returns empty list
analyzeNormalRightCapture(_Board, _Player, _position, []).




%util - getPowerFromPiece

getPowerFromPiece(white1, 1).
getPowerFromPiece(white2, 2).
getPowerFromPiece(white3, 3).
getPowerFromPiece(white4, 4).
getPowerFromPiece(white5, 5).

getPowerFromPiece(black1, 1).
getPowerFromPiece(black2, 2).
getPowerFromPiece(black3, 3).
getPowerFromPiece(black4, 4).
getPowerFromPiece(black5, 5).


decreasePowerFromPiece(white2, white1).
decreasePowerFromPiece(white3, white2).
decreasePowerFromPiece(white4, white3).
decreasePowerFromPiece(white5, white4).

decreasePowerFromPiece(black2, black1).
decreasePowerFromPiece(black3, black2).
decreasePowerFromPiece(black4, black3).
decreasePowerFromPiece(black5, black4).



analyzeStrengthUpCapture(Board, Player, position(Column, Row), [up]) :-
    Row >= 1,
    RowAbove is Row-1,
    extract_element(Column, RowAbove, Board, Element),
    is_element_capturable(Player, Element),
    getPowerFromPiece(Element, EnemyPower),
    extract_element(Column, Row, Board, MyPiece),
    getPowerFromPiece(MyPiece, MyPower),
    MyPower > EnemyPower.

analyzeStrengthUpCapture(_Board, _Player, _position, []).

analyzeStrengthDownCapture(Board, Player, position(Column, Row), [down]) :-
    Row =< 7,
    RowBelow is Row+1,
    extract_element(Column, RowBelow, Board, Element),
    is_element_capturable(Player, Element),
    getPowerFromPiece(Element, EnemyPower),
    extract_element(Column, Row, Board, MyPiece),
    getPowerFromPiece(MyPiece, MyPower),
    MyPower > EnemyPower.
    

analyzeStrengthDownCapture(_Board, _Player, _position, []).

analyzeStrengthLeftCapture(Board, Player, position(Column, Row), [left]) :-
    Column >= 1,
    ColumnToTheLeft is Column-1,
    extract_element(ColumnToTheLeft, Row, Board, Element),
    is_element_capturable(Player, Element),
    getPowerFromPiece(Element, EnemyPower),
    extract_element(Column, Row, Board, MyPiece),
    getPowerFromPiece(MyPiece, MyPower),
    MyPower > EnemyPower.


analyzeStrengthLeftCapture(_Board, _Player, _position, []).


analyzeStrengthRightCapture(Board, Player, position(Column, Row), [right]) :-
    Column =< 7,
    ColumnToTheRight is Column+1,
    extract_element(ColumnToTheRight, Row, Board, Element),
    is_element_capturable(Player, Element),
    getPowerFromPiece(Element, EnemyPower),
    extract_element(Column, Row, Board, MyPiece),
    getPowerFromPiece(MyPiece, MyPower),
    MyPower > EnemyPower.
    
analyzeStrengthRightCapture(_Board, _Player, _position, []).


%===================APPLY CAPTURES===========================================================

%If there are no possible captures of any type, don't do anything
applyCaptures(Board, _position, [], [], Board).

%If there are no custodial captures but there is one strength capture available
applyCaptures(Board, position(Column, Row), [], StrengthCaptures, UpdatedBoard) :-
    length(StrengthCaptures, N), 
    N ==1, 
    nth0(0, StrengthCaptures, CaptureDirection),
    applyStrengthCapture(Board, position(Column, Row), CaptureDirection, UpdatedBoard).

%If there is 1 custodialCapture and 1 strengthCapture (its guaranteed they are both in the same direction)
%Apply normal Capture
applyCaptures(Board, position(Column, Row), CustodialCaptures, StrengthCaptures, UpdatedBoard) :-
    length(StrengthCaptures, N), 
    N ==1, 
    length(CustodialCaptures, C),
    C ==1, 
    nth0(0, CustodialCaptures, CaptureDirection),
    applyNormalCapture(Board, position(Column, Row), CaptureDirection, UpdatedBoard).


%If there are multiple custodialCaptures and no StrengthCapture
applyCaptures(Board, position(Column,Row), [H|T], [], UpdatedBoard) :-
    %apply capture to first direction
    %Call predicate again with NewCustodialCaptures (doesnt have the first direction which was already applied)
    applyNormalCapture(Board, position(Column, Row), H, TempBoard),
    applyCaptures(TempBoard, position(Column, Row), T, [], UpdatedBoard).


%If there are no custodial captures but there are multiple strength captures available
applyCaptures(Board, position(Column, Row), [], StrengthCaptures, UpdatedBoard) :-
    display_board(Board),
    ask_user_for_capture_direction(StrengthCaptures, Direction), /* TODO for EASY AI, get random direction for list */
    applyStrengthCapture(Board, position(Column, Row), Direction, UpdatedBoard).

%If there is one custodial capture and multiple strength captures available, user simply chooses the direction

applyCaptures(Board, position(Column, Row), CustodialCaptures, StrengthCaptures, UpdatedBoard) :-
    length(CustodialCaptures, N),
    N==1,
    display_board(Board),
    %Get list of possible directions with no duplicates
    setof(X, (member(X, CustodialCaptures) ; member(X, StrengthCaptures)), PossibleDirections), 
    ask_user_for_capture_direction(PossibleDirections, Direction),

    (memberchk(Direction, CustodialCaptures), NewCustodialCaptures=[Direction] ; NewCustodialCaptures = []),
    (memberchk(Direction, StrengthCaptures), NewStrengthCaptures=[Direction] ; NewStrengthCaptures = []),
    !, applyCaptures(Board, position(Column, Row), NewCustodialCaptures, NewStrengthCaptures, UpdatedBoard).

%There are multiple custodial captures available and there are strength captures available. User must choose which one
applyCaptures(Board, position(Column, Row), CustodialCaptures, StrengthCaptures, UpdatedBoard) :-
    display_board(Board),
    write('You have multiple capture types available.\n'),
    repeat,
        read_char('Please choose one (c - custodial, s - strength)\n', Input),
        (
            Input == 'c', applyCaptures(Board, position(Column, Row), CustodialCaptures, [], UpdatedBoard) ; 
            Input == 's', applyCaptures(Board, position(Column, Row), [], StrengthCaptures, UpdatedBoard)), !.


ask_user_for_capture_direction(StrengthCaptures, Direction) :-
    write('You can perform a capture in one of the following directions: '),
    write(StrengthCaptures),
    nl,
    repeat,
        read_char('Please choose (u/d/l/r)\n', Input),
        convert_input_to_direction(Input, Direction), 
        memberchk(Direction, StrengthCaptures),!. %Make sure its a valid move present in the possible moves




%Used in captures when it must ask the user in what direction he'd like to capture the opponent piece
convert_input_to_direction('u', up).
convert_input_to_direction('d', down).
convert_input_to_direction('l', left).
convert_input_to_direction('r', right).





applyStrengthCapture(Board, position(Column, Row), up, UpdatedBoard) :-
    %Replace element above my position by 'empty'
    NewRow is Row-1,
    replaceElement(NewRow, Column, empty, Board, TempBoard),
    %decrease my power by 1
    extract_element(Column, Row, Board, Piece),
    decreasePowerFromPiece(Piece, FinalPiece),
    %Replace in board.
    replaceElement(Row, Column, FinalPiece, TempBoard, UpdatedBoard).


applyStrengthCapture(Board, position(Column, Row), down, UpdatedBoard) :-
    %Replace element below my position by 'empty'
    NewRow is Row+1,
    replaceElement(NewRow, Column, empty, Board, TempBoard),
    %decrease my power by 1
    extract_element(Column, Row, Board, Piece),
    decreasePowerFromPiece(Piece, FinalPiece),
    %Replace in board.
    replaceElement(Row, Column, FinalPiece, TempBoard, UpdatedBoard).

applyStrengthCapture(Board, position(Column, Row), left, UpdatedBoard) :-
    %Replace element to the left of my position by 'empty'
    NewColumn is Column-1,
    replaceElement(Row, NewColumn, empty, Board, TempBoard),
    %decrease my power by 1
    extract_element(Column, Row, Board, Piece),
    decreasePowerFromPiece(Piece, FinalPiece),
    %Replace in board.
    replaceElement(Row, Column, FinalPiece, TempBoard, UpdatedBoard).

applyStrengthCapture(Board, position(Column, Row), right, UpdatedBoard) :-
    %Replace element to the right of my position by 'empty'
    NewColumn is Column+1,
    replaceElement(Row, NewColumn, empty, Board, TempBoard),
    %decrease my power by 1
    extract_element(Column, Row, Board, Piece),
    decreasePowerFromPiece(Piece, FinalPiece),
    %Replace in board.
    replaceElement(Row, Column, FinalPiece, TempBoard, UpdatedBoard).




%No need to do any verification. At this point, simply apply the capture
applyNormalCapture(Board, position(Column, Row), up, UpdatedBoard) :-
    RowAbove is Row-1,
    replaceElement(RowAbove, Column, empty, Board, UpdatedBoard).

applyNormalCapture(Board, position(Column, Row), down, UpdatedBoard) :-
    RowBelow is Row+1,
    replaceElement(RowBelow, Column, empty, Board, UpdatedBoard).

applyNormalCapture(Board, position(Column, Row), left, UpdatedBoard) :-
    LeftColumn is Column-1,
    replaceElement(Row, LeftColumn, empty, Board, UpdatedBoard).

applyNormalCapture(Board, position(Column, Row), right, UpdatedBoard) :-
    RightColumn is Column+1,
    replaceElement(Row, RightColumn, empty, Board, UpdatedBoard).