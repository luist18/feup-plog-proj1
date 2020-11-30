:- use_module(library(lists)).


test :- 
  nl,
  write('Welcome.'), nl,
  repeat, 
    write('Print this message again? (yes/no)'),
    get_char(Input), 
    get_char(_),
    nl,
    write('You selected '),
    write(Input),
    write('.'), nl,
    Input == 'n',!,
  repeat, % Otherwise, repeat.
  write('Print this message again v2.0? (yes/no)'),
    get_char(Input), 
    get_char(_),
    nl,
    write('You selected '),
    write(Input),
    write('.'), nl,
    Input == 'n',!.


%initial(-GameState) 

%participant(Id,Age,Performance)
participant(1234, 17, 'Pé coxinho').
participant(3423, 21, 'Programar com os pés').
participant(8937, 19, 'Pontes de pen-drives').
participant(2564, 20, 'Moodle hack').
participant(3788, 20, 'Sing a Bit').
participant(4865, 22, 'Pontes de esparguete').



%performance(Id,Times)
performance(1234,[120,120,120,120]).
performance(3423,[32,120,45,120]).
performance(3788,[110,2,6,43]).
performance(4865,[120,120,110,120]).
performance(8937,[97,101,105,110]).

%madeItThrough(+Participant)
madeItThrough(Participant) :-
  performance(Participant, List),
  countElementsInList(120, List, N),
  N \= 0.



%countElementsInList(Element,[H|T], N) 
countElementsInList(_, [], 0).

countElementsInList(Element, [Element|T], N) :-
  countElementsInList(Element, T, N1),
  N is N1+1.

countElementsInList(Element, [_H|T], N ):-
  countElementsInList(Element, T, N).


%juriTimes(+Participants, +JuriMember, -Times, -Total) :-
individualJuriTime(Participant, JuriMember, Time) :-
  performance(Participant, List),
  getNthElement(JuriMember, List, Time).

juriTimes([], _,[],0).

juriTimes([H|T], JuriMember, [H1|T1], Total) :-
  individualJuriTime(H, JuriMember, H1),
  juriTimes(T, JuriMember, T1, Total2),
  Total is Total2 + H1.



%getNthElement(Index, List, Element)

getNthElement(1, [H|_T], H).
getNthElement(N, [_H|T], X) :-
  N1 is N-1,
  N1 > 0, 
  getNthElement(N1, T, X).


%getIndexOfElements(Element, List, Index)

getIndexOfElement(H, [H|_T], 1).
getIndexOfElement(X, [_H|T], N) :-
  getIndexOfElement(X, T, N1),
  N is N1+1.


%patient(+JuriMember)
%Não carregou no botão pelo menos duas vezes -> tem pelo menos 2 120's
:- dynamic(abstentions/1).

abstentions(0).

patient(JuriMember):-
  
  patientWrapped(JuriMember),
  abstentions(Abstentions),
  Abstentions >= 2.


patientWrapped(JuriMember) :-

  performance(_, List),
  getNthElement(JuriMember, List, Time),
  
  Time =:= 120,
  abstentions(Abstentions),
  NewAbstentions is Abstentions+1,
  assert(abstentions(NewAbstentions)),
  retract(abstentions(Abstentions)).


  %bestParticipant(P1, P2, -P)

  sumElementsInList([], 0).

  sumElementsInList([H|T], Total) :-
    sumElementsInList(T, Total1),
    Total is H + Total1. 

  bestParticipant(P1, P2, P):-
    performance(P1, TimesP1),
    sumElementsInList(TimesP1, TotalP1),
    performance(P2, TimesP2),
    sumElementsInList(TimesP2, TotalP2),
    TotalP1 \= TotalP2, 
    (TotalP1 > TotalP2, P = P1 ; P=P2).


%allPerfs.
allPerfs:-
    participant(X,_,_),
    printIndividualPerformance(X),
    fail.

allPerfs.

printIndividualPerformance(Participant):-
    
  participant(Participant, _, Performance),
  performance(Participant, Times),
  write(Participant), write(':'), 
  write(Performance), write(':'),
  write(Times), nl.


allPerfsV2:-
  findall(X, (participant(X,_,_), printIndividualPerformance(X)), _Results).


%nSuccessfulParticipants(-T)

nSuccessfulParticipants(T):-
  findall(X, (performance(X, Times),
  countElementsInList(120, Times, AmountOf120),
  length(Times, N),
  AmountOf120 =:= N), Results),
  length(Results, T).


%juriFans(juriFansList)


juriFans(Sorted):-
  findall(X-Sublist, (participant(X,_,_), test(X,Sublist)), Results),
  sort(Results, Sorted).




test(X, SubList) :-
performance(X, Times),
findall(Y, (getIndexOfElement(120, Times, Y)), SubList).



%nextPhase(+N, -Participants)

:- use_module(library(lists)).

eligibleOutcome(Id,Perf,TT) :-
    performance(Id,Times),
    madeItThrough(Id),
    participant(Id,_,Perf),
    sumlist(Times,TT).



getFirstNElements(_, [], []).
getFirstNElements(0, _, []).
getFirstNElements(N, [H|T], [H|T1]) :-
  N > 0, 
  N1 is N-1,
  getFirstNElements(N1, T, T1).


nextPhase(N, Participants) :-
  findall(Result, setof(Total-X-Perf, (performance(X,_), eligibleOutcome(X, Perf, Total)), Result), Results),
  length(Results, Length),
  Length >=N, 
  sort(Results, Sorted),
  reverse(Sorted, FinalList),
  getFirstNElements(N, FinalList, Participants),!.


%=================================================
impoe(X,L) :-
    length(Mid,X),
    append(L1,[X|_],L), append(_,[X|Mid],L1).