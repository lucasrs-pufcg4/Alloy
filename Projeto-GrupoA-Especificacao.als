-- Sistema para gerenciamento de Eventos acadêmicos

--(1) Assinatura 
 sig Evento{
	organizador: one Professor,--exatamente 1 organizador  
	sala: one Sala, --  exatamente 1 sala 
	inscritos: set Participante, --conjuntos de Participante
	horario: one Horario, -- unico horario para aquele evento 
	maxVagas: one Int,  --um número máximo de vagas
	listaDeEspera: set Participante -- participantes em lista de espera
}
--professores que organizam o Evento 
sig Professor{}

--Horario que o Evento vai Acontecer
sig Horario{}

--Sala que vai acontecer o evento
sig Sala {}

--Participante que pode participar do evento
sig Participante{}

--------------------------------------------------
-- FATOS (REGRAS QUE SEMPRE DEVEM SER VERDADEIRAS)
--------------------------------------------------

--Se dois eventos têm o mesmo organizador, então devem ter horários diferentes.
pred UnicoProfessorEmUmEvento{
	all disj e1, e2: Evento | e1.organizador = e2.organizador implies e1.horario != e2.horario
}

--Garante que todo evento tenha pelo menos 1 vaga. Evita eventos com capacidade zero ou negativa.
pred MaximoDeVagaPositivo{
	all e : Evento | e.maxVagas > 0
}

--Se dois eventos estão na mesma sala, então seus horários devem ser diferentes
pred UnicoEventoSala{
	all disj e1, e2: Evento | e1.sala = e2.sala implies e1.horario != e2.horario
}

--números de vagas não pode ser ultrapassada 
pred VagasLimidada{
	all e: Evento | #(e.inscritos) <= e.maxVagas
}

--Um mesmo participante não pode estar inscrito em dois eventos no mesmo horário.
pred InscricaoParticipantes{
all disj  e, e2: Evento , p: Participante | (p in e.inscritos and p in e2.inscritos) implies e.horario != e2.horario
}

--Caso ultrapasse o limite, os excedentes podem compor lista de espera.
pred  ListaEsperaSoQuandoLotado{
	all e : Evento | some e.listaDeEspera implies #(e.inscritos) = e.maxVagas
}

--O participante NÃO pode estar inscrito E na lista de espera do mesmo evento.
pred DuplicidadeDeInscricaes{
all e : Evento, p : Participante  | not (p in e.inscritos and p in e.listaDeEspera) 
}

fact{
	DuplicidadeDeInscricaes
	ListaEsperaSoQuandoLotado 
	InscricaoParticipantes 
	VagasLimidada 
	UnicoEventoSala 
	MaximoDeVagaPositivo 
	UnicoProfessorEmUmEvento 

}


--TODAS as inscrições devem ter participante e evento associado.
pred show(){}

run show for 5
