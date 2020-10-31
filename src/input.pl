% Get input from user. Get 2 chars in order to ignore the newline
readChar(Input) :-
    get_char(Input), 
    get_char(_). 



manageRow(Old_Row) :-
    write('Row?'),
    get_char(Row), get_char(_),
    convert_char_to_int(Row, Old_Row),
    write(Old_Row),nl.

manageColumn(Old_Column) :-
    write('Column?'),
    get_char(Column), get_char(_),
    convert_char_to_int(Column, Old_Column),
    write(Old_Column),nl.


