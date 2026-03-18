# CadOnline

## Website minimo em Ruby on Rails

Foi adicionada uma base Rails minima na raiz do repositorio com:

* rota inicial em `/`
* controller `PagesController`
* view e layout responsivos
* SQLite configurado
* teste basico para a home
* menos arquivos-placeholder no repositorio

### Como rodar a versao Rails

Requisitos:

* Ruby 3.2 ou superior
* Bundler
* SQLite3

Comandos:

```bash
make setup
make run
```

Abra `http://127.0.0.1:3000` no navegador.
O endpoint `http://127.0.0.1:3000/up` retorna o health check padrao do Rails.
As gems ficam isoladas em `vendor/bundle`.

## Prototipo Lucky local

Observacao: a implementacao executavel presente na raiz deste checkout e a versao Rails descrita acima.
As notas abaixo sao historicas e descrevem um prototipo anterior mencionado na documentacao.

Este repositorio agora tambem inclui um esboco em **Crystal + Lucky** na pasta `cad_online_lucky`, com **SQLite local** para facilitar execucao sem PostgreSQL.

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

# Implementação Atual

A implementação real do website está no projeto `cadonline`, feito utilizando a framework Ruby on Rails.

### Funcionalidades implementadas

* shell completo com **topbar + sidebar + conteúdo principal**
* rotas para:
  * painel
  * administração global
  * administração institucional
  * professor
  * sala de aula
  * grupos
  * pessoal
  * análise
* autenticação com:
  * login por usuário e senha
  * logout
  * criação de conta (instituição, turma, curso, turno)
  * perfis salvos em cookie do navegador
* persistência em SQLite com dados de exemplo:
  * instituições
  * turmas
  * usuários
  * avisos
  * atividades e entregas
  * lembretes e ideias
  * grupos e threads
  * scripts da área de análise
* integração com **NLua** no backend para execução de script Lua na área de Análise

### Como executar

```bash
cd CadOnline.Web
dotnet run
```

Abra no navegador o endereço mostrado no terminal.

### Logins de teste

Todos os usuários seedados usam senha: `1234`

Exemplos:

* `superadmin` (Admin Global)
* `coordenadora` (Admin Institucional)
* `prof.celia` (Professor)
* `maria` (Aluno)

