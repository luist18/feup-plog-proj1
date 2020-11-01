/*
    :-replace_element_in_list(+List, +Index, +Value, -NewList)
    It will replace the element in List, specified by the Index, with a specific Value, returning the new list.
*/
replace_element_in_list([_|T], 0, X, [X|T]).
replace_element_in_list([H|T], I, X, [H|R]) :- 
    I > 0, 
    I1 is I-1, 
    replace_element_in_list(T, I1, X, R).

/*
    :- replaceElement(+Row, +Column, +Value, +OldList, -NewList)
    It will replace an element in a matrix, by specifying the row and column, as well as the value, returning the new List.
*/
replaceElement(Row,Column,Value,OldList,NewList) :-
    findnth(Row, OldList, ExtractedRow),
    replace_element_in_list(ExtractedRow, Column, Value, NewRow),
    replace_element_in_list(OldList, Row, NewRow, NewList).


/* 
    :- findnth(+N, +List, -ExtractedElement)
    Extract the element in the Nth position of List 
*/
findnth(0, [X|_], X).
findnth(K, [_|L], X) :- K1 is K-1, findnth(K1, L, X).


/*
    :- convert_char_to_int(+Char, -Int)
*/
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

