# 📘 Modelo Descritivo do Banco de Dados - Shellder Connect

## Tabela `Tipo_Usuario`
📄 *Define os tipos de usuários do sistema, como administrador, voluntário, profissional da saúde e pessoa atendida. Essa tabela funciona como domínio para a classificação dos usuários cadastrados.*

- **id_tipo_usuario:** Identificador único do tipo de usuário
- **descricao:** Descrição do tipo (ex: Admin, Voluntário, Profissional, Atendido, Comum, Gestor do Abrigo, Entre outros)

| Campo             | Valor de Exemplo |
| ----------------- | ---------------- |
| `id_tipo_usuario` | 1                |
| `descricao`       | `Voluntário`     |


## Tabela `Endereco`

📄 *Registra os dados de endereço dos usuários, com vínculo direto via chave estrangeira.*

- **id**: Identificador único do endereço
- **rua**: Nome da rua
- **numero**: Número da residência
- **bairro**: Bairro do endereço
- **cidade**: Cidade do endereço
- **estado**: Estado do endereço
- **cep**: Código postal
- **complemento**: Informações adicionais do endereço

| Campo         | Valor de Exemplo              |
| ------------- | ----------------------------- |
| `id_endereco`          | 1                             |
| `rua`         | `Rua das Acácias`             |
| `numero`      | `234`                         |
| `bairro`      | `Centro`                      |
| `cidade`      | `Porto Alegre`                |
| `estado`      | `RS`                          |
| `cep`         | `90010-123`                   |
| `complemento` | `Próximo ao Hospital Central` |


## Tabela `Usuario`

📄 *Armazena os dados principais dos usuários do sistema, incluindo todos os perfis (admin, voluntário, profissional, atendido).*

- **id**: Identificador único do usuário
- **nome**: Nome completo do usuário
- **username**: Email do usuário
- **senha**: Senha de acesso do usuário
- **id_tipo_usuario**: Define o perfil do usuário (admin, voluntario, profissional, atendido)
- **telefone**: Número de telefone para contato
- **id_endereco**: Chave estrangeira para a tabela de endereço
- **data_nascimento**: Data de nascimento do usuário
- **documento**: Número de documento (CPF, RG, etc.)
- **status**: Indica se o usuário está ativo (1) ou inativo (0)

| Campo             | Valor de Exemplo      |
| ----------------- | --------------------- |
| `id_usuario`              | 12                    |
| `nome`            | `João da Silva`       |
| `username`        | `joaosilva`           |
| `senha`           | `senhaHasheada`      |
| `id_tipo_usuario`    | `1`          |
| `telefone`        | `(51) 99999-8888`     |
| `id_endereco`     | `1`                     |
| `data_nascimento` | `1990-04-15`          |
| `documento`       | `12345678900` *(CPF)* |
| `status`          | `1` *(ativo)*         |


## Tabela `Categoria`

📄 *Define categorias de itens que podem ser doados, como alimentos, roupas, medicamentos, etc.*

- **id**: Identificador único da categoria
- **descricao**: Descrição da categoria da doação que pode ser Alimento, Medicamento, Vestuário, Entre outros.

| Campo       | Valor de Exemplo |
| ----------- | ---------------- |
| `id_categoria`        | 2                |
| `descricao` | `Higiene`        |


## Tabela `Abrigo`

📄 *Representa abrigos cadastrados no sistema que podem receber ou distribuir doações.*

- **id**: Identificador único do abrigo
- **capacidade_total**: Capacidade máxima de pessoas que o abrigo comporta
- **ocupacao_atual**: Número atual de pessoas no abrigo
- **descricao**: Descrição geral do abrigo

| Campo              | Valor de Exemplo                                                                                                             |
| ------------------ | ---------------------------------------------------------------------------------------------------------------------------- |
| `id_abrigo`               | 4                                                                                                                            |
| `capacidade_total` | 80                                                                                                                           |
| `ocupacao_atual`   | 62                                                                                                                           |
| `descricao`        | `Abrigo temporário localizado na Escola Estadual Aurora, com estrutura básica, alimentação e atendimento médico voluntário.` |


