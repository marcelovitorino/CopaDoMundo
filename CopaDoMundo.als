module CopaDoMundo

one sig Copa{
	jogos: lone Jogo,  --no maximo um jogo
	grupos: set Grupo
}

sig Grupo {
	selecoes: set Selecao
}

sig Jogo {
	selecao1: lone Selecao,
	selecao2: lone Selecao
}

sig Selecao {
	titulares: set Jogador,
	reservas: set Jogador,
	medicos: set Medico,
	comissaoTecnica: set ComissaoTecnica,
	tecnico: lone Tecnico
}

sig SelecaoCampeaDoMundo in Selecao {}

abstract sig Pessoa {}

abstract sig Jogador extends Pessoa {}
--sig Titular extends Jogador {}
--sig Reserva extends Jogador {}

sig Tecnico extends Pessoa {}
sig Medico extends Pessoa {}
sig ComissaoTecnica extends Pessoa {}

fact cardinalidadeJogo{
    all c:Copa| some c.jogos -- copa ter pelo menos um jogo
    all j:Jogo | one j.~jogos -- jogo esta em uma copa
    all j:Jogo | #(j.selecao1) >= 1
    all j:Jogo | #(j.selecao2) >= 1
   all j: Jogo | j.selecao1 != j.selecao2
}

fact {
	#Copa = 1
	#SelecaoCampeaDoMundo = 1
	#Grupo = 4
	#Selecao = 16 -- 16 selecoes ao todo
	#Tecnico = 16 
	#ComissaoTecnica = 48
	#Medico = 64
	#Jogador = 352
}

fact{
	all s:Selecao | some s.~selecoes 
	all c:Copa | #(c.grupos) = 4
	all g:Grupo | #(g.selecoes) = 4
	all g1:Grupo | all g2:Grupo | (g1 != g2) =>  (g1.selecoes != g2.selecoes)
}

fact formalidadesSelecao{
	all s:Selecao | #(s.titulares) = 11
	all s:Selecao | #(s.reservas) = 11
	all s:Selecao | #(s.medicos) = 4
	all s:Selecao | #(s.comissaoTecnica) = 3
	
	all s1:Selecao | s1.titulares != s1.reservas -- jogador nao pode ser titular e reserva
	all s1:Selecao| all s2: Selecao | (s1 != s2) => (s1.titulares != s2.titulares) -- titularesm nao pode  estar em dois times) && (s1.titulares != s2.reservas)
	-- (s1.reservas != s2.titulares) (s1.reservas != s2.reservas) 
	all s1:Selecao| all s2:Selecao | (s1 != s2) => (s1.tecnico != s2.tecnico)  -- tecnico nao pode estar em dois times
}

pred show[]{}
run show for 30 --nao sei porque mas se colocar 30 funciona na primeira vez
