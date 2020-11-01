gameLoop(Board, Player1, Player2) :-
    /* Ask for move for Player 1 */
    displayGame(Board, Player1),
    playerTurn(Board,UpdatedBoard, Player1),
    displayGame(UpdatedBoard, Player2),
    playerTurn(UpdatedBoard, FinalBoard, Player2),
    gameLoop(FinalBoard, Player1, Player2).
    /*It will run indefinitely as we have no set end condition yet.*/

displayGame(GameState, Player) :-
    displayBoard(GameState),
    (Player=='White', write('White turn\n') ; Player=='Black', write('Black turn\n')).
    

playerTurn(Board, UpdatedBoard, _Player):-
    
    write('Choose element to move\n'),
    /* Getting position of piece to move */
    manageRow(Old_Row),
    manageColumn(Old_Column),
    Real_Old_Row is Old_Row-1, /*If row ==1, index in the list is 1-1=0 */
    Real_Old_Column is Old_Column-1,

    /* Extracting the element that is to be moved for analysis */
    findnth(Real_Old_Row, Board, ExtractedRow),
    findnth(Real_Old_Column, ExtractedRow, Element),
    
    /* Getting the final position */
    write('Moving element to final position.\n'),
    manageRow(New_Row),
    manageColumn(New_Column),
    Real_New_Row is New_Row-1,
    Real_New_Column is New_Column-1,
    replaceElement(Real_Old_Row, Real_Old_Column, empty, Board, SecondBoard),
    replaceElement(Real_New_Row, Real_New_Column, Element, SecondBoard, UpdatedBoard).




checkIfPieceIsSelectable(Player, Element, X) :-
    (Player =='White', (Element==white, X = 1 ; X = -1) ; Player=='Black', (Element==black, X = 1 ; X = -1)).