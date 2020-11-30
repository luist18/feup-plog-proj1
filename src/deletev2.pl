%participant(Id,Age,Performance)
participant(1234, 17, 'Pé coxinho').
participant(3423, 21, 'Programar com os pés').
participant(3788, 20, 'Sing a Bit').
participant(4865, 22, 'Pontes de esparguete').
participant(8937, 19, 'Pontes de pen-drives').
participant(2564, 20, 'Moodle hack').

%performance(Id,Times)
performance(1234,[120,120,120,120]).
performance(3423,[32,120,45,120]).
performance(3788,[110,2,6,43]).
performance(4865,[120,120,110,120]).
performance(8937,[97,101,105,110]).



%EX1 - madeItThrough(Participant)

madeItThrough(Participant) :-
  performance(Participant, Times),
  member(120, Times).

%EX2 - juriTimes(+Participants, +JuriMember, -Times, -Total)


getNthElement(1, [H|_T], H).
getNthElement(N, [_H|T], Element) :-
  N1 is N-1,
  N1 > 0,
  getNthElement(N1, T, Element).

juriTimes([], _, [], 0).
juriTimes([H|T], JuriMember, [Hs|Ts], Total) :-
  performance(H, Times),
  getNthElement(JuriMember, Times, Hs),
  juriTimes(T, JuriMember, Ts, Total1),
  Total is Hs + Total1.


%EX3 - patientJuri(+JuriMember) //Juri member didnt press the button at least twice, tem pelo menos 2 120's

patientJuri(JuriMember) :-
  performance(X, Times), 
  getNthElement(JuriMember, Times, Time1),
  Time1 == 120, !, 
  %Find one participant so that juri didnt buzz him, and start finding a second one, different from the first. 
  %(cut) -> If nextParticipant search fails, no need to find the first one again.
  performance(Y, Times2),
  X \= Y, 
  getNthElement(JuriMember, Times2, Time2),
  Time2 == 120.

%EX4 - bestParticipant(+P1, +P2, -P)

sumElementsInList([], 0).
sumElementsInList([H|T], Total) :-
  sumElementsInList(T, Total1),
  Total is H + Total1.


bestParticipant(P1, P2, P) :-
  performance(P1, Times1),
  sumElementsInList(Times1, Total1),
  performance(P2, Times2),
  sumElementsInList(Times2, Total2),
  Total1 \= Total2,
  (Total1 > Total2, P = P1; P=P2).
  
%EX5 - allPerfs.

printIndividualPerformance(Participant) :-
  participant(Participant, _, Act),
  performance(Participant, Times),
  write(Participant), write(': '), 
  write(Act), write(':'),
  write(Times), nl.

allPerfs :-
  participant(X, _, _), 
  printIndividualPerformance(X), fail.

allPerfs.


allPerfsv2 :-
  findall(X, (participant(X,_,_), printIndividualPerformance(X)), _Results).


%EX6 - nSuccessfulParticipants(-T) - quantos participantes não tiveram qualquer clique no botão

countElementInList(_, [], 0).
countElementInList(X, [X|T], N) :-
  countElementInList(X, T, N1), !,
  N is N1+1.
countElementInList(X, [_H|T], N) :-
  countElementInList(X, T, N).


nSuccessfulParticipants(T) :-
  findall(X, (performance(X, Times), countElementInList(120, Times, N), length(Times, Length), N =:= Length), Results),
  length(Results, T).


%EX7 - juriFans(juriFanList)

getIndexOfElement(H, [H|_T], 1).
getIndexOfElement(X, [_H|T], N) :-
  getIndexOfElement(X, T, N1),
  N is N1+1.


juriFans(FinalList) :-
  findall(X-List, (individualFanList(X, List)), FinalList).

individualFanList(Participant, List) :-
  performance(Participant, Times), 
  findall(Y, (getIndexOfElement(120, Times, Y)), List).

%EX8 - nextPhase(N, Participants)
:- use_module(library(lists)).

getFirstNElements(0, _, []).

getFirstNElements(N, [H|T], [H|Ts]) :- 
  N > 0,
  N1 is N-1,
  getFirstNElements(N1, T, Ts).
  


eligibleOutcome(Id,Perf,TT) :-
    performance(Id,Times),
    madeItThrough(Id),
    participant(Id,_,Perf),
    sumlist(Times,TT).


nextPhase(N, Participants) :-
  findall(Result, (setof(Total-Participant-Performance, (participant(Participant,_, Performance), eligibleOutcome(Participant, Performance, Total)), Result)), Results),
  sort(Results, Temp),
  reverse(Temp, Sorted),
  getFirstNElements(N, Sorted, Participants).

%EX9 - 