## Tabela `Doacao`

📄 *Armazena as doações realizadas pelos abrigos, incluindo descrição, categoria e quantidade.*

- **id**: Identificador único da doação
- **id_abrigo**: Abrigo que está realizando a doação
- **descricao**: Descrição do item doado
- **id_categoria**: Categoria do item doado
- **quantidade**: Quantidade de itens doados

| Campo          | Valor de Exemplo                                            |
| -------------- | ----------------------------------------------------------- |
| `id_doacao`           | 23                                                          |
| `id_abrigo`    | 4 *(referência ao abrigo que cadastrou a doação)*           |
| `descricao`    | Kits de higiene pessoal (sabonete, escova e creme dental)   |
| `id_categoria` | 2 *(referência à categoria: 'Higiene')*                     |
| `quantidade`   | 10                                                          |


## Tabela `Distribuicao`

📄 *Rastreia a destinação de doações para pessoas atendidas, incluindo quantidade e data da entrega.*

- **id**: Identificador único da distribuição
- **id_doacao**: Doação que está sendo distribuída
- **qtd_destinada**: Quantidade destinada nesta distribuição
- **data_destinada**: Data da distribuição
- **id_pessoa_atendida_fk**: Pessoa atendida que irá receber a doação

| Campo                   | Valor de Exemplo                                          |
| ----------------------- | --------------------------------------------------------- |
| `id_distribuicao`                    | 15                                                        |
| `id_doacao`             | 23 *(referência à doação cadastrada pelo abrigo)*         |
| `qtd_destinada`         | 3                                                         |
| `data_destinada`        | `2025-05-23`                                              |
| `id_pessoa_atendida_fk` | 17 *(referência à pessoa atendida que receberá a doação)* |


## Tabela `Feedbacks`

📄 *Armazena avaliações feitas a profissionais de saúde, com nota, comentário e data.*

- **id_feedback:** Identificador único do feedback
- **nota:** Nota atribuída ao atendimento ou interação (ex: de 1 a 5)
- **comentario:** Comentário textual fornecido pelo avaliador
- **data_feedback:** Data e hora em que o feedback foi registrado
- **id_usuario:** Chave estrangeira para o usuário que realizou a avaliação

| Campo           | Valor de Exemplo                           |
| --------------- | ------------------------------------------ |
| `id_feedback`   | 3                                          |
| `nota`          | 5                                          |
| `comentario`    | `Atendimento excelente e muito acolhedor.` |
| `data_feedback` | `2025-05-25 10:30:00`                      |               
| `id_usuario`    | 12 *(Usuário que avaliou)*                 |


## Tabela `Registro_Evento`
📄 Registra os eventos ocorridos no sistema, como doações realizadas, distribuições efetuadas, atendimentos prestados, entre outros. Cada registro está vinculado a um tipo de evento, a um usuário e armazena a data e a localização do ocorrido.

- **id_registro_evento:** Identificador único do evento registrado
- **descricao:** Descrição detalhada do que aconteceu no evento ou do Mural com as postagens pedindo ajuda.
- **data_hora:** Data e hora em que o evento ocorreu
- **id_usuario:** Chave estrangeira do usuário responsável ou envolvido no evento
- **localizacao:** Informação textual sobre onde o evento ocorreu, neste caso será o CEP do cliente, pois será conectado na API do via CEP e teremos os demais dados.

| Campo                | Valor de Exemplo                               |
| -------------------- | ---------------------------------------------- |
| `id_registro_evento` | 4                                              |
| `descricao`          | `Distribuição de 20 kits de higiene`           |
| `data_hora`          | `2025-05-25 17:45:00`                          |
| `id_usuario`         | 12 *(João da Silva)*                           |
| `localizacao`        | `Abrigo Escola Estadual Aurora - Porto Alegre` |

