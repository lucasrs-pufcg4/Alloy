-- =====================
-- ASSINATURAS 
-- =====================


sig Livro{
	titulo: one Titulo,
	autor: one Autor
}

sig Usuario{}

sig Emprestimo{
	usuario: one Usuario, 
	livro: one Livro 
}

--Para representar título e autor como entidades simples

sig Titulo{}
sig Autor{}

--================
--Fatos(REGRAS DO SISTEMA)
--================

--1 Um livro não pode estar em dois Emprestimos diferentes 

fact 	LivroUnicoEmprestimo{
	all l : Livro |
		lone e: Emprestimo | e.livro = l 
}

--2 Um usuario pode ter no maximo 3 Enprestimo 

fact LimiteEmprestimoParaOUsuario{
	all u : Usuario |
	#{e: Emprestimo  | e.usuario = u} <= 3 
}

--3 Todoos emprestimo liga exatamente um usúario  a um Livro
fact EmprstimoValido{
	all e: Emprestimo | one e.usuario and one e.livro 
}

-- ===============
-- assert(PROPEIEDADE A SER TESTADA )
--===============

assert LivroNaoDuplicado{
	all e1, e2: Emprestimo | 
		e1.livro = e2.livro implies e1 = e2 
}

--Verificar as propriedade
check LivroNaoDuplicado for 5
--===========
-- gerar exemplo 
--===========

run{} for 5 

pred show(){}

run show for 5 












 

