/*
    :- readChar(-Input)
    Get input from user. Get 2 chars in order to ignore the newline~
    TODO: Function is only reading 1 char + new line, game will probably break if user inputs more than 1 char.
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
    convert_char_to_int(Row, Row_tmp),
    Old_Row is Row_tmp-1. /*If row ==1, index in the list is 1-1=0 */

/*
    :- manageColumn(-Old_Column)
    It will ask the user for the desired column and convert the input to the correct type.
*/
manageColumn(Old_Column) :-
    write('Column?'),
    readChar(Column),
    convert_char_to_int(Column, Column_tmp),
    Old_Column is Column_tmp -1.



