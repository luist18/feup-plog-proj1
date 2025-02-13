% Holds the initial board.
%
% initial_board(-Board)
initial_board([
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

% Represents a piece of the board.
%
% piece(Name, TextRepresentation, Player, Value).
piece(empty, '    ', empty, 0).
piece(black1, ' B1 ', black, 1).
piece(black2, ' B2 ', black, 2).
piece(black3, ' B3 ', black, 3).
piece(black4, ' B4 ', black, 4).
piece(black5, ' B5 ', black, 5).
piece(white1, ' W1 ', white, 1).
piece(white2, ' W2 ', white, 2).
piece(white3, ' W3 ', white, 3).
piece(white4, ' W4 ', white, 4).
piece(white5, ' W5 ', white, 5).
piece(mountain, ' M  ', none, 0).
piece(cave_available, ' CA ', none, 0).
piece(cave_empty, ' CE ', none, 0).

% Prints the columns indicator.
print_columns_indicator :- 
    write(' | A  | B  | C  | D  | E  | F  | G  | H  | I  |'), nl.

% Prints a line separator.
print_separator:-
    write('_______________________________________________'),nl.

% Displays the board.
%
% display_board(+Board)
display_board(X) :-
    print_columns_indicator,
    print_separator,
    print_matrix(X,1).

% Prints a matrix.
% 
% print_matrix(+Matrix, +Size)
print_matrix([], _N).
print_matrix([Head | Tail], N) :-
    write(N),
    write('|'),
    print_list(Head),
    print_separator,
    N1 is N + 1, 
    print_matrix(Tail, N1).

% Prints a list
%
% print_list(+List)
print_list([]) :- nl.
print_list([Head|Tail]) :- 
    piece(Head, X, _, _),
    write(X), 
    write('|'), 
    print_list(Tail).