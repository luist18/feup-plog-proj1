game_loop :-
    initialBoard(InitialBoard),
    assert(state(1, InitialBoard, available_caves(true-true-true))),
    repeat,
        retract(state(Player, CurrentBoard, available_caves(C1-C2-C3))),
        write('After retracting state, caves are '), write(C1-C2-C3), nl,
        %write('\33\[2J'),
        display_board(CurrentBoard),
        player_turn(Player, CurrentBoard, NextPlayer, NextBoard, available_caves(C1-C2-C3), available_caves(X1-X2-X3)),
        assert(state(NextPlayer, NextBoard, available_caves(X1-X2-X3))),
        end_of_game(2), !,
    show_result.


end_of_game(N) :-
    N > 10, write('End game'), nl.

show_result :- 
    nl, write('GAME FINISHED').

/*
 Manage the player's turn, by asking which element to move and where to.
 
*/
player_turn(Player, Board, NextPlayer, UpdatedBoard, available_caves(C1-C2-C3), available_caves(X1-X2-X3)) :-
    write('Player:'), write(Player), nl,
    
    /* Getting position of piece to move */
    repeat,
        write('CHOOSE ELEMENT TO MOVE\n'),
        read_move(Old_Row-Old_Column),
        write('CHOOSE FINAL POSITION\n'),
        /* Getting the final position */
        read_move(New_Row-New_Column),
        validate_move(Player, Old_Column, Old_Row, New_Column, New_Row, Board), !,

    extract_element(Old_Column, Old_Row, Board, Element ),
    make_move(Old_Column, Old_Row, New_Column, New_Row, Board, Element, TempBoard),
    /* TODO CheckForCapture */
    analyzeCaptures(TempBoard, Player, position(New_Column, New_Row), CustodialCaptures, StrengthCaptures),
    write('POWER CAPTURES: '), write(CustodialCaptures),nl,
    write('STRENGTH CAPTURES: '), write(StrengthCaptures),nl,
    applyCaptures(TempBoard, Player, position(New_Column, New_Row), CustodialCaptures, StrengthCaptures, TempBoard2), !,
    %check_normal_captures(TempBoard, Player, position(New_Column, New_Row), TempBoard2), !,
    spawnDragons(TempBoard2, Player, UpdatedBoard, available_caves(C1-C2-C3), available_caves(X1-X2-X3)), !,
 
    NextPlayer is ((Player rem 2) +1 ). /* Player will either be 1 or 2, depending on current Player.*/


/*
    Predicate responsible for moving the elements in the board
*/
make_move(Old_Column, Old_Row, New_Column, New_Row, Board, Element, UpdatedBoard) :-
    replaceElement(Old_Row, Old_Column, empty, Board, SecondBoard),
    replaceElement(New_Row, New_Column, Element, SecondBoard, UpdatedBoard).

/*
    Checks if move is valid
*/
validate_move(Player, Old_Column, Old_Row, New_Column, New_Row, Board) :-
    extract_element(Old_Column, Old_Row, Board, Element),
    is_piece_selectable(Element, Player),
    different_positions(Old_Column, Old_Row, New_Column, New_Row),
    valid_basic_move(Old_Column, Old_Row, New_Column, New_Row),
    check_for_jumping(Old_Column, Old_Row, New_Column, New_Row, Board).
    
/* 
    This function will extract the element from Board, specifying the Row and Column
    extract_element(+Row, +Column, +Board, -Element) 
 */
extract_element(Column, Row, Board, Element) :-
    nth0(Row, Board, ExtractedRow),
    nth0(Column, ExtractedRow, Element).

/*
    Checks if Player (1 - White, 2 - Black) can choose the selected piece
*/
is_piece_selectable(Piece,Player) :-
    Piece \= mountain, Piece \= empty, Piece \= cave, 
    (Player == 1, Piece \= black1, Piece \= black2, Piece \= black3, Piece \= black4, Piece \= black5 ; 
    Player == 2, Piece \= white1, Piece \= white2, Piece \= white3, Piece \= white4, Piece \= white5).
    
