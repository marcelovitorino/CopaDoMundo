module CopaDoMundo

one sig Copa{
--	jogos: lone Jogo,  --no maximo um jogo
	grupos: set Grupo
}

sig Grupo {
	selecoes: set Selecao
}

--sig Jogo {
--	selecao1: lone Selecao,
--	selecao2: lone Selecao
--}

sig Selecao {
--	pessoas: set Pessoa
}

sig SelecaoCampeaDoMundo in Selecao {}

--abstract sig Pessoa {}

--abstract sig Jogador extends Pessoa {}
--sig Titular extends Jogador {}
--sig Reserva extends Jogador {}

--sig Tecnico extends Pessoa {}
--sig Medico extends Pessoa {}
--sig ComissaoTecnica extends Pessoa {}

fact cardinalidadeJogo{
   -- all c:Copa| some c.jogos -- copa ter pelo menos um jogo
  --  all j:Jogo | one j.~jogos -- jogo esta em uma copa
  --  all j:Jogo | #(j.selecao1) >= 1
  --  all j:Jogo | #(j.selecao2) >= 1
  --  all j: Jogo | j.selecao1 != j.selecao2
	all c:Copa | #(c.grupos) = 4
	all g:Grupo | #(g.selecoes) = 4
	all g1:Grupo | all g2:Grupo | (g1 != g2) =>  (g1.selecoes != g2.selecoes) 
#Grupo = 4
#Copa = 1
#SelecaoCampeaDoMundo = 1

}

pred show[]{}
run show for 15
