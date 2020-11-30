main_menu :-
	clear,
	nl,
	write('    Welcome to Three Dragons'),
	nl,
	nl,
	write('    1. Play'), nl,
	write('    2. Authors'), nl,
	write('    3. Exit'), nl,
	nl,
  read_char('Choose an option: ', Input),
  menu_option(Input).

menu_option('1') :- play_option.
menu_option('2') :- credits.
menu_option('3').

menu_option(_) :-
	write('Wrong input received. Please try again!'), nl, main_menu.

play_option :-
	clear,
	nl,
	write('          Three Dragons'), nl,
	write('        Select a gamemode'), nl,
	nl,
	nl,
	write('    1. Human vs Human'), nl,
	write('    2. Human vs Computer (easy)'), nl,
	write('    3. Human vs Computer (normal)'), nl,
	write('    4. Computer vs Computer'), nl,
	nl,
  read_char('Choose an option: ', Input),
	play_menu_option(Input).

play_menu_option('1') :- clear, game_loop(player_vs_player).
play_menu_option('2') :- clear, game_loop(player_vs_easy_bot).
play_menu_option('3') :- clear, game_loop(player_vs_normal_bot).
play_menu_option('4') :- clear, game_loop(bot_vs_bot).
play_menu_option(_) :- write('Wrong input received. Please try again!'), nl,main_menu.

credits :-
	clear,
	write('      Authors      '), nl,
	nl,
  write('- Fabio Moreira'), nl,
  write('- Luis Tavares'), nl.