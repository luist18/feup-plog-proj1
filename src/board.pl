testBoard( [
    [mountain,black3,black2,black2,black2,black2,black2,black3,mountain],
    [empty,empty,empty,empty,black4,empty,empty,empty,empty],
    [empty,empty,empty,empty,empty,empty,empty,empty,empty],
    [white2,empty,empty,empty,empty,empty,empty,empty,empty],
    [cave_available,empty,empty,empty,cave_available,empty,empty,empty,cave_available],
    [white3,empty,empty,empty,empty,empty,empty,empty,empty],
    [empty,empty,empty,empty,empty,empty,empty,empty,empty],
    [empty,empty,empty,empty,white4,empty,empty,empty,empty],
    [mountain,white2,white2,white2,white2,white2,white2,white3,mountain]
]).

initialBoard( [
    [mountain,black3,black2,black2,black2,black2,black2,black3,mountain],
    [empty,empty,empty,empty,black4,empty,empty,empty,empty],
    [empty,empty,empty,empty,empty,empty,empty,empty,empty],
    [empty,empty,empty,empty,empty,empty,empty,empty,empty],
    [cave_available,empty,empty,empty,cave_available,empty,empty,empty,cave_available],
    [empty,empty,empty,empty,empty,empty,empty,empty,empty],
    [empty,empty,empty,empty,empty,empty,empty,empty,empty],
    [empty,empty,empty,empty,white4,empty,empty,empty,empty],
    [mountain,white3,white2,white2,white2,white2,white2,white3,mountain]
]).

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
    piece(Head, X, _, _),
    write(X), 
    write('|'), 
    print_list(Tail).