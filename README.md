# CadOnline

**CadOnline** é uma plataforma digital voltada para instituições de ensino que busca **reduzir e substituir parcialmente o uso de papel no cotidiano escolar**.

A plataforma centraliza avisos, atividades, organização pessoal e colaboração entre alunos e professores em um ambiente digital simples e acessível.

O sistema é **descentralizado**, funciona dentro da instituição sem internet, no qual opcionalmente, os dados podem ser **sincronizados online**, permitindo acesso remoto quando necessário.


# Elementos da Interface

A interface pode ser organizada em três áreas principais:

### Topbar

Contém ações rápidas e informações globais do usuário.

Exemplos:

* busca
* notificações
* acesso ao perfil
* atalhos rápidos convencionais

### Sidebar

Contém a navegação principal do sistema e acesso às diferentes seções.

### Main Content

Área central onde o conteúdo da página atual é exibido no shell centralizado.


# Rotas

## Administração Global

(Associada ao serviço online central)

Responsável por operações globais da plataforma.

* gerenciamento de instituições
* gerenciamento de instâncias
* sincronizações
* operações CRUD globais


## Administração Institucional

Responsável pela configuração do CadOnline dentro da instituição.

* gerenciamento de usuários
* gerenciamento de salas de aula
* permissões e papéis
* configurações locais do sistema
* sincronização dos dados online


## Professor

Ferramentas para criação e gestão de conteúdo pedagógico.

* Minhas salas
* Avisos criados
* Atividades publicadas
* Materiais da aula
* Rascunhos de atividades


## Sala de Aula

Espaço principal de comunicação e atividades da turma.

* **Avisos**
  geridos por professores ou pela instituição

* **Atividades da sala**
  tarefas e trabalhos publicados para a turma

* **Materiais** (opcional)
  arquivos ou conteúdos compartilhados com os alunos


## Grupos

Espaço de colaboração entre alunos ou entre alunos e professores.

### Criação de grupos

Os grupos podem ser criados dessas formas:

**1. Criação por professor**

* o professor cria o grupo
* seleciona os alunos participantes através de uma lista/tabela e outros possíveis membros

**2. Criação autônoma, por alunos**

* um aluno cria o grupo
* pode convidar colegas livremente

Durante a criação do grupo, é possível escolher:


### Funcionalidades do grupo

* membros do grupo
* compartilhamento de ideias e tarefas em threads


## Pessoal

Espaço pessoal do usuário para organização individual.

* **Meus Lembretes**
* **Minhas Ideias**


## Análise (Não o foco por enquanto)

Área avançada voltada para análise e automação.
Escolha da linguagem Lua por ser uma das mais simples e leves existentes.

* Docs
* Scripting
* Meus Scripts

Utilizada para:

* análise de dados
* automações simples
* experimentos

# Especificações Técnicas

Implementação com ASP.NET no padrão MVC (dotnet core 10), Entity Framework (SQLite 3) e NLua para Scripting e analise de dados.
