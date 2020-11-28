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

translate(empty, '    ').
translate(black1, ' B1 ').
translate(black2, ' B2 ').
translate(black3, ' B3 ').
translate(black4, ' B4 ').
translate(black5, ' B5 ').
translate(white1, ' W1 ').
translate(white2, ' W2 ').
translate(white3, ' W3 ').
translate(white4, ' W4 ').
translate(white5, ' W5 ').
translate(mountain, ' M  ').
translate(cave, ' C  ').

print_columns_indicator :- 
    write(' | A  | B  | C  | D  | E  | F  | G  | H  | I  |'), nl.

print_separator:-
    write('_______________________________________________'),nl.

display_board(X) :-
    print_columns_indicator,
    print_separator,
    print_matrix(X,1).

print_matrix([], _N).
print_matrix([Head | Tail], N) :-
    write(N),
    write('|'),
    print_list(Head),
    print_separator,
    N1 is N + 1, 
    print_matrix(Tail, N1).

print_list([]) :- nl.
print_list([Head|Tail]) :- 
    translate(Head, X),
    write(X), 
    write('|'), 
    print_list(Tail).