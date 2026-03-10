-- Sistema para gerenciamento de Eventos acadêmicos
---------------------
--(1) Assinatura 
----------------------

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
	UnicoProfessorEmUmEvento 
	MaximoDeVagaPositivo 
	UnicoEventoSala
	VagasLimidada 
	InscricaoParticipantes 
	ListaEsperaSoQuandoLotado 
	DuplicidadeDeInscricaes
}

---------------------------------------------------------------------
--ASSERT(verificar se existe algum contra exemplo)
---------------------------------------------------------------------

-- Verifica se há participantes inscritos em eventos com conflito de horário
assert naoHaConflitoParaInscritos {
	all p: Participante, disj e1, e2: Evento |
		p in e1.inscritos and p in e2.inscritos implies e1.horario != e2.horario
}

-- Verifica se a lista de espera está vazia quando ainda há vagas
assert listaDeEsperaSemVagas {
	all e: Evento |
		#e.inscritos < e.maxVagas implies no e.listaDeEspera
}

-- Verifica se professores estão livres de conflitos de horário
assert professorSemConflito {
	all disj e1, e2: Evento |
		e1.organizador = e2.organizador implies e1.horario != e2.horario
}

-- Verifica se salas não abrigam dois eventos no mesmo horário
assert salaSemConflito {
	all disj e1, e2: Evento |
		e1.sala = e2.sala implies e1.horario != e2.horario
}

-- Verifica se o limite de vagas é respeitado
assert respeitoAoLimiteDeVagas {
	all e: Evento | 
		#e.inscritos <= e.maxVagas
}

-- Verifica se um participante nunca esta em ambos os estados no mesmo evento
assert semDuplicidadeInscricaoEspera {
	all e: Evento, p: Participante | 
		p in e.inscritos implies p not in e.listaDeEspera
}


--------------------------------------------------
-- CHECKS & EXECUÇÃO
--------------------------------------------------
check naoHaConflitoParaInscritos for 5
check listaDeEsperaSemVagas for 5
check professorSemConflito for 5
check salaSemConflito for 5
check respeitoAoLimiteDeVagas for 5
check semDuplicidadeInscricaoEspera for 5



--TODAS as inscrições devem ter participante e evento associado.
pred show(){}

run show for 5