/*
    Checks if initial and final positions are the same. 
*/
different_positions(Old_Column, Old_Row, New_Column, New_Row) :-
    Old_Column =\= New_Column ; Old_Row =\= New_Row.

/*
    Will check the basics for the move to be valid. 
    Pieces only move orthogonally, so either column will be the same or row will be the same.
*/
valid_basic_move(Old_Column, _, New_Column, _) :-
    Old_Column == New_Column.

valid_basic_move(_, Old_Row, _, New_Row) :-
    Old_Row == New_Row.

/*
    Predicate responsible for checking if movement is valid or if it's jumping over any pieces.
*/
check_for_jumping(Old_Column, Old_Row, New_Column, New_Row, Board):-
	Old_Column == New_Column,
	RowDifference is (New_Row-Old_Row),
	RowDifference < 0, %If difference is negative, piece is moving up
    check_for_pieces_on_column(Old_Column, New_Row-1, Old_Row-1, Board).

check_for_jumping(Old_Column, Old_Row, New_Column, New_Row, Board):-
	Old_Column == New_Column,
	RowDifference is (New_Row-Old_Row),
	RowDifference > 0, %If difference is positive, piece is moving down
    check_for_pieces_on_column(Old_Column, Old_Row, New_Row, Board).

check_for_jumping(Old_Column, Old_Row, New_Column, New_Row, Board):-
	Old_Row == New_Row,
	ColumnDifference is (New_Column-Old_Column),
	ColumnDifference < 0, %If difference is negative, piece is moving left
    check_for_pieces_on_row(Old_Row, New_Column-1, Old_Column-1, Board).

check_for_jumping(Old_Column, Old_Row, New_Column, New_Row, Board):-
	Old_Row == New_Row,
	ColumnDifference is (New_Column-Old_Column),
	ColumnDifference > 0, %If difference is positive, piece is moving right
    check_for_pieces_on_row(Old_Row, Old_Column, New_Column, Board ).

/*
    Predicate responsible for checking whether there are any pieces in between the source row and destination row
*/
check_for_pieces_on_column(_, Small_Row, Big_Row, _) :-
    CurrentRow is (Small_Row+1),
    CurrentRow > Big_Row.

check_for_pieces_on_column(Column, Small_Row, Big_Row, Board) :-
    CurrentRow is (Small_Row+1),
    extract_element(Column, CurrentRow, Board, Element ),
    Element == empty, 
    check_for_pieces_on_column(Column, CurrentRow, Big_Row, Board).

/*
    Predicate responsible for checking whether there are any pieces in between the source column and destination column
*/
check_for_pieces_on_row(_, Small_Column, Big_Column, _) :-
    CurrentColumn is (Small_Column +1),
    CurrentColumn > Big_Column.

check_for_pieces_on_row(Row, Small_Column, Big_Column, Board) :-
    CurrentColumn is (Small_Column +1),
    extract_element(CurrentColumn, Row, Board, Element),
    Element == empty,
    check_for_pieces_on_row(Row, CurrentColumn, Big_Column, Board).



%Succeeds if Player can capture Piece.
%is_element_capturable(+Player, +Piece)
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

spawnDragons(Board, Player, UpdatedBoard, available_caves(C1-C2-C3), available_caves(X1-X2-X3)) :- 
    spawnLeftDragon(Board, Player, TempBoard, C1,X1),
    spawnMiddleDragon(TempBoard, Player, TempBoard2,C2,X2),
    spawnRightDragon(TempBoard2, Player, UpdatedBoard, C3,X3).


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
%Initially, CustodialCaptures = []
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
    

analyzeNormalUpCapture(_Board, _Player, _position, []).

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

analyzeNormalDownCapture(_Board, _Player, _position, []).






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


analyzeNormalLeftCapture(_Board, _Player, _position, []).


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
applyCaptures(Board, _Player, _position, [], [], Board).

