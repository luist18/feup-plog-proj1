printColumnsRow :- 
    write(' | A  | B  | C  | D  | E  | F  | G  | H  | I  |'), nl.

printSeparatorLine :-
    write('_______________________________________________'), nl.

printInitialBoard :- 
    printColumnsRow,
    printSeparatorLine,
    write('1| M  | W3 | W2 | W2 | W2 | W2 | W2 | W3 | M  |'), nl,
    printSeparatorLine, 
    write('2|    |    |    |    | W4 |    |    |    |    |'), nl,
    printSeparatorLine,
    write('3|    |    |    |    |    |    |    |    |    |'), nl,
    printSeparatorLine,
    write('4|    |    |    |    |    |    |    |    |    |'), nl,
    printSeparatorLine,
    write('5| DC |    |    |    | DC |    |    |    | DC |'), nl,
    printSeparatorLine,
    write('6|    |    |    |    |    |    |    |    |    |'), nl,
    printSeparatorLine,
    write('7|    |    |    |    |    |    |    |    |    |'), nl,
    printSeparatorLine,
    write('8|    |    |    |    | B4 |    |    |    |    |'), nl,
    printSeparatorLine,
    write('9| M  | B3 | B2 | B2 | B2 | B2 | B2 | B3 | M  |'), nl,
    printSeparatorLine,
    printColumnsRow.