-- Pacote PKG_ALUNO (specification)
CREATE OR REPLACE PACKAGE pkg_aluno IS

    -- PROCEDURE PARA EXCLUIR ALUNOS
    PROCEDURE excluir_aluno(
        p_id_aluno IN NUMBER
    );
    
    -- PROCEDURE PARA O CURSOR listar_alunos_maiores
    PROCEDURE listar_alunos_maiores;

    -- PROCEDURE PARA O CURSOR listar_alunos_por_curso
    PROCEDURE listar_alunos_por_curso(p_id_curso NUMBER);
    
END pkg_aluno;

-- Pacote PKG_ALUNO (body)
CREATE OR REPLACE PACKAGE BODY pkg_aluno IS
     /*
    1- Procedure de exclusão de aluno:
    Crie uma procedure que receba o ID de um aluno como parâmetro e exclua o registro correspondente na tabela de alunos. Além disso, todas as matrículas associadas ao aluno devem ser removidas.
    */
    PROCEDURE excluir_aluno(
        p_id_aluno IN NUMBER
    ) IS
    BEGIN
        DELETE FROM aluno WHERE id_aluno = p_id_aluno;
        DELETE FROM matricula WHERE id_aluno = p_id_aluno;

        DBMS_OUTPUT.PUT_LINE('Aluno removido com sucesso: ID' || p_id_aluno);
    END excluir_aluno;
    -- 1- FIM
    
    /*
    2- Cursor de listagem de alunos maiores de 18 anos:
    Desenvolva um cursor que liste o nome e a data de nascimento de todos os alunos com idade superior a 18 anos.
    */
   PROCEDURE listar_alunos_maiores IS
    CURSOR cursor_alunos_maiores IS
        SELECT 
            nome, data_nascimento
        FROM aluno
        WHERE TRUNC(MONTHS_BETWEEN(SYSDATE, data_nascimento) / 12) > 18;   
    v_nome aluno.nome%TYPE;
    v_data_nascimento aluno.data_nascimento%TYPE;
   BEGIN
      OPEN cursor_alunos_maiores;
      LOOP
         FETCH cursor_alunos_maiores INTO v_nome, v_data_nascimento;
         EXIT WHEN cursor_alunos_maiores%NOTFOUND;
         DBMS_OUTPUT.PUT_LINE('Nome: ' || v_nome || ', Data de Nascimento: ' || v_data_nascimento);
      END LOOP;
      CLOSE cursor_alunos_maiores;
   END listar_alunos_maiores;
   -- 2- FIM
   
   /*
   3- Cursor com filtro por curso:
   Crie um cursor parametrizado que receba o id_curso e exiba os nomes dos alunos matriculados no curso especificado.
   */
   PROCEDURE listar_alunos_por_curso(p_id_curso NUMBER) IS
      CURSOR cursor_alunos(p_id_curso NUMBER) IS
         SELECT DISTINCT a.nome
         FROM aluno a, disciplina d, matricula m, curso c
         WHERE a.id_aluno = m.id_aluno
           AND m.id_disciplina = d.id_disciplina
           AND d.id_curso = c.id_curso
           AND c.id_curso = p_id_curso;

      v_nome aluno.nome%TYPE;
   BEGIN
      DBMS_OUTPUT.PUT_LINE('Alunos do curso: ' || p_id_curso); 
      OPEN cursor_alunos(p_id_curso);
      LOOP
         FETCH cursor_alunos INTO v_nome;
         EXIT WHEN cursor_alunos%NOTFOUND;
         DBMS_OUTPUT.PUT_LINE('Nome: ' || v_nome);
      END LOOP;
      CLOSE cursor_alunos;
      DBMS_OUTPUT.PUT_LINE('Execução concluída!');
   END listar_alunos_por_curso;
   -- 3- FIM 
END pkg_aluno;


-- Pacote PKG_DISCIPLINA (specification)
CREATE OR REPLACE PACKAGE pkg_disciplina IS

    -- PROCEDURE PARA CIRAR DISCIPLINA
    PROCEDURE criar_disciplina(
        p_id_disciplina IN NUMBER,
        p_nome IN VARCHAR2, 
        p_descricao IN CLOB, 
        p_id_curso IN NUMBER, 
        p_carga_horaria IN NUMBER 
    );
    
    -- PROCEDURE PARA O CURSOR PARA LISTAR TOTAL DE ALUNOS POR DISCIPLINA
    PROCEDURE listar_total_alunos_por_disciplina;

    -- PROCEDURE PARA O CURSOR listar_medida_idade_por_disciplina
    PROCEDURE listar_medida_idade_por_disciplina (p_id_disciplina NUMBER);


    -- PROCEDURE listar_alunos_por_disciplina
    PROCEDURE listar_alunos_por_disciplina(p_id_disciplina NUMBER);
    
