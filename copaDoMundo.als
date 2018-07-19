module CopaDoMundo

one sig Copa{
  jogos: lone Jogo  --no maximo um jogo
}

sig Jogo {
	selecao1: lone Selecao,
	selecao2: lone Selecao
}

abstract sig Selecao {
}
sig SelecaoCampeaDoMundo in Selecao {}

fact cardinalidadeJogo{
    all c:Copa| some c.jogos -- copa ter pelo menos um jogo
    all j:Jogo | one j.~jogos -- jogo esta em uma copa
    all j:Jogo | #(j.selecao1) >= 1
    all j:Jogo | #(j.selecao2) >= 1
    all j: Jogo | j.selecao1 != j.selecao2
}

abstract sig Pessoa {}

sig Jogador extends Pessoa{}



pred show[]{
--  #Conta > 1
--  #Banco = 8
}
run show for 3
