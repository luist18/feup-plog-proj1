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
    This function will extract the element from Board, specifying the Row and Column
    extractElement(+Row, +Column, +Board, -Element) 
 */
extractElement(Row, Column, Board, Element) :-
    findnth(Row, Board, ExtractedRow),
    findnth(Column, ExtractedRow, Element).



/*
    Checks if Player (1 - White, 2 - Black) can choose the selected piece
*/
isPieceSelectable(Piece,Player) :-
    Piece \= mountain, Piece \= empty, Piece \= cave, 
    (Player == 1, Piece \= black1, Piece \= black2, Piece \= black3, Piece \= black4, Piece \= black5) ; 
    (Player == 2, Piece \= white1, Piece \= white1, Piece \= white1, Piece \= white1, Piece \= white1).
    



/*
 Manage the player's turn, by asking which element to move and where to.
 TODO: Must check if play is valid, aka moving orthogonally, not going over any pieces, not landing on an occupied cell. 
*/
playerTurn(Player, Board, NextPlayer, UpdatedBoard) :-
    write('Player:'), write(Player), nl,
    
    /* Getting position of piece to move */
    repeat,
        write('Choose element to move\n'),
        manageRow(Old_Row),
        manageColumn(Old_Column),

        /* Extracting the element that is to be moved for analysis */
        extractElement(Old_Row, Old_Column, Board, Element),
        isPieceSelectable(Element, Player), !,

    /* Getting the final position */
    repeat,
        manageRow(New_Row),
        manageColumn(New_Column), !,
    
    replaceElement(Old_Row, Old_Column, empty, Board, SecondBoard),
    replaceElement(New_Row, New_Column, Element, SecondBoard, UpdatedBoard),
    NextPlayer is ((Player rem 2) +1 ). /* Player will either be 1 or 2, depending on current Player.*/


