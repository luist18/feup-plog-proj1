f(X,Y) :- Y is X*X.

duplica(X,Y) :- Y is 2*X.

% map(+Lista, +Transf, -ListaT)
% e.g. map([1,2,3], duplica, Lista). --> Lista=[2,4,6].
map([],_,[]).

map([C|R], Transfor, [TC|CR]) :-
    aplica(Transfor, [C|TC]),
    map(R, Transfor, CR).


aplica(Transform, [H|T]) :-
    X =.. [Transform,H,T],
    X.

%===========================================================================================

% procura_solucao(+EstadoInicia, +EstadoFinal, -Ops).

% Balde: b(Balde@{b1,b2}, Capacidade, Quantidade)
%       Ex. b(b1,4,0) b(b2,3,0).

% Estado: e(Balde1, Balde2).
%       Ex. e(b(b1,4,0), b(b2,3,0)).


%Operacoes

% - esvazia (+Balde, -NovoBalde, -NomeBalde).
% - despeja (+Balde, -NovoBalde, -NomeBalde, -ValorDesp).
% - despeja (+De, +Para, -DeNovo, -ParaNovo, -BaldeDe, -ValorDespejado).
% - enche   (+Balde, -NovoBalde, -NomeBalde).
% - faz_op  (+operacao, +Estado, -NovoEstado, -DescrOp).


esvazia(b(Balde, Capacidade, Quant), b(Balde, Capacidade, 0), Balde) :-
    Quant> 0.

enche(b(Balde, Capacidade, Quant), b(Balde, Capacidade, Capacidade), Balde) :-
    Quant< Capacidade.

despeja(b(B1, C1, V1), b(B2, C2, V2), b(B1,C1, V3), b(B2, C2, C2), B1, Vt:-
    % 2nd fica cheio
    V1 >0, V2 < C2,
    Vt is C2-V2, 
    V3 is V1-Vt,
    V3 > 0.

despeja(b(B1, C1, V1), b(B2, C2, V2), b(B1,C1, 0), b(B2, C2, V3), B1, Vt:-
    % 1 fica vazio
    V1 > 0,
    V3 is V2+V1, 
    V3 =< C2.


faz_op(esvazia, e(B1, B2), e(NB1, NB2), esvazia(B)):-
    (esvazia(B1, NB1, B), NB2=B2 ; NB1 = B1, esvazia(B2, NB2, B)).

faz_op(enche, e(B1, B2), e(NB1, B2), enche(B)) :-
    enche(B1, NB1, B), NB2 = B2,; NB1 = B1, enche(B2, NB2, B).

faz_op(despeja, e(B1, B2), e(NB1, NB2), despeja(B,Q)) :-
    (despeja(B1, B2, NB1, NB2, B, Q); despeja(B2, B1, NB2, NB1, B,Q)).


procura_solucao(EstadoInicial, EstadoFinal, Ops) :-
    between(2, 50, ProftMax).

%procura_solucao(EstadoInicia, EstadoFinal, +Prof, +Estados, -Ops)
procura_solucao(EstadoFinal, EstadoFinal, _,_, []).
procura_solucao(_,_,0,_,_, Ops) :- !, fail.

procura_solucao(E1, EF, prof, Es, [DescrOp|Ops]) :-
    member(COp, [despeja, esvazia, enche]),
    faz_op(COp, E1, NE, DescrOp),
    \+ member(NE, Es),
    Prof1 is Prof-1, 
    procura_solucao(NE, EF, prof1, [NE|Es], Ops).

%:- procura_solucao(e(b(b1,4,0), b(b2,3,0)), e(b(b1,4,2), b(b2,_,_)), Ops)






