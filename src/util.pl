% Get input from user. Get 2 chars in order to ignore the newline
readChar(Input) :-
    get_char(Input), 
    get_char(_). 

%Replace element in list
%:-replace_element_in_list(+List, +Index, +Value, -NewList)
replace_element_in_list([_|T], 0, X, [X|T]).
replace_element_in_list([H|T], I, X, [H|R]) :- 
    I > 0, 
    I1 is I-1, 
    replace_element_in_list(T, I1, X, R).


% :- replaceElement(+Row, +Column, +Value, +OldList, -NewList)
replaceElement(Row,Column,Value,OldList,NewList) :-
    findnth(Row, OldList, ExtractedRow),
    replace_element_in_list(ExtractedRow, Column, Value, NewRow),
    replace_element_in_list(OldList, Row, NewRow, NewList).


/* Extract the element in the Nth position of List */
% :- findnth(+N, +List, -ExtractedElement)
findnth(0, [X|_], X).
findnth(K, [_|L], X) :- K1 is K-1, findnth(K1, L, X).