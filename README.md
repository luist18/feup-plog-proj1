# Projeto de PLOG
## Identificação

O jogo a ser desenvolvido será o _Three Dragons_. Trabalho realizado por:

- Fábio Miliano Prinsloo Moreira (up201806296)
- José Luís Sousa Tavares (up201809679)
(Turma 2 - _ThreeDragons_5_)

## O jogo: _Three Dragons_

O jogo _Three Dragons_é parecido com vários jogos de captura antigos, tal como Tablut. Contudo, tem dois aspetos adicionais como variantes avançadas do jogo:

1.  As peças têm um valor numérico associado - nível, tal que apenas uma peça mais forte consegue capturar uma mais fraca.
2.  Existem três Cavernas de Dragão no tabuleiro, que permitem que os jogadores obtenham peças mais fortes.

- As peças podem percorrer o tabuleiro tanto na horizontal como na vertical.
- Uma captura normal ocorre quando uma peça for deslocada para uma casa adjacente à peça adversária tal que do outro lado exista uma outra peça do jogador.
- O vencedor é declarado quando o adversário estiver reduzido a uma só peça. 
- Apenas são possíveis obter 3 dragões (1 de cada caverna), sendo que para tal acontecer, um jogador precisa de ter peças suas a rodear a caverna. Quando um jogador obtiver um dragão, esta peça é jogada como uma peça normal.
- A captura de uma peça pode também acontecer quando o jogar deslocar uma peça para a casa adjacente a uma peça do adversário de nível inferior.
- O jogador pode decidir entre a "Captura Normal" e "Captura por Nível".
- Com a "Captura Normal", é possível capturar mais que uma peça.
- Com a "Captura por Nível", apenas é possível capturar uma peça.
- Movimentar uma peça para uma casa adjacente a uma peça adversária de nível mais alto não resulta na captura da peça por parte do adversário.
- Após uma captura, o nível da peça é decrementado unitariamente.

## Representação interna do estado de jogo

## Visualização do estado de jogo
