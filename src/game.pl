gameLoop(Board, Player1, Player2) :-
    /* Ask for move for Player 1 */
    write(Player1), write(' turn\n'),
    playerTurn(Board,UpdatedBoard, Player1),
    displayBoard(UpdatedBoard),
    write(Player2), write(' turn\n'),
    playerTurn(UpdatedBoard, FinalBoard, Player2),
    displayBoard(FinalBoard).
    /*Add call to gameLoop(FinalBoard, Player1, Player2)*/


playerTurn(Board, UpdatedBoard, Player):-
    (Player=='White', write('WHITE CHOOSING TURN\n') ; Player=='Black', write('BLACK CHOOSING PLAY\n')),
    write('Choose element to move\n'),
    manageRow(Old_Row),
    manageColumn(Old_Column),
    replaceElement(Old_Row-1, Old_Column-1, empty, Board, SecondBoard),
    write('Moving element to final position.\n'),
    manageRow(New_Row),
    manageColumn(New_Column),
    (Player=='White', replaceElement(New_Row-1, New_Column-1, white, SecondBoard, UpdatedBoard)) ; (Player=='Black', replaceElement(New_Row-1, New_Column-1, black, SecondBoard, UpdatedBoard)).