END pkg_disciplina;

-- Pacote PKG_DISCIPLINA (body)
CREATE OR REPLACE PACKAGE BODY pkg_disciplina IS

    /*
    1 - Procedure de cadastro de disciplina:
    Crie uma procedure para cadastrar uma nova disciplina. A procedure deve receber como parâmetros o nome, a descrição e a carga horária da disciplina e inserir esses dados na tabela correspondente.
    */
   PROCEDURE criar_disciplina(
      p_id_disciplina IN NUMBER,
      p_nome IN VARCHAR2,
      p_descricao IN CLOB,
      p_id_curso IN NUMBER,
      p_carga_horaria IN NUMBER
   ) IS
   BEGIN
      INSERT INTO disciplina (id_disciplina, nome, descricao, id_curso, carga_horaria)
      VALUES (p_id_disciplina, p_nome, p_descricao, p_id_curso, p_carga_horaria);

      DBMS_OUTPUT.PUT_LINE('Disciplina criada com sucesso: ' || p_nome);
   EXCEPTION
      WHEN OTHERS THEN
         DBMS_OUTPUT.PUT_LINE('Erro ao criar disciplina: ' || SQLERRM);
   END criar_disciplina;
   -- 1- FIM

    /*
    2- Cursor para total de alunos por disciplina:
    Implemente um cursor que percorra as disciplinas e exiba o número total de alunos matriculados em cada uma. Exiba apenas as disciplinas com mais de 10 alunos.
    */
   PROCEDURE listar_total_alunos_por_disciplina IS
       CURSOR cursor_total_alunos IS
        SELECT d.nome AS disciplina,
               COUNT(m.id_aluno) AS total_alunos
        FROM disciplina d
        LEFT JOIN matricula m ON d.id_disciplina = m.id_disciplina
        GROUP BY d.nome
        HAVING COUNT(m.id_aluno) > 10;
      v_disciplina disciplina.nome%TYPE;
      v_total_alunos NUMBER;
   BEGIN
      OPEN cursor_total_alunos;

      LOOP
         FETCH cursor_total_alunos INTO v_disciplina, v_total_alunos;
         EXIT WHEN cursor_total_alunos%NOTFOUND;

         DBMS_OUTPUT.PUT_LINE('Disciplina: ' || v_disciplina || ' - Total de Alunos: ' || v_total_alunos);
      END LOOP;

      CLOSE cursor_total_alunos;
   END listar_total_alunos_por_disciplina;
   -- 2- FIM

   /*
   3- Cursor com média de idade por disciplina:
   Desenvolva um cursor parametrizado que receba o id_disciplina e calcule a média de idade dos alunos matriculados na disciplina especificada.
   */
   PROCEDURE listar_medida_idade_por_disciplina(p_id_disciplina NUMBER) IS
      v_media_idade NUMBER;
   BEGIN
      SELECT AVG(TRUNC(MONTHS_BETWEEN(SYSDATE, a.data_nascimento) / 12))
      INTO v_media_idade
      FROM aluno a
      JOIN matricula m ON a.id_aluno = m.id_aluno
      WHERE m.id_disciplina = p_id_disciplina;

      DBMS_OUTPUT.PUT_LINE('Média de idade dos alunos na disciplina ' || p_id_disciplina || ': ' || v_media_idade);
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         DBMS_OUTPUT.PUT_LINE('Nenhum aluno encontrado para a disciplina: ' || p_id_disciplina);
      WHEN OTHERS THEN
         DBMS_OUTPUT.PUT_LINE('Erro ao calcular média de idade: ' || SQLERRM);
   END listar_medida_idade_por_disciplina;
   -- 3- FIM

   /*
   4- Procedure para listar alunos de uma disciplina:
   Implemente uma procedure que receba o ID de uma disciplina como parâmetro e exiba os nomes dos alunos matriculados nela.
   */
   PROCEDURE listar_alunos_por_disciplina(p_id_disciplina NUMBER) IS
      CURSOR cursor_alunos IS
         SELECT DISTINCT a.nome
         FROM aluno a
         JOIN matricula m ON a.id_aluno = m.id_aluno
         WHERE m.id_disciplina = p_id_disciplina;

      v_nome aluno.nome%TYPE;
   BEGIN
      OPEN cursor_alunos;

      DBMS_OUTPUT.PUT_LINE('Alunos matriculados na disciplina: ' || p_id_disciplina);

      LOOP
         FETCH cursor_alunos INTO v_nome;
         EXIT WHEN cursor_alunos%NOTFOUND;

         DBMS_OUTPUT.PUT_LINE('Aluno: ' || v_nome);
      END LOOP;

      CLOSE cursor_alunos;
   END listar_alunos_por_disciplina;
   -- 4- FIM
