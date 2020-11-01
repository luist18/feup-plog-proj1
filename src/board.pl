initialBoard( [
    [mountain,black3,black2,black2,black2,black2,black2,black3,mountain],
    [empty,empty,empty,empty,black4,empty,empty,empty,empty],
    [empty,empty,empty,empty,empty,empty,empty,empty,empty],
    [empty,empty,empty,empty,empty,empty,empty,empty,empty],
    [cave,empty,empty,empty,cave,empty,empty,empty,cave],
    [empty,empty,empty,empty,empty,empty,empty,empty,empty],
    [empty,empty,empty,empty,empty,empty,empty,empty,empty],
    [empty,empty,empty,empty,white4,empty,empty,empty,empty],
    [mountain,white3,white2,white2,white2,white2,white2,white3,mountain]
]).

middleBoard( [
    [mountain,empty,empty,black2,black2,empty,empty,black3,mountain],
    [empty,empty,empty,empty,empty,empty,empty,empty,empty],
    [empty,empty,empty,empty,empty,empty,empty,empty,empty],
    [empty,empty,empty,black2,black4,empty,empty,white2,empty],
    [cave,empty,empty,empty,cave,black2,white2,empty,cave],
    [empty,white2,empty,empty,empty,empty,empty,white2,empty],
    [empty,empty,empty,empty,empty,empty,empty,empty,empty],
    [empty,empty,empty,empty,white4,empty,empty,empty,empty],
    [mountain,empty,white2,empty,empty,empty,empty,empty,mountain]
]).

finalBoard( [
    [mountain,empty,empty,empty,black2,empty,empty,empty,mountain],
    [empty,empty,empty,empty,empty,empty,empty,empty,empty],
    [empty,empty,empty,empty,empty,empty,empty,empty,empty],
    [empty,empty,empty,empty,empty,empty,empty,empty,empty],
    [cave,empty,empty,empty,cave,empty,empty,empty,cave],
    [empty,empty,empty,black3,empty,black2,empty,empty,empty],
    [empty,empty,empty,empty,empty,empty,empty,empty,empty],
    [empty,empty,empty,empty,empty,white3,empty,empty,empty],
    [mountain,empty,empty,empty,empty,empty,empty,empty,mountain]
]).

translate(empty, S)        :- S='    '.
translate(black1, S)       :- S=' B1 '.
translate(black2, S)       :- S=' B2 '.
translate(black3, S)       :- S=' B3 '.
translate(black4, S)       :- S=' B4 '.
translate(black5, S)       :- S=' B5 '.
translate(white1, S)       :- S=' W1 '.
translate(white2, S)       :- S=' W2 '.
translate(white3, S)       :- S=' W3 '.
translate(white4, S)       :- S=' W4 '.
translate(white5, S)       :- S=' W5 '.
translate(mountain, S)     :- S=' M  '.
translate(cave, S)         :- S=' C  '.

printColumnsRow :- 
    write(' | A  | B  | C  | D  | E  | F  | G  | H  | I  |'), nl.

printSeparator:-
    write('_______________________________________________'),nl.

displayBoard(X) :-
    printColumnsRow,
    printSeparator,
    printMatrix(X,1).

printMatrix([], _N).

printMatrix([Head | Tail], N) :-
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