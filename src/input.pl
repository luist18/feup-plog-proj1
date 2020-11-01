/*
    :- readChar(-Input)
    Get input from user. Get 2 chars in order to ignore the newline
*/
readChar(Input) :-
    get_char(Input), 
    get_char(_). 


/*
    :- manageRow(-Old_Row)
    It will ask the user for the desired row and convert the input to the correct type.
*/
manageRow(Old_Row) :-
    write('Row?'),
    readChar(Row),
    convert_char_to_int(Row, Old_Row).

/*
    :- manageColumn(-Old_Column)
    It will ask the user for the desired column and convert the input to the correct type.
*/
manageColumn(Old_Column) :-
    write('Column?'),
    readChar(Column),
    convert_char_to_int(Column, Old_Column).



