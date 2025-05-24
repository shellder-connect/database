
<p align="center">
  <img src="https://github.com/shellder-connect/.github/blob/151c75b13fb239c1749b3a6efa64ed6d57608a5b/logo-readme.png" width="300"/>
</p>

# 📘 Modelo Descritivo do Banco de Dados - Shellder Connect

## Tabela `Usuario`

📄 *Armazena os dados principais dos usuários do sistema, incluindo todos os perfis (admin, voluntário, profissional, atendido).*

- **id**: Identificador único do usuário
- **nome**: Nome completo do usuário
- **username**: Nome de usuário utilizado para login
- **senha**: Senha de acesso do usuário
- **tipo_usuario**: Define o perfil do usuário (admin, voluntario, profissional, atendido)
- **telefone**: Número de telefone para contato
- **id_endereco**: Chave estrangeira para a tabela de endereço
- **data_nascimento**: Data de nascimento do usuário
- **documento**: Número de documento (CPF, RG, etc.)
- **status**: Indica se o usuário está ativo (1) ou inativo (0)

| Campo             | Valor de Exemplo      |
| ----------------- | --------------------- |
| `id`              | 12                    |
| `nome`            | `João da Silva`       |
| `username`        | `joaosilva`           |
| `senha`           | `senhaSegura123`      |
| `tipo_usuario`    | `voluntario`          |
| `telefone`        | `(51) 99999-8888`     |
| `id_endereco`     | 1                     |
| `data_nascimento` | `1990-04-15`          |
| `documento`       | `12345678900` *(CPF)* |
| `status`          | `1` *(ativo)*         |


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
| `id`          | 1                             |
| `rua`         | `Rua das Acácias`             |
| `numero`      | `234`                         |
| `bairro`      | `Centro`                      |
| `cidade`      | `Porto Alegre`                |
| `estado`      | `RS`                          |
| `cep`         | `90010-123`                   |
| `complemento` | `Próximo ao Hospital Central` |


## Tabela `Categoria`

📄 *Define categorias de itens que podem ser doados, como alimentos, roupas, medicamentos, etc.*

- **id**: Identificador único da categoria
- **descricao**: Descrição da categoria da doação

| Campo       | Valor de Exemplo |
| ----------- | ---------------- |
| `id`        | 2                |
| `descricao` | `Higiene`        |


## Tabela `Abrigo`

📄 *Representa abrigos cadastrados no sistema que podem receber ou distribuir doações.*

- **id**: Identificador único do abrigo
- **capacidade_total**: Capacidade máxima de pessoas que o abrigo comporta
- **ocupacao_atual**: Número atual de pessoas no abrigo
- **descricao**: Descrição geral do abrigo

| Campo              | Valor de Exemplo                                                                                                             |
| ------------------ | ---------------------------------------------------------------------------------------------------------------------------- |
| `id`               | 4                                                                                                                            |
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
| `id`           | 23                                                          |
| `id_abrigo`    | 4 *(referência ao abrigo que cadastrou a doação)*           |
| `descricao`    | Kits de higiene pessoal (sabonete, escova e creme dental)   |
| `id_categoria` | 2 *(referência à categoria: 'Higiene')*                     |
| `quantidade`   | 10                                                          |


## Tabela `Pessoa_Atendida`

📄 *Define os usuários que estão em situação de vulnerabilidade e recebem auxílio. Estende os dados de `Usuario`.*

- **id**: Chave estrangeira para o usuário atendido
- **categoria**: Categoria da necessidade da pessoa atendida
- **servico_desejado**: Tipo de ajuda desejada
- **observacoes**: Informações adicionais sobre a pessoa atendida

| Campo              | Valor de Exemplo                                   |
| ------------------ | -------------------------------------------------- |
| `id`               | 17 *(referência ao usuário correspondente)*        |
| `categoria`        | `Família em situação de desabrigo`                 |
| `servico_desejado` | `Abrigo e alimentação`                             |
| `observacoes`      | `Família com 3 crianças; sem acesso a transporte.` |


## Tabela `Distribuicao`

📄 *Rastreia a destinação de doações para pessoas atendidas, incluindo quantidade e data da entrega.*

- **id**: Identificador único da distribuição
- **doacao_id**: Doação que está sendo distribuída
- **qtd_destinada**: Quantidade destinada nesta distribuição
- **data_destinada**: Data da distribuição
- **id_pessoa_atendida_fk**: Pessoa atendida que irá receber a doação

| Campo                   | Valor de Exemplo                                          |
| ----------------------- | --------------------------------------------------------- |
| `id`                    | 15                                                        |
| `doacao_id`             | 23 *(referência à doação cadastrada pelo abrigo)*         |
| `qtd_destinada`         | 3                                                         |
| `data_destinada`        | `2025-05-23`                                              |
| `id_pessoa_atendida_fk` | 17 *(referência à pessoa atendida que receberá a doação)* |


## Tabela `Voluntario`

📄 *Perfil especializado do usuário que atua como voluntário no sistema, com informações sobre categoria e disponibilidade.*

