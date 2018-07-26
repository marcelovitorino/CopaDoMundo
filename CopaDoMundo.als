module CopaDoMundo

one sig Copa{
	jogos: one Jogo,  --no maximo um jogo
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
--	jogadores: set Jogador,
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

fact cardinalidadeJogo{	
    all c:Copa| one c.jogos -- copa ter  um jogo
    all j:Jogo | one j.~jogos -- jogo esta em uma copa
    all j:Jogo | #(j.selecao1) = 1
    all j:Jogo | #(j.selecao2) = 1
    all j: Jogo | j.selecao1 != j.selecao2
}
fact {
	#Grupo = 1
	#Copa = 1
	#SelecaoCampeaDoMundo = 1
}

fact{
	#Selecao = 4
--	#ComissaoTecnica = 16 //ok
--	#PessoaComissao = 48 //ok
}

fact cardinalidadeSelecao{

 	// Facts para titulares e reservas
    	all s:Selecao | #(s.titulares) = 11
        all s:Selecao | #(s.reservas) = 11

       all j:JogadorTitular | one  j.~titulares
	all j1:JogadorReserva | one  j1.~reservas

	//Facts referentes a COMISSAO TECNICA e PESSOA COMISSAO
	all s:Selecao | #(s.comissaoTecnica) = 1 //ok
	all c:ComissaoTecnica| #(c.pessoasComissao) = 3 //ok
	all c: ComissaoTecnica | one c.~comissaoTecnica //ok
	all p: PessoaComissao | one p.~pessoasComissao //ok

	//Facts referentes a MEDICOS
	all s:Selecao | #(s.medicos) = 4 //ok
	all m: Medico | one m.~medicos //ok


	all t:Tecnico| one t.~tecnico // ok

}


fact{
	all s:Selecao | some s.~selecoes 
	all c:Copa | #(c.grupos) = 1
	all g:Grupo | #(g.selecoes) = 4
	all g1:Grupo | all g2:Grupo | (g1 != g2) =>  (g1.selecoes != g2.selecoes)
}

-- 30 para tecnico
-- 64 para comissao
-- 64 para medicos
-- 88 para jogadores
pred show[]{}
run show for 88 --nao sei porque mas se colocar 30 funciona na primeira vez

