printColumnsRow :- 
    write(' | A  | B  | C  | D  | E  | F  | G  | H  | I  |'), nl.

printSeparator:-
    write('_______________________________________________'),nl.


initialBoard( [[mountain,black,black,black,black,black,black,black,mountain],
[empty,empty,empty,empty,black,empty,empty,empty,empty],
[empty,empty,empty,empty,empty,empty,empty,empty,empty],
[empty,empty,empty,empty,empty,empty,empty,empty,empty],
[cave,empty,empty,empty,cave,empty,empty,empty,cave],
[empty,empty,empty,empty,empty,empty,empty,empty,empty],
[empty,empty,empty,empty,empty,empty,empty,empty,empty],
[empty,empty,empty,empty,white,empty,empty,empty,empty],
[mountain,white,white,white,white,white,white,white,mountain]
]).

translate(empty, S)       :- S='    '.
translate(black, S)       :- S=' B  '.
translate(white, S)       :- S=' W  '.
translate(mountain, S)    :- S=' M  '.
translate(cave, S)        :- S=' C  '.
translate(whiteDragon, S) :- S=' WD '.
translate(blackDragon, S) :- S=' BD '.

letter(1, L) :- L='A'.
letter(2, L) :- L='B'.
letter(3, L) :- L='C'.
letter(4, L) :- L='D'.
letter(5, L) :- L='E'.
letter(6, L) :- L='F'.
letter(7, L) :- L='G'.
letter(8, L) :- L='H'.
letter(9, L) :- L='I'.

displayBoard(X) :-
    printColumnsRow,
    printSeparator,
    printMatrix(X,1).

printMatrix([]).


printMatrix([Head | Tail], N) :-
    N < 10, 
    write(N),
    write('|'),
    printList(Head),
    printSeparator,
    N1 is N+1, 
    printMatrix(Tail, N1).

printList([]) :- nl.

printList([Head|Tail]) :- 
    translate(Head, X),
    write(X), 
    write('|'), 
    printList(Tail).