- **id**: Chave estrangeira para o usuário voluntário
- **categoria**: Categoria de atuação do voluntário
- **disponibilidade**: Informações sobre a disponibilidade do voluntário

| Campo             | Valor de Exemplo                                |
| ----------------- | ----------------------------------------------- |
| `id`              | 8 *(referência ao usuário voluntário)*          |
| `categoria`       | `Distribuição de alimentos`                     |
| `disponibilidade` | `Disponível de segunda a sexta, das 14h às 18h` |


## Tabela `Empresa_Parceira`

📄 *Cadastro de empresas parceiras que oferecem serviços durante crises, vinculadas a um usuário responsável.*

- **id**: Identificador único da empresa parceira
- **usuario_id**: Usuário responsável pela empresa parceira
- **categoria**: Categoria da empresa
- **servico_oferecido**: Descrição dos serviços oferecidos pela empresa

| Campo               | Valor de Exemplo                                                     |
| ------------------- | -------------------------------------------------------------------- |
| `id`                | 4                                                                    |
| `usuario_id`        | 12 *(referência ao responsável pela empresa)*                        |
| `categoria`         | `Transporte solidário`                                               |
| `servico_oferecido` | `Disponibiliza vans para levar pessoas até abrigos durante a crise.` |


## Tabela `Especialidade`

📄 *Define áreas de atuação para profissionais da saúde, como psicologia, enfermagem, etc.*

- **id**: Identificador único da especialidade
- **descricao**: Descrição da área de especialização

| Campo       | Valor de Exemplo |
| ----------- | ---------------- |
| `id`        | 3                |
| `descricao` | `Psicologia`     |


## Tabela `Feedback`

📄 *Armazena avaliações feitas a profissionais de saúde, com nota, comentário e data.*

- **id**: Identificador único do feedback
- **nota**: Nota dada no feedback
- **comentario**: Comentário escrito pelo avaliador
- **data_feedback**: Data em que o feedback foi feito

| Campo           | Valor de Exemplo                                                 |
| --------------- | ---------------------------------------------------------------- |
| `id`            | 21                                                               |
| `nota`          | 5                                                                |
| `comentario`    | `Excelente atendimento. A psicóloga foi atenciosa e acolhedora.` |
| `data_feedback` | `2025-05-22`                                                     |


## Tabela `Profissional_Saude`

📄 *Perfil especializado do usuário que atua como profissional da saúde, vinculado à sua especialidade e feedbacks recebidos.*

- **id**: Chave estrangeira para o usuário profissional
- **id_especialidade**: Especialidade do profissional
- **forma_atendimento**: Tipo de atendimento oferecido (presencial, remoto)
- **id_feedback**: Chave estrangeira para o feedback recebido

| Campo       | Valor de Exemplo                                                         |
| ----------- | ------------------------------------------------------------------------ |
| `id`        | 7                                                                        |
| `mensagem`  | `Família com 3 crianças precisando de abrigo e alimentos na zona norte.` |
| `tipo`      | `socorro`                                                                |
| `status`    | `aberta`                                                                 |
| `data_hora` | `2025-05-23 15:45:12`                                                    |

## Tabela `Mural_Emergencia`

📄 *Espaço público onde usuários podem postar mensagens emergenciais como pedidos de ajuda ou alertas.*

- **id**: Identificador único da mensagem no mural
- **mensagem**: Conteúdo da mensagem
- **tipo**: Tipo da mensagem (socorro, aviso, etc.)
- **status**: Status da mensagem (aberta, resolvida)
- **data_hora**: Data e hora da postagem

| Campo       | Valor de Exemplo                                                         |
| ----------- | ------------------------------------------------------------------------ |
| `id`        | 7                                                                        |
| `mensagem`  | `Família com 3 crianças precisando de abrigo e alimentos na zona norte.` |
| `tipo`      | `socorro`                                                                |
| `status`    | `aberta`                                                                 |
| `data_hora` | `2025-05-23 15:45:12`                                                    |


## Tabela `RegistroEvento`

📄 *Tabela de log que armazena eventos importantes do sistema, como ações de usuários ou interações críticas.*

- **id**: Identificador único do evento registrado
- **tipo_evento**: Tipo do evento (login, distribuição, etc.)
- **descricao**: Descrição do que ocorreu
- **data_hora**: Momento em que o evento aconteceu
- **id_usuario**: Usuário responsável pelo evento
- **localizacao**: Local associado ao evento
- **dados_json**: Dados complementares armazenados em formato JSON

| Campo         | Valor de Exemplo                                               |
| ------------- | -------------------------------------------------------------- |
| `id`          | 1                                                              |
| `tipo_evento` | `distribuicao.criada`                                          |
| `descricao`   | `Doação ID 23 foi distribuída para a pessoa atendida ID 17`    |
| `data_hora`   | `2025-05-23 14:32:10`                                          |
| `id_usuario`  | `5` (representa o voluntário que executou a ação)              |
| `localizacao` | `Porto Alegre - RS`                                            |
| `dados_json`  | `{"doacao_id": 23, "pessoa_atendida_id": 17, "quantidade": 5}` |

