mainMenu :-
	write('================================='), nl,
	write('=         THREE DRAGONS         ='), nl,
	write('================================='), nl,
	write('=                               ='), nl,
	write('=   1. Play                     ='), nl,
	write('=   2. Credits                  ='), nl,
	write('=   3. Exit                     ='), nl,
	write('=                               ='), nl,
	write('================================='), nl,
    write('Choose an option:'), nl,
    readChar(Input),
    menuOption(Input).


menuOption('1') :- 
	
	initial(GameState), 
	displayBoard(GameState),
	gameLoop(GameState, 'White', 'Black').
	


menuOption('2') :- credits.
menuOption('3').
menuOption('4') :- 
    write('Wrong input received. Please try again!'), nl,
    mainMenu.


credits :-
    write('================================='), nl,
	write('=         THREE DRAGONS         ='), nl,
	write('================================='), nl,
	write('=                               ='), nl,
	write('= Game developed by:            ='), nl,
    write('= Fabio Moreira                 ='), nl,
    write('= Luis Tavares                  ='), nl,
	write('=                               ='), nl,
	write('================================='), nl.
  


  initial(GameState) :- initialBoard(GameState).