END pkg_disciplina;

-- Pacote PKG_PROFESSOR (specification)
CREATE OR REPLACE PACKAGE pkg_professor IS

    -- PROCEDURE PARA O CURSOR TOTAL DE TURMAS POR PROFESSOR
    PROCEDURE listar_total_turmas_por_professor;
    
    -- FUNCTION TURMAS POR PROFESSOR
    FUNCTION  listar_turmas_por_professor (p_id_professor NUMBER) RETURN NUMBER;
    
    -- FUNCTION PROFESSOR POR DISCIPLINA
    FUNCTION  listar_professor_por_disciplina (p_id_disciplina NUMBER) RETURN VARCHAR2;
    
END pkg_professor;

-- Pacote PKG_PROFESSOR (body)
CREATE OR REPLACE PACKAGE BODY pkg_professor IS

    /*
    1- Cursor para total de turmas por professor:
    Desenvolva um cursor que liste os nomes dos professores e o total de turmas que cada um leciona. O cursor deve exibir apenas os professores responsáveis por mais de uma turma.
    */
    PROCEDURE listar_total_turmas_por_professor IS
        CURSOR cursor_total_turmas IS
            SELECT p.nome AS professor,
                   COUNT(t.id_turma) AS total_turmas
            FROM professor p
            JOIN turma t ON p.id_professor = t.id_professor
            GROUP BY p.nome
            HAVING COUNT(t.id_turma) > 1;
        v_professor professor.nome%TYPE;
        v_total_turmas NUMBER;
    BEGIN
        OPEN cursor_total_turmas;

        LOOP
            FETCH cursor_total_turmas INTO v_professor, v_total_turmas;
            EXIT WHEN cursor_total_turmas%NOTFOUND;

            DBMS_OUTPUT.PUT_LINE('Professor: ' || v_professor || ' - Total de Turmas: ' || v_total_turmas);
        END LOOP;

        CLOSE cursor_total_turmas;
    END listar_total_turmas_por_professor;
    -- 1- FIM

    /*
    2- Function para total de turmas de um professor:
    Crie uma function que receba o ID de um professor como parâmetro e retorne o total de turmas em que ele atua como responsável.
    */
    FUNCTION listar_turmas_por_professor(p_id_professor NUMBER) RETURN NUMBER IS
        v_total_turmas NUMBER;
    BEGIN
        SELECT COUNT(t.id_turma)
        INTO v_total_turmas
        FROM turma t
        WHERE t.id_professor = p_id_professor;

        RETURN v_total_turmas;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN 0;
        WHEN OTHERS THEN
            RETURN NULL;
    END listar_turmas_por_professor;
    -- 2- FIM

    /*
    3- Function para professor de uma disciplina:
    Desenvolva uma function que receba o ID de uma disciplina como parâmetro e retorne o nome do professor que ministra essa disciplina.
    */
    FUNCTION listar_professor_por_disciplina(p_id_disciplina NUMBER) RETURN VARCHAR2 IS
        v_nome_professor professor.nome%TYPE;
    BEGIN
        SELECT p.nome
        INTO v_nome_professor
        FROM disciplina d
        JOIN turma t ON d.id_disciplina = t.id_disciplina
        JOIN professor p ON t.id_professor = p.id_professor
        WHERE d.id_disciplina = p_id_disciplina;
        RETURN v_nome_professor;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN 'Professor não encontrado';
        WHEN OTHERS THEN
            RETURN 'Erro ao encontrar professor';
    END listar_professor_por_disciplina;
    -- 3- FIM
END pkg_professor;
