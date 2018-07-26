module CopaDoMundo

one sig Copa{
	jogos: one Jogo,  
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
	titulares: set JogadorTitular,
	reservas: set JogadorReserva,
	medicos: set Medico, //ok
	comissaoTecnica:  ComissaoTecnica, //ok
	tecnico: one Tecnico //ok
}



abstract sig Pessoa {}

abstract sig Jogador{}

sig JogadorTitular  extends Jogador {}
sig JogadorReserva extends Jogador{}

sig Tecnico extends Pessoa {}
sig Medico extends Pessoa {}
sig PessoaComissao extends Pessoa{}

sig ComissaoTecnica extends Pessoa {
	pessoasComissao: set PessoaComissao 
}

sig SelecaoCampeaDoMundo in Selecao {} -- in selecoes

pred cardinalidadesJogo[j:Jogo]{
	#(j.selecao1) = 1
	#(j.selecao2) = 1
	 one j.~jogos // Uma instancia de Jogo tem que estar conectada a o atributo jogos de Copa
}
fact factsCopaJogo{
    all c:Copa| one c.jogos -- copa ter  um jogo
    all j: Jogo | cardinalidadesJogo[j]
    all j: Jogo | j.selecao1 != j.selecao2
}

pred EhCompostaPor[s:Selecao]{
	
	some s.titulares
	some s.reservas
	some s.medicos
	one s.tecnico
	one s.comissaoTecnica
}

pred CardinalidadesSelecao[s:Selecao]{
	
	#(s.titulares) = 11 -- é necessario reduzir o numero de 11 para um valor mais baixo para que seja possivel gerar o grafico OU diminuir a quantidade de grupos
	#(s.reservas) = 11 -- é necessario reduzir o numero de 11 para um valor mais baixo para que seja possivel gerar o grafico OU diminuir a quantidade de grupos
	#(s.medicos) = 4
}

pred CardinalidadesComissaoTecnica[c:ComissaoTecnica]{
	
	#(c.pessoasComissao) = 3
	one c.~comissaoTecnica -- uma instancia de uma ComissaoTecnica tem que que estar ligada ao atributo comissaoTecnica de Selecao
}

fact FactsSelecao{

 	all s:Selecao | EhCompostaPor[s]
    	all s:Selecao | CardinalidadesSelecao[s]
	all c: ComissaoTecnica | CardinalidadesComissaoTecnica[c]

       all j:JogadorTitular | one  j.~titulares
	all j1:JogadorReserva | one  j1.~reservas

--	all s:Selecao | #(s.comissaoTecnica) = 1 //ok

	all p: PessoaComissao | one p.~pessoasComissao // Toda instancia de uma PessoaComissao tem que que estar ligada ao set pessoasComissao de ComissaoTecnica
	all m: Medico | one m.~medicos  // Toda instancia de um Medico tem que que estar ligada ao set medicos de Selecao
	all t:Tecnico| one t.~tecnico // Toda instancia de um Tecnico tem que que estar ligada ao atributo tecnico de Selecao
}


fact cardinalidadesGerais{
	#Copa = 1
	#Grupo = 1
	#Selecao = 4
	#SelecaoCampeaDoMundo = 1
	all s:Selecao | some s.~selecoes 
	all c:Copa | #(c.grupos) = 1
	all g:Grupo | #(g.selecoes) = 4
	all g1:Grupo | all g2:Grupo | (g1 != g2) =>  (g1.selecoes != g2.selecoes)
	SelecaoCampeaDoMundo = Jogo.selecao1 or SelecaoCampeaDoMundo = Jogo.selecao2 // Adicionei essa linha para especificar que sempre a selecao Campea participa do jogo
}

-- ASSERTS
assert TodaSelecaoTemApenasUmTecnico{
	all s: Selecao | one s.tecnico 
}

assert TodaComissaoEhCompostaPor3Pessoas{
	all c: ComissaoTecnica | #(c.pessoasComissao) = 3
}

assert TodaSelecaoPossui4Medicos{
	all s: Selecao | #(s.medicos) = 4
}

assert CopaTemApenasUmVencedor{
	#SelecaoCampeaDoMundo = 1
}

assert SelecoesSaoDifeirentesSe{
	all s1: Selecao | all s2: Selecao | (s1 != s2) => (s1.tecnico != s2.tecnico)
	 all s1: Selecao | all s2: Selecao | (s1 != s2) => (s1.comissaoTecnica != s2.comissaoTecnica)
	all s1: Selecao | all s2: Selecao | (s1 != s2) => (s1.medicos != s2.medicos)
	all s1: Selecao | all s2: Selecao | (s1 != s2) => (s1.titulares + s1.reservas  != s2.titulares + s2.reservas)
}

-- 30 para tecnico
-- 64 para comissao
-- 64 para medicos
-- 88 para jogadores se a quantidade de grupos for igual a 1
pred show[]{}
run show for 88

