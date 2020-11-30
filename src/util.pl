% Replaces an element in a list given an index.
%
% list_replace(+List, +Index, +NewValue, -ResultList)
list_replace([_|T], 0, X, [X|T]).

list_replace([H|T], I, X, [H|R]) :- 
    I > 0, 
    I1 is I - 1, 
    list_replace(T, I1, X, R).

% Replaces an element in a matrix given a row and a column.
%
% matrix_replace(+Matrix, +Row-Column, +Value, -ResultMatrix)
matrix_replace(Matrix, Row-Column, Value, ResultMatrix) :-
    nth0(Row, Matrix, ExtractedRow),
    list_replace(ExtractedRow, Column, Value, NewRow),
    list_replace(Matrix, Row, NewRow, ResultMatrix).

% Gets an element from a matrix.
%
% get_element(+Row-Column, +Matrix, -Element)
get_element(Row-Column, Board, Element) :-
    nth0(Row, Board, ExtractedRow),
    nth0(Column, ExtractedRow, Element).

extract_element(Column, Row, Board, Element) :-
    nth0(Row, Board, ExtractedRow),
    nth0(Column, ExtractedRow, Element).

% Converts a char to int. These conversions are based in our
% game problem.
%
% convert_char_to_int(+Char, -Integer)
convert_char_to_int('1', 1).
convert_char_to_int('2', 2).
convert_char_to_int('3', 3).
convert_char_to_int('4', 4).
convert_char_to_int('5', 5).
convert_char_to_int('6', 6).
convert_char_to_int('7', 7).
convert_char_to_int('8', 8).
convert_char_to_int('9', 9).

convert_char_to_int('A', 1).
convert_char_to_int('B', 2).
convert_char_to_int('C', 3).
convert_char_to_int('D', 4).
convert_char_to_int('E', 5).
convert_char_to_int('F', 6).
convert_char_to_int('G', 7).
convert_char_to_int('H', 8).
convert_char_to_int('I', 9).

range(Min, _, Min).
range(Min, Max, Val) :- NewMin is Min+1, Max >= NewMin, range(NewMin, Max, Val).

natnum(0).
natnum(N) :-
    natnum(N0),
    N is N0 + 1.

gen(A,B) :-
    natnum(N),
    range(0, N, B),
    A is N - B.