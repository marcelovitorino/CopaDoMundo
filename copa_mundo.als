module copa_mundo

sig Copa {
	selecoes: set Selecao
}
--Falta adcionar divisao de equipes, provavelmente com 'in'
sig Selecao {
	pessoas: set Pessoa
} 

abstract sig Pessoa {}

abstract sig Jogador extends Pessoa {}
sig Titular extends Jogador {}
sig Reserva extends Jogador {}

sig Tecnico extends Pessoa {}
sig Medico extends Pessoa {}
sig ComissaoTecnica extends Pessoa {}

fact {
#Copa = 1
#Selecao = 16 --nao ta funcionando isso

--#Medico = 4
--#Tecnico = 1
---#ComissaoTecnica = 3

}

pred show[]{}
run show
