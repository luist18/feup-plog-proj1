%Estado de jogo de xadrez

% estado_jogo(tabuleiro(1/[0,0,0,0,0,0,0,0], 2/[0,0,0,0,0,0,0,0], ..., 8/[0,0,0,0,0,0,0,0]), 
%    PecasBrancas, 
%    PecasPretas, 
%    Jogador).

%Acesso a estrutura de dados
/*
    pecas_do_jogador(b,e(_Tabuleiro,B,_P,_), B).
    pecas_do_jogador(p,e(_Tabuleiro, _B, P, _), P).
    jogador(e(_T,_B,_P, Jogador), Jogador).
    tabuleiro(e(Tabuleiro, _B, _P, _Jogador), Tabuleiro).
*/

%peca(Tipo, Jogador, Id).

%Tipo : peao, torre, bispo, cavalo, rainha, rei.

%Jogador: b,p
/*
    peca(peao, b, N) :- between(1,8,N).
    peca(torre, b, N) :- between(9, 10, N).
    peca(cavalo, b, N) :- between(11,12, N).
    peca(bispo, b, N) :- between(13,14, N).
    peca(rainha, b, 15).
    peca(rei, b, 16).

    peca(peao, w, N) :- between(17,24,N).
    peca(torre, w, N) :- between(25, 26, N).
    peca(cavalo, w, N) :- between(27,28, N).
    peca(bispo, w, N) :- between(29,30, N).
    peca(rainha, w, 31).
    peca(rei, w, 32).

*/

/*estado_inicial(estado_jogo(tabuleiro(
                                        1/[9,11,13,15,16,14,12,10],
                                        2/[1,2,3,4,5,6,7,8],
                                        3/[0,0,0,0,0,0,0,0],
                                        4/[0,0,0,0,0,0,0,0],
                                        5/[0,0,0,0,0,0,0,0],
                                        6/[0,0,0,0,0,0,0,0],
                                        7/[17,18,19,20,21,22,23,24],
                                        8/[25,27,29,31,32,30,28,26]

)))
*/


%valor_posicao(+Pos@{x/y}, -Valor).
/*
    valor_posicao(X/Y,1) :- %exterior
        (X==1; X==8; Y==1; Y==8), !.
    valor_posicao(X/Y,1.1) :- 
        (X==2; X==7; Y==2; Y==7), !.
    valor_posicao(X/Y,1.2) :- 
        (X==3; X==6; Y==3; Y==6), !.
    valor_posicao(X/Y,1.3) :- %interior
        (X==4; X==5; Y==4; Y==5), !.

*/

% valor_peca(+Peca, -Valor).
/*
    valor_peca(peao,1).
    valor_peca(torre, 10).
    valor_peca(cavalo, 20).
    valor_peca(bispo, 20).
    valor_peca(rainha, 50).
    valor_peca(rei, 0).





*/




%utilidade (+EstadoJogo, -Valor).
/*
    utilidade(EstadoJogo, Valor) :-
        utilidade_das_pecas(Pecas, EstadoJogo, Valor), !.
*/

%utilidade_das_pecas(+Lista,+EstadoJogo, -Valor)
/*
    utilidade_das_pecas([],_,0).
    utilidade_das_pecas([PecaID|RPecas], EJ, Valor) :-
        utilidade_da_peca(PecaId, EJ, V1),
        utilidade_das_pecas(RPecas,EJ,  V2),
        Valor is V1+V2.


*/



%utilidade_da_peca(+PecaId, +Estado, -Valor)



/*
    FEEDBACK:
        Melhorar descricao
        Tabuleiro != Estado de Jogo
        Emcampsular acesso aos objetos


*/