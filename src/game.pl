game_loop :-
    initialBoard(InitialBoard),
    assert(state(1, InitialBoard)),
    repeat,
        retract(state(Player, CurrentBoard)),
        %write('\33\[2J'),
        display_board(CurrentBoard),
        player_turn(Player, CurrentBoard, NextPlayer, NextBoard),
        assert(state(NextPlayer, NextBoard)),
        end_of_game(2), !,
    show_result.


end_of_game(N) :-
    N > 10, write('End game'), nl.

show_result :- 
    nl, write('GAME FINISHED').

/*
 Manage the player's turn, by asking which element to move and where to.
 TODO: Must check selected piece is not going over any pieces, nor landing on an occupied cell. 
*/
player_turn(Player, Board, NextPlayer, UpdatedBoard) :-
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
    check_normal_captures(TempBoard, Player, position(New_Column, New_Row), TempBoard2), !,
    spawnDragons(TempBoard2, Player, UpdatedBoard), !,
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


check_normal_captures(Board, Player, position(New_Column, New_Row), FinalBoard) :-
    check_normal_up_captures(Board, Player, position(New_Column, New_Row), TempBoard), 
    check_normal_down_captures(TempBoard, Player, position(New_Column, New_Row), TempBoard2),
    check_normal_left_captures(TempBoard2, Player, position(New_Column, New_Row), TempBoard3),
    check_normal_right_captures(TempBoard3, Player, position(New_Column, New_Row), FinalBoard).


%===========================NORMAL CAPTURES=================================
check_normal_up_captures(Board, Player, position(Column, Row), UpdatedBoard) :-
    Row >= 2,
    RowAbove is Row-1,
    extract_element(Column, RowAbove, Board, Element),
    is_element_capturable(Player, Element),
    %Get element above the enemy
    OtherRow is Row-2,
    extract_element(Column, OtherRow, Board, Element1),
    Element1 \= empty, 
    \+is_element_capturable(Player, Element1), 
    replaceElement(RowAbove, Column, empty, Board, UpdatedBoard).

%Make sure predicate succeeds.
check_normal_up_captures(Board, _Player, _position, Board).

check_normal_down_captures(Board, Player, position(Column, Row), UpdatedBoard) :-
    Row =< 6,
    RowBelow is Row+1,
    extract_element(Column, RowBelow, Board, Element),
    is_element_capturable(Player, Element),
    %Get element below the enemy
    OtherRow is Row+2,
    extract_element(Column, OtherRow, Board, Element1),
    Element1 \= empty, 
    \+is_element_capturable(Player, Element1), 
    replaceElement(RowBelow, Column, empty, Board, UpdatedBoard).

%Make sure predicate succeeds.
check_normal_down_captures(Board, _Player, _position, Board).


check_normal_left_captures(Board, Player, position(Column, Row), UpdatedBoard) :-
    Column >= 2,
    ColumnToTheLeft is Column-1,
    extract_element(ColumnToTheLeft, Row, Board, Element),
    is_element_capturable(Player, Element),
    %Get element above the enemy
    OtherColumn is Column-2,
    extract_element(OtherColumn, Row, Board, Element1),
    Element1 \= empty, 
    \+is_element_capturable(Player, Element1), 
    replaceElement(Row, ColumnToTheLeft, empty, Board, UpdatedBoard).

%Make sure predicate succeeds.
check_normal_left_captures(Board, _Player, _position, Board).

check_normal_right_captures(Board, Player, position(Column, Row), UpdatedBoard) :-
    Column =< 6,
    ColumnToTheRight is Column+1,
    extract_element(ColumnToTheRight, Row, Board, Element),
    is_element_capturable(Player, Element),
    %Get element below the enemy
    OtherColumn is Column+2,
    extract_element(OtherColumn, Row, Board, Element1),
    Element1 \= empty, 
    \+is_element_capturable(Player, Element1), 
    replaceElement(Row, ColumnToTheRight, empty, Board, UpdatedBoard).

%Make sure predicate succeeds.
check_normal_right_captures(Board, _Player, _position, Board).

%===========================END================================================




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

spawnDragons(Board, Player, UpdatedBoard) :- 
    spawnLeftDragon(Board, Player, TempBoard),
    spawnMiddleDragon(TempBoard, Player, TempBoard2),
    spawnRightDragon(TempBoard2, Player, UpdatedBoard).


%White dragon
spawnLeftDragon(Board, 1, UpdatedBoard) :-
    %make sure dragon didn't spawn yet
    extract_element(0,4, Board, Element),
    Element == cave, 
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
    replaceElement(4,0, white3, Board, UpdatedBoard).
    
%Black Dragon
spawnLeftDragon(Board, 2, UpdatedBoard) :-
    %make sure dragon didn't spawn yet
    extract_element(0,4, Board, Element),
    Element == cave, 
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
    replaceElement(4,0, black3, Board, UpdatedBoard).


spawnLeftDragon(Board, _, Board).


%White dragon
spawnMiddleDragon(Board, 1, UpdatedBoard) :-
    %make sure dragon didn't spawn yet
    extract_element(4,4, Board, Element),
    Element == cave, 
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
    replaceElement(4,4, white5, Board, UpdatedBoard).

%Black dragon
spawnMiddleDragon(Board, 2, UpdatedBoard) :-
    %make sure dragon didn't spawn yet
    extract_element(4,4, Board, Element),
    Element == cave, 
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
    replaceElement(4,4, black5, Board, UpdatedBoard).

spawnMiddleDragon(Board, _, Board).

%White dragon
spawnRightDragon(Board, 1, UpdatedBoard) :-
    %make sure dragon didn't spawn yet
    extract_element(8,4, Board, Element),
    Element == cave, 
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
    replaceElement(4,8, white3, Board, UpdatedBoard).
    


%Black dragon
spawnRightDragon(Board, 2, UpdatedBoard) :-
    %make sure dragon didn't spawn yet
    extract_element(8,4, Board, Element),
    Element == cave, 
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
    replaceElement(4,8, black3, Board, UpdatedBoard).

spawnRightDragon(Board, _, Board).







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