%If there are no custodial captures but there is one strength capture available
applyCaptures(Board, Player, position(Column, Row), [], StrengthCaptures, UpdatedBoard) :-
    length(StrengthCaptures, N), 
    N ==1, 
    nth0(0, StrengthCaptures, CaptureDirection),
    applyStrengthCapture(Board, Player, position(Column, Row), CaptureDirection, UpdatedBoard).

%If there is 1 custodialCapture and 1 strengthCapture (its guaranteed they are both in the same direction)
%Apply normal Capture
applyCaptures(Board, Player, position(Column, Row), CustodialCaptures, StrengthCaptures, UpdatedBoard) :-
    length(StrengthCaptures, N), 
    N ==1, 
    length(CustodialCaptures, C),
    C ==1, 
    nth0(0, CustodialCaptures, CaptureDirection),
    applyNormalCapture(Board, Player, position(Column, Row), CaptureDirection, UpdatedBoard).

%If there are no custodial captures but there are multiple strength captures available
applyCaptures(Board, Player, position(Column, Row), [], StrengthCaptures, UpdatedBoard).

%If there are custodial captures and multiple strength captures available
%Will eventually have to ask user for input
applyCaptures(Board, Player, position(Column, Row), CustodialCaptures, StrengthCaptures, UpdatedBoard).



applyStrengthCapture(Board, Player, position(Column, Row), up, UpdatedBoard) :-
    %Replace element above my position by 'empty'
    NewRow is Row-1,
    replaceElement(NewRow, Column, empty, Board, TempBoard),
    %decrease my power by 1
    extract_element(Column, Row, Board, Piece),
    decreasePowerFromPiece(Piece, FinalPiece),
    %Replace in board.
    replaceElement(Row, Column, FinalPiece, TempBoard, UpdatedBoard).


applyStrengthCapture(Board, Player, position(Column, Row), down, UpdatedBoard) :-
    %Replace element below my position by 'empty'
    NewRow is Row+1,
    replaceElement(NewRow, Column, empty, Board, TempBoard),
    %decrease my power by 1
    extract_element(Column, Row, Board, Piece),
    decreasePowerFromPiece(Piece, FinalPiece),
    %Replace in board.
    replaceElement(Row, Column, FinalPiece, TempBoard, UpdatedBoard).

applyStrengthCapture(Board, Player, position(Column, Row), left, UpdatedBoard) :-
    %Replace element to the left of my position by 'empty'
    NewColumn is Column-1,
    replaceElement(Row, NewColumn, empty, Board, TempBoard),
    %decrease my power by 1
    extract_element(Column, Row, Board, Piece),
    decreasePowerFromPiece(Piece, FinalPiece),
    %Replace in board.
    replaceElement(Row, Column, FinalPiece, TempBoard, UpdatedBoard).

applyStrengthCapture(Board, Player, position(Column, Row), right, UpdatedBoard) :-
    %Replace element to the right of my position by 'empty'
    NewColumn is Column+1,
    replaceElement(Row, NewColumn, empty, Board, TempBoard),
    %decrease my power by 1
    extract_element(Column, Row, Board, Piece),
    decreasePowerFromPiece(Piece, FinalPiece),
    %Replace in board.
    replaceElement(Row, Column, FinalPiece, TempBoard, UpdatedBoard).




%No need to do any verification. At this point, simply apply the capture
applyNormalCapture(Board, Player, position(Column, Row), up, UpdatedBoard) :-
    RowAbove is Row-1,
    replaceElement(RowAbove, Column, empty, Board, UpdatedBoard).

applyNormalCapture(Board, Player, position(Column, Row), down, UpdatedBoard) :-
    RowBelow is Row+1,
    replaceElement(RowBelow, Column, empty, Board, UpdatedBoard).

applyNormalCapture(Board, Player, position(Column, Row), left, UpdatedBoard) :-
    LeftColumn is Column-1,
    replaceElement(Row, LeftColumn, empty, Board, UpdatedBoard).

applyNormalCapture(Board, Player, position(Column, Row), right, UpdatedBoard) :-
    RightColumn is Column+1,
    replaceElement(Row, RightColumn, empty, Board, UpdatedBoard).