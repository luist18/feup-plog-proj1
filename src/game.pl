gameLoop :-
    initialBoard(InitialBoard),
    assert(state(1, InitialBoard)),
    repeat,
        retract(state(Player, CurrentBoard)),
        displayBoard(CurrentBoard),
        playerTurn(Player, CurrentBoard, NextPlayer, NextBoard),
        assert(state(NextPlayer, NextBoard)),
        endOfGame(2), !,
    showResult.


/*
    Purposely failing. This function will be responsible for checking the end condition of the game.
*/
endOfGame(N) :-
    N > 10, write('End game'), nl.

showResult :- 
    nl, write('GAME FINISHED').



/*
 Manage the player's turn, by asking which element to move and where to.
 TODO: Must check selected piece is not going over any pieces, nor landing on an occupied cell. 
*/
playerTurn(Player, Board, NextPlayer, UpdatedBoard) :-
    write('Player:'), write(Player), nl,
    
    /* Getting position of piece to move */
    repeat,
        write('CHOOSE ELEMENT TO MOVE\n'),
        manageRow(Old_Row),
        manageColumn(Old_Column),
        write('CHOOSE FINAL POSITION\n'),
        /* Getting the final position */
        manageRow(New_Row),
        manageColumn(New_Column),
        validateMove(Player, Old_Column, Old_Row, New_Column, New_Row, Board),!,

       
    % MakingMove
    extractElement(Old_Column, Old_Row, Board, Element ),
    replaceElement(Old_Row, Old_Column, empty, Board, SecondBoard),
    replaceElement(New_Row, New_Column, Element, SecondBoard, UpdatedBoard),
    /* TODO CheckForCapture */
    NextPlayer is ((Player rem 2) +1 ). /* Player will either be 1 or 2, depending on current Player.*/


/*
    Checks if move is valid
*/
validateMove(Player, Old_Column, Old_Row, New_Column, New_Row, Board) :-
    extractElement(Old_Column, Old_Row, Board, Element),
    isPieceSelectable(Element, Player),
    differentPositions(Old_Column, Old_Row, New_Column, New_Row),
    validBasicMove(Old_Column, Old_Row, New_Column, New_Row),
    checkForJumping(Old_Column, Old_Row, New_Column, New_Row, Board).
    

/* 
    This function will extract the element from Board, specifying the Row and Column
    extractElement(+Row, +Column, +Board, -Element) 
 */
extractElement(Column, Row, Board, Element) :-
    findnth(Row, Board, ExtractedRow),
    findnth(Column, ExtractedRow, Element).

/*
    Checks if Player (1 - White, 2 - Black) can choose the selected piece
*/
isPieceSelectable(Piece,Player) :-
    Piece \= mountain, Piece \= empty, Piece \= cave, 
    (Player == 1, Piece \= black1, Piece \= black2, Piece \= black3, Piece \= black4, Piece \= black5 ; 
    Player == 2, Piece \= white1, Piece \= white2, Piece \= white3, Piece \= white4, Piece \= white5).
    
/*
    Checks if initial and final positions are the same. 
*/
differentPositions(Old_Column, Old_Row, New_Column, New_Row) :-
    Old_Column =\= New_Column ; Old_Row =\= New_Row.

/*
    Will check the basics for the move to be valid. 
    Pieces only move orthogonally, so either column will be the same or row will be the same.
*/
validBasicMove(Old_Column, _, New_Column, _) :-
    Old_Column == New_Column.

validBasicMove(_, Old_Row, _, New_Row) :-
    Old_Row == New_Row.

/*
    Predicate responsible for checking if movement is valid or if it's jumping over any pieces.
*/
checkForJumping(Old_Column, Old_Row, New_Column, New_Row, Board):-
	Old_Column == New_Column,
	RowDifference is (New_Row-Old_Row),
	RowDifference < 0, %If difference is negative, piece is moving down
    checkForPiecesOnColumn(Old_Column, New_Row, Old_Row, Board).


checkForJumping(Old_Column, Old_Row, New_Column, New_Row, Board):-
	Old_Column == New_Column,
	RowDifference is (New_Row-Old_Row),
	RowDifference > 0, %If difference is positive, piece is moving up
    checkForPiecesOnColumn(Old_Column, Old_Row, New_Row, Board).

checkForJumping(Old_Column, Old_Row, New_Column, New_Row, Board):-
	Old_Row == New_Row,
	ColumnDifference is (New_Column-Old_Column),
	ColumnDifference < 0, %If difference is negative, piece is moving left
    checkForPiecesOnRow(Old_Row, New_Column, Old_Column, Board).

checkForJumping(Old_Column, Old_Row, New_Column, New_Row, Board):-
	Old_Row == New_Row,
	ColumnDifference is (New_Column-Old_Column),
	ColumnDifference > 0, %If difference is positive, piece is moving right
    checkForPiecesOnRow(Old_Row, Old_Column, New_Column, Board ).

/*
    Predicate responsible for checking whether there are any pieces in between the source row and destination row
*/
checkForPiecesOnColumn(_, Small_Row, Big_Row, _) :-
    CurrentRow is (Small_Row+1),
    CurrentRow > Big_Row.

checkForPiecesOnColumn(Column, Small_Row, Big_Row, Board) :-
    CurrentRow is (Small_Row+1),
    extractElement(Column, CurrentRow, Board, Element ),
    Element == empty, 
    checkForPiecesOnColumn(Column, CurrentRow, Big_Row, Board).

/*
    Predicate responsible for checking whether there are any pieces in between the source column and destination column
*/
checkForPiecesOnRow(_, Small_Column, Big_Column, _) :-
    CurrentColumn is (Small_Column +1),
    CurrentColumn > Big_Column.

checkForPiecesOnRow(Row, Small_Column, Big_Column, Board) :-
    CurrentColumn is (Small_Column +1),
    extractElement(CurrentColumn, Row, Board, Element),
    Element == empty,
    checkForPiecesOnRow(Row, CurrentColumn, Big_Column, Board).


