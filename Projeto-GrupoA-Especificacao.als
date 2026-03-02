-- Sistema para gerenciamento de Eventos acadêmicos

--(1) Assinatura 
 sig Evento{
	organizador: one Professor,--Unico professor organizador  
	sala: one Sala, -- Unica Sala para um evento 
	inscritos: set Participante, --Conjuntos de Participante
	horario: one Horario, -- Unico horario para aquele evento 
	maxVagas: Int,  --Maximo de participantes
	listaEspera: set Participante -- Participante que esta esperando 
}

sig Professor{}
sig Horario{}
sig Sala {}
sig Participante{}


--Fatos (restrições)

--Exatamente um professor por eventoe não  
fact UnicoProfessorEmUmEvento{
	all e1, e2: Evento | (e1.organizador = e2.organizador) and not (e1.horario = e2.horario)
}
-- Um evento em um Horario 
fact UnicoEventoSala{
	all e1, e2: Evento | (e1.sala = e2.sala) and not (e1.horario = e2.horario)
}
--números de vagas não pode ser ultrapassada 

fact VagasLimidada{
	all e: Evento | #(e.inscritos) <= e.maxVagas
}
--Os participantes podem participar de mais de um evento, desde que não haja horários iguais.

fact InscricaoParticipantes{
all e, e2: Evento | not (e.horario = e2.horario) and (e.inscritos = e2.inscritos) 
}

--O participante NÃO pode estar inscrito E na lista de espera do mesmo evento.
fact DuplicidadeDeInscricaes{
all e : Evento, p : Participante  | (p in e.inscritos or p in e.listaEspera)  and not(p in e.inscritos and p in e.listaEspera) 
}


--TODAS as inscrições devem ter participante e evento associado.
pred show(){}

run show for 5 
