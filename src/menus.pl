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


menu_option('1') :- play_option.
menu_option('2') :- credits.
menu_option('3').

menu_option(_) :-
	write('Wrong input received. Please try again!'), nl,main_menu.



play_option :- 
	write('================================='), nl,
	write('=         PLAY                  ='), nl,
	write('================================='), nl,
	write('=                               ='), nl,
	write('=   1. HUMAN VS HUMAN           ='), nl,
	write('=   2. HUMAN VS COMPUTER        ='), nl,
	write('=   3. COMPUTER VS COMPUTER     ='), nl,
	write('=                               ='), nl,
	write('================================='), nl,
  write('Choose an option: '), nl,
	read_char(Input),
	play_menu_option(Input).




	play_menu_option('1') :- game_loop.
	play_menu_option('2') :- player_vs_easy_bot. /* TODO */
	play_menu_option('3'). /* TODO */
	play_menu_option(_) :- write('Wrong input received. Please try again!'), nl,main_menu.



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