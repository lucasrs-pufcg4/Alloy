--Especificação do sistema de inscrição em projetos de Pesquisa 
-- Alunos/Matriculas 
-


--Assinaturas basicas 

sig Aluno{
	disciplinasAprovados: set Area --áreas daa disciplina que o aluno já aprovou 
}

sig Professor {
	projetos : set Projeto -- projetos orientados do Professor 
]

sig Area{}

sig Projetos {
	responsavel : one Professor --professor responsável(único)
	area : one Area -- área do projeto (única)
	vagas : Int, -- Números máximo de vagas (até 4)
	inscritos: set Aluno -- conjuntos de alunos atualmente inscritos
	candidatos: set Aluno -- cojuntos de alunos que se inscreveram 
}

--Restriçõeas

--1 Relacionar Professor-Projeto

fact ProfessorProjeto{
	-- Um professor pode orientar vários projeto 
	all p : Professor | p.projeto = {proj: Projeto | proj.responsavel}
	--Todos projeto tem exatamente um professor responsável (já garantido pela a assinatura) 
} 

--2 Capacidade de projetos (no maximo 4 alunos)

fact CapacidadeDoProjeto{
	all proj : Projeto | proj.vagas <= 4 and proj.vagas >= 0
	--Numero de inscritos não pode exceder os numeros de vagas 
	all proj : Projeto | #proj.inscritos <= proj.vagas
}

--3 o aluno So pode participar de um projeto 

fact MaximoUmProjetoPorAluno{
	all a: Aluno | lone {proj: Projeto | a in proj.inscritos}
}

-- 4 o aluno só pode se inscreve se eles ja aprovou na disciplina dessa area 

fact inscricaoValida{
	all proj 
} 







































