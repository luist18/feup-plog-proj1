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
    write('Moving element. Row?'),
    readChar(Old_Row),
    write('Column?'),
    readChar(Old_Column),
    replaceElement(Old_Row, Old_Column, empty, Board, WhiteBoard),
    write('Moving element to final position. Row?'),
    readChar(New_Row),
    write('Column?'),
    readChar(New_Column),
    replaceElement(New_Row, New_Column, white, WhiteBoard, UpdatedBoard).
