module CopaDoMundo

one sig Copa{
	jogos: Jogo,  
	grupos: set Grupo
}

sig Grupo {
	selecoes: set Selecao
}

sig Jogo {
	selecao1: Selecao,
	selecao2: Selecao
}

sig Selecao {
	titulares: set JogadorTitular,
	reservas: set JogadorReserva,
	medicos: set Medico,
	comissaoTecnica:  ComissaoTecnica,
	tecnico: one Tecnico
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

sig SelecaoCampeaDoMundo in Selecao {} 

pred JogoEhCompostoPor[j:Jogo]{
	one j.selecao1
	one j.selecao2
	one j.~jogos // Uma instancia de Jogo tem que estar conectada a o atributo jogos de Copa
}

pred CopaEhCompostaPor[c:Copa]{
	one Jogo
	some Grupo
}

pred SelecaoEhCompostaPor[s:Selecao]{
	
	some s.titulares
	some s.reservas
	some s.medicos
	one s.tecnico
	one s.comissaoTecnica
}

pred CardinalidadesSelecao[s:Selecao]{
	
	#(s.titulares) = 11 
	#(s.reservas) = 11
	#(s.medicos) = 4
}

fact factsCopaJogo{
    all c:Copa| one c.jogos -- copa ter  um jogo
    all j: Jogo | JogoEhCompostoPor[j]
    all j: Jogo | j.selecao1 != j.selecao2
}

fact FactsSelecao{

 	all s:Selecao | SelecaoEhCompostaPor[s]
    	all s:Selecao | CardinalidadesSelecao[s]
	all c:ComissaoTecnica | #PessoasDaComissaoTecnica[c] = 4
	all c:ComissaoTecnica | one c.~comissaoTecnica -- uma instancia de uma ComissaoTecnica tem que que estar ligada ao atributo comissaoTecnica de Selecao

        all j:JogadorTitular | one  j.~titulares
	all j1:JogadorReserva | one  j1.~reservas

	all p: PessoaComissao | one p.~pessoasComissao // Toda instancia de uma PessoaComissao tem que que estar ligada ao set pessoasComissao de ComissaoTecnica
	all m: Medico | one m.~medicos  // Toda instancia de um Medico tem que que estar ligada ao set medicos de Selecao
	all t:Tecnico| one t.~tecnico // Toda instancia de um Tecnico tem que que estar ligada ao atributo tecnico de Selecao
	
}

fun GruposDaCopa[c:Copa]: set Grupo{
	c.grupos
}

fun SelecoesDoGrupo[g:Grupo]: set Selecao{
	g.selecoes
}

fun PessoasDaComissaoTecnica[c:ComissaoTecnica]: set PessoaComissao{
	c.pessoasComissao
}

fact FactsGerais{
	#Copa = 1
	all c:Copa | CopaEhCompostaPor[c]
	all c:Copa | #GruposDaCopa[c] = 1 // Eh necessario reduzir a quantidade de grupos para o Alloy conseguir gerar o grafo. O numero de grupos original seria 4.
	all g:Grupo | #SelecoesDoGrupo[g] = 4
	#SelecaoCampeaDoMundo = 1
	all s:Selecao | some s.~selecoes 
	all g1:Grupo | all g2:Grupo | (g1 != g2) =>  (g1.selecoes != g2.selecoes)
	SelecaoCampeaDoMundo = Jogo.selecao1 or SelecaoCampeaDoMundo = Jogo.selecao2 //Especifica que a selecao Campea sempre participa do jogo
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
 --Tempo Aproximado de execucao se tivermos apena 1 grupo: 7 minutos com as  Configuracoes: MaxMemory: 4092 MB  MaxStack: 8192 K
pred show[]{}
run show for 88

