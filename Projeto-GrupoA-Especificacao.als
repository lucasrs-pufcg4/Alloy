-- Sistema para gerenciamento de Eventos acadêmicos

--(1) Assinatura 
abstract sig Evento{
	organizador: one Professor,--Unico professor organizador  
	sala: one Sala, -- Unica Sala para um evento 
	partipante: set Participante, --Conjuntos de Participante
	horario: one Horario, -- Unico horario para aquele evento 
	maxVagas: Int  --Maximo de participantes
}

--Abstract nâo pode haver interseção entre eles 
one sig Palestra, Workshops extends Evento{}
sig Professor{}
sig Horario{}
sig Sala {}
sig Partipante{}

--Fatos (restrições)
-- Cada evento tem EXATAMENTE um professor organizador.
--Um professor pode organizar MAIS DE UM evento, a MENOS que eles ocorram no mesmo horário. 
--Sala e horário fixos para CADA evento.
--Número de vagas não pode ser ultrapassado
--Os participantes podem participar de mais de um evento, desde que não haja horários iguais.
--O participante não pode estar inscrito E na lista de espera do mesmo evento.
--EXISTE lista de espera.
--TODOS os eventos devem ter sala, horário e organizador.
--TODAS as inscrições devem ter participante e evento associado.
 
