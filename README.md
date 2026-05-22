# CadOnline

CadOnline é um editor de documentos sustentavel que propõe a substituição do uso de papel em instituições por uma alternativa digital local e ao mesmo tempo online.

## Escopo Atual

- Criação, edição e exclusão de documentos
- Favoritar documentos
- Autosave de conteúdo
- Exportação e importação com arquivos `.cad`
- Impressão com layout de folha

## Stack

- Ruby 3.4+
- Rails 8.1
- SQLite
- Importmap + Editor.js

## Como Rodar

```bash
cd cadonline
./bin/setup
bundle _4.0.8_ exec bin/rails server -p 3000
```

Acesse `http://127.0.0.1:3000`.

## Testes

```bash
cd cadonline
bundle _4.0.8_ exec rails test
```

## Observações de Segurança

- Senhas com hash seguro (`bcrypt`)
- Proteção de headers de segurança
- Filtros de log para campos sensíveis
- Controle de acesso por dono do documento

## Projeto da Feira de Ciências

- Integrantes:
  - Isaque Leite Sales
  - Gabrielle Moraes de Oliveira
  - Christopher Galucio Pereira
  - Debora Lais
  - Cristiano Antonio
- Orientadora: Prof. Marla Ricker Maduro
- Co-orientador: Prof. Elias Leitão
