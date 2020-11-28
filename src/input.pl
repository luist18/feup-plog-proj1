% Reads a char.
%
% read_char(+Input)
read_char(Input) :-
    get_char(Input),
    get_char(_).

% Reads a dimension and stores the row/column index in the output variable.
%
% read_dimension(+Message, -Row)
read_char(Message, Char) :-
    write(Message),
    (
        read_line([H|T]),
        length([H|T], 1),
        char_code(Char, H)
        ;
        write('Invalid input, try again...'),
        nl,
        read_char(Message, Char)
    ).

% Reads the row from the player, it must be an integer between 1 and 9.
%
% read_row(+Message, -Row)
read_row(Message, Position) :-
    read_char(Message, RawPosition),
    (
        char_code(RawPosition, Code),
        Code >= 49,                                             % 49 is the ASCII code of 1
        Code =< 57,                                             % 57 is the ASCII code of 9
        convert_char_to_int(RawPosition, ConvertedPosition),
        Position is ConvertedPosition - 1
        ;
        write('Invalid row, try again...'),
        nl,
        read_row(Message, Position)
    ).

% Reads the column from the player, it must a char between A and I.
%
% read_column(+Message, -Column)
read_column(Message, Position) :-
    read_char(Message, RawPosition),
    (
        char_code(RawPosition, Code),
        Code >= 65,                                             % 65 is the ASCII code of A
        Code =< 73,                                             % 73 is the ASCII code of I
        convert_char_to_int(RawPosition, ConvertedPosition),
        Position is ConvertedPosition - 1
        ;
        write('Invalid column, try again...'),
        nl,
        read_column(Message, Position)
    ).

% Reads a move from the player, represented with a pair row-column.
%
% read_move(-Row-Column)
read_move(Row-Column) :-
    read_row('Next move row: ', Row), !,
    read_column('Next move column: ', Column), !.