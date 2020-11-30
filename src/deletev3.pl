%player(Name, Username, Age)

player('Danny', 'Best Player Ever', 27).
player('Annie', 'Worst Player Ever', 24).
player('Harry', 'A-Star Player', 26).
player('Manny', 'The Player', 14).
player('Johnny', 'A Player', 16).

%game(Name, Categories, MinAge)

game('5 ATG', [action, adventure, open-world, multiplayer], 18).
game('Carrier Shift: Game Over', [action, fps, multiplayer, shooter], 16).
game('Duas Botas', [action, free, strategy, moba], 12).

%played(Player, Game, HoursPlayed, PercentUnlocked)
:- dynamic(played/4).
played('Best Player Ever', '5 ATG', 3, 83).
played('Worst Player Ever', '5 ATG', 52, 9).
played('The Player', 'Carrier Shift: Game Over', 44, 22).
played('A Player', 'Carrier Shift: Game Over', 48, 24).
played('A Star Player', 'Duas Botas', 37, 16).
played('Best Player Ever', 'Duas Botas', 33, 22).



%EX1 - %achievedALot(+Player)

achievedALot(Player) :-
  played(Player, _, _, Percentage),
  Percentage >= 80.

%EX2 - isAgeAppropriate(Player, Game)

isAgeAppropriate(Player, Game) :-
  game(Game, _, MinAge),
  player(Player, _, Age),
  Age >= MinAge.

%EX3 - timePlayingGames(Player, Games, -ListOfTimes, -SumTimes)


timePlayingGames(_, [], [], 0).
timePlayingGames(Player, [Game|T], [HoursPlayed|Ts], Total) :-
  played(Player, Game, HoursPlayed, _),
  timePlayingGames(Player, T, Ts, Total1),
  Total is HoursPlayed + Total1.
timePlayingGames(_,_, [0], 0).

%EX4 - list Games of Category(+Cat)


listGamesOfCategory(Cat) :-
  game(X, Categories, MinAge),
  member(Cat, Categories),
  write(X), write(' ('), write(MinAge), write(')'), nl,
  fail.

listGamesOfCategory(_Cat).


%EX5 - updatePlayer(+Player, +Game, +Hours, +Percentage)

updatePlayer(Player, Game, AdditionalHours, AdditionalPercentage) :-
  retract(played(Player, Game, Hours, Percentage)),
  NewHours is Hours+AdditionalHours, 
  NewPercentage is Percentage+AdditionalPercentage,
  assert(played(Player, Game, NewHours, NewPercentage)).

updatePlayer(Player, Game, Hours, Percentage) :-
  assert(played(Player, Game, NewHours, NewPercentage)).


%EX6 - fewHours(+Player, -Games)


fewHoursv2(Player, ListOfGames) :-
    findall(Game, (played(Player, Game, HoursPlayed, _), HoursPlayed<10), ListOfGames).


fewHours(Player, Games) :-
  fewHoursAux(Player, [], Games).

fewHoursAux(Player, AccGames, FinalGames) :-
  played(Player, GameTitle, HoursSpent, _),
  HoursSpent <10, 
  \+ (member(GameTitle, AccGames)),!,
  fewHoursAux(Player, [GameTitle | AccGames], FinalGames).

fewHoursAux(Player, FinalGames, FinalGames).



%EX 7 - ageRange(MinAge, MaxAge, Players) 

ageRange(MinAge, MaxAge, Players) :-
  findall(X, (player(X, _, Age), Age >= MinAge, Age =< MaxAge), Players).



%EX 8 - averageAge(Game, AverageAge) 

:- use_module(library(lists)).

averageAge(Game, AverageAge) :-
  findall(Age, (player(_Name, Username, Age ), played(Username, Game, _,_)), ListOfAges),
  length(ListOfAges, Amount),
  sumlist(ListOfAges, Total),
  AverageAge is Total/Amount.


%EX 9 - mostEffectivePlayers(Game, Players)


mostEffectivePlayers(Game, Results) :-
  findall(Ratio-Player, (played(Player, Game, HoursPlayed, PercentageUnlocked), Ratio is PercentageUnlocked/HoursPlayed), List).
  sort(List, SortedResults),
  reverse(SortedResults, Reversed)
  [MaxRatio-MaxPlayer | Rest] = Reversed,
  extractOtherTopPlayers(Rest, Extracted),
  append([MaxPlayer], Extracted, Results).

  





extractTopPlayers(SortedResults, [H|T]) :-


