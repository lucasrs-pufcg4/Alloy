// Especificação do Sistema de Inscrição em Projetos de Pesquisa
module ProjetosPesquisa

// Assinaturas básicas
sig Aluno {
    disciplinasAprovadas: set Area   // áreas das disciplinas que o aluno já aprovou
}

sig Professor {
    projetos: set Projeto    // projetos orientados pelo professor
}

sig Area {}

sig Projeto {
    responsavel: one Professor,        // professor responsável (único)
    area: one Area,                     // área do projeto (única)
    vagas: Int,                          // número máximo de vagas (até 4)
    inscritos: set Aluno,                 // alunos atualmente inscritos
    candidatos: set Aluno                  // lista de candidatos que se inscreveram
}

// Fatos (restrições)

// 1. Relacionamento Professor-Projeto
fact ProfessorProjeto {
    // Um professor pode orientar vários projetos
    all p: Professor | p.projetos = {proj: Projeto | proj.responsavel = p}
    // Todo projeto tem exatamente um professor responsável (já garantido pela assinatura)
}

// 2. Capacidade dos projetos (máximo 4 vagas)
fact CapacidadeProjeto {
    all proj: Projeto | proj.vagas <= 4 and proj.vagas >= 0
    // Número de inscritos não pode exceder o número de vagas
    all proj: Projeto | #proj.inscritos <= proj.vagas
}

// 3. Aluno pode participar de no máximo um projeto
fact MaximoUmProjetoPorAluno {
    all a: Aluno | lone {proj: Projeto | a in proj.inscritos}
}

// 4. Aluno só pode se inscrever se tiver disciplina aprovada na área
fact InscricaoValida {
    all proj: Projeto | all a: proj.candidatos |
        a.disciplinasAprovadas in Area and
        proj.area in a.disciplinasAprovadas
}

// 5. Aluno só pode participar de projeto para o qual se inscreveu
fact ParticipacaoValida {
    all proj: Projeto | proj.inscritos in proj.candidatos
}

// 6. Política de preenchimento de vagas
fact PreenchimentoVagas {
    // Sempre que há vaga e candidatos, a vaga deve ser preenchida
    all proj: Projeto |
        let vagasDisponiveis = proj.vagas - #proj.inscritos |
            vagasDisponiveis > 0 implies
                some candidatosRestantes: proj.candidatos - proj.inscritos |
                    let novosInscritos = proj.inscritos + candidatosRestantes |
                        #novosInscritos <= proj.vagas
    // Esta é uma simplificação - em um sistema real, teríamos uma sequência temporal
}

// Predicados úteis
pred ProjetoComVagas[proj: Projeto] {
    #proj.inscritos < proj.vagas
}

pred AlunoDisponivel[a: Aluno] {
    no {proj: Projeto | a in proj.inscritos}
}

pred AlunoQualificadoParaProjeto[a: Aluno, proj: Projeto] {
    proj.area in a.disciplinasAprovadas
}

// Cenários de exemplo
run CenarioBasico {
    some proj: Projeto | ProjetoComVagas[proj]
    some a: Aluno | AlunoDisponivel[a]
    #Area = 3  // exatamente 3 áreas de pesquisa
} for 5 but exactly 3 Area

run CenarioCompleto {
    #Area = 3
    some proj: Projeto | #proj.candidatos > proj.vagas
    some a: Aluno | a in Projeto.candidatos and a not in Projeto.inscritos
} for 5

// Assertions para verificar propriedades
assert NenhumProjetoExcedeCapacidade {
    all proj: Projeto | #proj.inscritos <= proj.vagas
}

assert AlunoEmUmProjetoApenas {
    all a: Aluno | #{proj: Projeto | a in proj.inscritos} <= 1
}

assert InscritosForamCandidatos {
    all proj: Projeto | proj.inscritos in proj.candidatos
}

assert ProjetosTemProfessorUnico {
    all disj proj1, proj2: Projeto |
        proj1.responsavel = proj2.responsavel implies
        proj1 != proj2  // um professor pode ter múltiplos projetos
}

// Verificações
check NenhumProjetoExcedeCapacidade for 5
check AlunoEmUmProjetoApenas for 5
check InscritosForamCandidatos for 5
check ProjetosTemProfessorUnico for 5

// Verificação adicional sobre a área dos projetos
assert AreasFixas {
    #Area = 3
}

// Nota: esta verificação pode falhar se não houver exatamente 3 áreas no escopo
check AreasFixas for 5 but exactly 3 Area
