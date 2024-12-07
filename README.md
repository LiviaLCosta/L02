## Pacote PKG_ALUNO

- **1- Procedure de exclusão de aluno:**
Crie uma procedure que receba o ID de um aluno como parâmetro e exclua o registro correspondente na tabela de alunos. Além disso, todas as matrículas associadas ao aluno devem ser removidas.
```bash
    DECLARE
        p_id_aluno NUMBER := 1;  -- Substitua com o ID do aluno que você deseja excluir
    BEGIN
        pkg_aluno.excluir_aluno(p_id_aluno);
    END;
```
Este bloco irá chamar a procedure `excluir_aluno` e excluir o aluno com o ID fornecido. A saída será uma mensagem informando que o aluno foi removido com sucesso.
- **2- Cursor de listagem de alunos maiores de 18 anos:**
Desenvolva um cursor que liste o nome e a data de nascimento de todos os alunos com idade superior a 18 anos.
```bash
    BEGIN
        pkg_aluno.listar_alunos_maiores;
    END;
```
Esse bloco chama a procedure `listar_alunos_maiores`, que irá listar os alunos maiores de 18 anos, mostrando o nome e a data de nascimento no `DBMS_OUTPUT`.
- **3- Cursor com filtro por curso:**
Crie um cursor parametrizado que receba o id_curso e exiba os nomes dos alunos matriculados no curso especificado
```bash
    DECLARE
        p_id_curso NUMBER := 2;  -- Substitua com o ID do curso
    BEGIN
        pkg_aluno.listar_alunos_por_curso(p_id_curso);
    END;
```
Aqui, o bloco chama a procedure `listar_alunos_por_curso` para listar os alunos matriculados em um curso específico. Basta alterar o valor de `p_id_curso` conforme necessário.

## Pacote PKG_DISCIPLINA
- **1- Procedure de cadastro de disciplina:**
Crie uma procedure para cadastrar uma nova disciplina. A procedure deve receber como parâmetros o nome, a descrição e a carga horária da disciplina e inserir esses dados na tabela correspondente.
```bash
    DECLARE
        p_id_disciplina NUMBER := 4;  -- Substitua com o ID da nova disciplina
        p_nome VARCHAR2(100) := 'Matemática Avançada';  -- Nome da disciplina
        p_descricao CLOB := 'Disciplina de Matemática Avançada para alunos do curso de Engenharia.';  -- Descrição
        p_id_curso NUMBER := 2;  -- ID do curso
        p_carga_horaria NUMBER := 60;  -- Carga horária
    BEGIN
        pkg_disciplina.criar_disciplina(p_id_disciplina, p_nome, p_descricao, p_id_curso, p_carga_horaria);
    END;
```
Esse bloco chama a procedure `criar_disciplina` e cria uma nova disciplina no sistema.
- **2- Cursor para total de alunos por disciplina:**
Implemente um cursor que percorra as disciplinas e exiba o número total de alunos matriculados em cada uma. Exiba apenas as disciplinas com mais de 10 alunos.
```bash
    BEGIN
        pkg_disciplina.listar_total_alunos_por_disciplina;
    END;
```
Esse bloco irá listar todas as disciplinas com mais de 10 alunos matriculados, utilizando o cursor da procedure `listar_total_alunos_por_disciplina`.
- **3- Cursor com média de idade por disciplina:**
Desenvolva um cursor parametrizado que receba o id_disciplina e calcule a média de idade dos alunos matriculados na disciplina especificada.
```bash
    DECLARE
        p_id_disciplina NUMBER := 3;  -- Substitua pelo ID da disciplina
    BEGIN
        pkg_disciplina.listar_medida_idade_por_disciplina(p_id_disciplina);
    END;
```
Esse bloco chama a procedure `listar_medida_idade_por_disciplina` e calcula a média de idade dos alunos matriculados na disciplina especificada.
- **4- Procedure para listar alunos de uma disciplina:**
Implemente uma procedure que receba o ID de uma disciplina como parâmetro e exiba os nomes dos alunos matriculados nela.
```bash
    DECLARE
        p_id_disciplina NUMBER := 3;  -- Substitua com o ID da disciplina
    BEGIN
        pkg_disciplina.listar_alunos_por_disciplina(p_id_disciplina);
    END;
```
Aqui, o bloco chama a procedure `listar_alunos_por_disciplina` para listar os alunos matriculados em uma disciplina específica.
## Pacote PKG_PROFESSOR
- **1- Cursor para total de turmas por professor:**
Desenvolva um cursor que liste os nomes dos professores e o total de turmas que cada um leciona. O cursor deve exibir apenas os professores responsáveis por mais de uma turma.
```bash
    BEGIN
        pkg_professor.listar_total_turmas_por_professor;
    END;
```
Esse bloco chama a procedure `listar_total_turmas_por_professor`, que irá listar os professores responsáveis por mais de uma turma e o total de turmas que cada um leciona.
- **2- Function para total de turmas de um professor:**
Crie uma function que receba o ID de um professor como parâmetro e retorne o total de turmas em que ele atua como responsável.
```bash
    DECLARE
        p_id_professor NUMBER := 2;  -- Substitua pelo ID do professor
        v_total_turmas NUMBER;
    BEGIN
        v_total_turmas := pkg_professor.listar_turmas_por_professor(p_id_professor);
        DBMS_OUTPUT.PUT_LINE('Total de turmas: ' || v_total_turmas);
    END;
```
Esse bloco chama a function `listar_turmas_por_professor`, passando o ID do professor e retornando o número de turmas em que o professor está responsável.
- **3- Function para professor de uma disciplina:**
Desenvolva uma function que receba o ID de uma disciplina como parâmetro e retorne o nome do professor que ministra essa disciplina.
```bash
    DECLARE
        p_id_disciplina NUMBER := 2;  -- Substitua com o ID da disciplina
        v_nome_professor VARCHAR2(100);
    BEGIN
        v_nome_professor := pkg_professor.listar_professor_por_disciplina(p_id_disciplina);
        DBMS_OUTPUT.PUT_LINE('Professor: ' || v_nome_professor);
    END;
```
Esse bloco chama a function `listar_professor_por_disciplina`, passando o ID da disciplina e retornando o nome do professor responsável por ela.

## Autora

- [Livia Lima Costa](#) - RA: 182034

