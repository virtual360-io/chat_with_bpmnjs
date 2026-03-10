# Integração com Claude Code

Esta ferramenta pode ser integrada ao Claude Code como uma skill para fornecer análise interativa de processos BPMN.

## Pré-requisitos

- Claude Code instalado e configurado
- Repositório `chat_with_bpmnjs` clonado localmente
- Dependências instaladas (ver SETUP.md)

## Métodos de Instalação

### Método 1: Symlink (Desenvolvimento)

Para desenvolvimento local ou teste rápido:

```bash
# Clone ou navegue para seu diretório chat_with_bpmnjs
cd /caminho/para/chat_with_bpmnjs
chmod +x navigator.sh

# Crie symlink no diretório de skills do Claude Code
# Ajuste o caminho conforme sua instalação do Claude Code
ln -s "$(pwd)" ~/.claude/skills/bpmn

# Ou manualmente:
ln -s /caminho/para/chat_with_bpmnjs ~/.claude/skills/bpmn
```

### Método 2: Git Submodule (Recomendado)

Para projetos que usam git, adicione como submodule:

```bash
cd /caminho/para/seu/projeto

# Adicione submodule a .claude/skills
git submodule add git@github.com:virtual360-io/chat_with_bpmnjs.git .claude/skills/bpmn

# Commit
git add .gitmodules .claude/skills/bpmn
git commit -m "chore: adicionar chat_with_bpmnjs como skill submodule"
```

### Método 3: Cópia Direta

Para ambientes isolados:

```bash
cd /caminho/para/seu/projeto
cp -r /caminho/para/chat_with_bpmnjs .claude/skills/bpmn
```

## Validando a Instalação

Após a instalação, valide se a skill foi reconhecida:

```bash
# Verifique se SKILL.md existe
ls -la ~/.claude/skills/bpmn/SKILL.md

# Ou para projeto específico:
ls -la .claude/skills/bpmn/SKILL.md

# Torne o script executável
chmod +x ~/.claude/skills/bpmn/navigator.sh
```

## Usando a Skill

Após instalada, use a skill `/bpmn` no Claude Code:

```bash
/bpmn "/caminho/seu/processo.bpmn" "Analise o fluxo"
```

### Exemplos

```bash
# Obter visão geral
/bpmn "processo.bpmn" summary

# Identificar gargalos
/bpmn "processo.bpmn" "Quais são os gargalos?"

# Encontrar caminhos de tratamento de erro
/bpmn "processo.bpmn" "Como os erros são tratados?"

# Sugerir melhorias
/bpmn "processo.bpmn" "Sugira melhorias"
```

## Estrutura de Diretório

Estrutura esperada na instalação do Claude Code:

```
.claude/
└── skills/
    └── bpmn/                  # ou com outro nome
        ├── navigator.sh       # Script principal
        ├── SKILL.md           # Metadata da skill
        ├── README.md          # Documentação
        ├── DEVELOPMENT.md     # Guia de desenvolvimento
        ├── LICENSE            # MIT License
        └── .gitignore         # Regras Git
```

## Atualizando

### Para Versão com Symlink
Nenhuma ação necessária - sempre usa a versão mais recente do diretório origem.

### Para Versão com Submodule

```bash
# Atualizar para a versão mais recente
git submodule update --remote .claude/skills/bpmn

# Ou fazer pull manual
cd .claude/skills/bpmn
git pull origin main
cd ../..

# Commit da atualização
git add .claude/skills/bpmn
git commit -m "chore: atualizar submodule chat_with_bpmnjs"
```

### Para Versão Copiada

```bash
# Remover cópia antiga
rm -rf .claude/skills/bpmn

# Copiar nova versão
cp -r /caminho/para/chat_with_bpmnjs .claude/skills/bpmn
```

## Solução de Problemas

### Skill não é reconhecida

1. **Verifique se o arquivo existe:**
```bash
ls -la ~/.claude/skills/bpmn/SKILL.md
```

2. **Verifique permissões:**
```bash
chmod +x ~/.claude/skills/bpmn/navigator.sh
```

3. **Reinicie Claude Code** - Skills são carregadas ao iniciar

4. **Limpe o cache de skills (se suportado):**
```bash
# O local varia conforme SO/instalação
rm -rf ~/.cache/claude-code/skills
```

### Script falha na execução

1. **Verifique dependências:**
```bash
which xmllint xsltproc bash
```

2. **Teste diretamente:**
```bash
~/.claude/skills/bpmn/navigator.sh "seu_arquivo.bpmn" summary
```

3. **Modo debug:**
```bash
bash -x ~/.claude/skills/bpmn/navigator.sh "seu_arquivo.bpmn" summary
```

### Permissão negada

```bash
# Corrija permissões
chmod +x ~/.claude/skills/bpmn/navigator.sh
```

## Padrões de Integração

### Padrão 1: Análise Local

Use para análise rápida de arquivos BPMN locais:

```bash
/bpmn "~/Downloads/meu_processo.bpmn" "Identifique caminhos críticos"
```

### Padrão 2: Documentação do Projeto

Armazene BPMNs no projeto e analise durante desenvolvimento:

```bash
/bpmn ".docs/processos/workflow.bpmn" "Gere sugestões de melhorias"
```

### Padrão 3: Análise em Lote

Script múltiplas análises:

```bash
for file in .docs/processos/*.bpmn; do
  echo "=== Analisando $file ==="
  /bpmn "$file" summary
done
```

## Integração com CI/CD

### Exemplo GitHub Actions

```yaml
name: Análise BPMN
on: [push, pull_request]

jobs:
  analyze:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
        with:
          submodules: true

      - name: Validar arquivos BPMN
        run: |
          apt-get update
          apt-get install -y libxml2-utils libxslt1-tools

          for file in .docs/processos/*.bpmn; do
            .claude/skills/bpmn/navigator.sh "$file" summary
          done
```

## Configuração Avançada

### Alias Customizado para a Skill

Algumas instalações do Claude Code permitem aliases personalizados. Você pode configurar:

```bash
# Na configuração do Claude Code
alias analise-processo="/bpmn"
```

### Variáveis de Ambiente

Configure variáveis específicas do ambiente:

```bash
export BPMN_SKILL_PATH="/caminho/para/chat_with_bpmnjs"
export BPMN_TIMEOUT=30
```

## Suporte

- Ver [README.md](README.md) para exemplos de uso
- Ver [SETUP.md](SETUP.md) para ajuda na instalação
- Ver [DEVELOPMENT.md](DEVELOPMENT.md) para contribuir
- Abra uma issue no GitHub para bugs ou sugestões

## Licença

MIT License - Ver [LICENSE](LICENSE)
