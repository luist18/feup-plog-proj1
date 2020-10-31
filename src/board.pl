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

displayBoard(X) :-
    printColumnsRow,
    printSeparator,
    printMatrix(X,1),
    printColumnsRow. %This one is never called, so something is failing at the end of printMatrix

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