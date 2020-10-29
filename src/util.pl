% Get input from user. Get 2 chars in order to ignore the newline
readChar(Input) :-
    get_char(Input), 
    get_char(_). 