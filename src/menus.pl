main_menu :-
	write('================================='), nl,
	write('=         THREE DRAGONS         ='), nl,
	write('================================='), nl,
	write('=                               ='), nl,
	write('=   1. Play                     ='), nl,
	write('=   2. Credits                  ='), nl,
	write('=   3. Exit                     ='), nl,
	write('=                               ='), nl,
	write('================================='), nl,
  write('Choose an option: '), nl,
  read_char(Input),
  menu_option(Input).


menu_option('1') :- gameLoop.
menu_option('2') :- credits.
menu_option('3').

menu_option(_) :-
	write('Wrong input received. Please try again!'), nl,mainMenu.

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