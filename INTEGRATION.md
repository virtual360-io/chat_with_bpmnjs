# Integração com V360

## Como um Submodule

Para integrar `chat_with_bpmnjs` como submodule do v360:

```bash
cd /path/to/v360
git submodule add git@github.com:virtual360-io/chat_with_bpmnjs.git .claude/skills/chat_with_bpmnjs
```

Depois, adicione o skill ao `.claude/skills/` para que seja reconhecido automaticamente.

## Como uma Skill no Claude Code

1. **Setup Inicial**

```bash
# Após clonar chat_with_bpmnjs
cd chat_with_bpmnjs
chmod +x navigator.sh
```

2. **Uso via Claude Code**

```bash
/bpmn "/caminho/seu_processo.bpmn" "comando"
```

3. **Configuração em v360**

Atualize `.claude/skills/` para include `chat_with_bpmnjs`:

```bash
# Option 1: Symlink
ln -s /Users/victorcampos/Workspace/chat_with_bpmnjs /Users/victorcampos/Workspace/v360/.claude/skills/chat_with_bpmnjs

# Option 2: Git submodule
git submodule add git@github.com:virtual360-io/chat_with_bpmnjs.git .claude/skills/chat_with_bpmnjs
```

## Estrutura Esperada

```
.claude/skills/chat_with_bpmnjs/
├── navigator.sh     # Script principal
├── SKILL.md         # Metadata e instruções
├── README.md        # Documentação
├── DEVELOPMENT.md   # Guia de desenvolvimento
└── LICENSE          # MIT License
```

## Ambiente

O script requer:

- `bash` (≥ 3.2)
- `xmllint` (libxml2)
- `xsltproc` (libxslt)

Instalação:

```bash
# macOS
brew install libxml2 libxslt

# Ubuntu/Debian
sudo apt-get install libxml2-utils libxslt1-tools

# CentOS/RHEL
sudo yum install libxml2 libxslt
```

## Atualizações

Para manter sincronizado como submodule:

```bash
# No v360, atualizar submodule
git submodule update --remote .claude/skills/chat_with_bpmnjs

# Ou fazer pull manual
cd .claude/skills/chat_with_bpmnjs
git pull origin main
cd ../..
git add .claude/skills/chat_with_bpmnjs
git commit -m "chore: update chat_with_bpmnjs submodule"
```

## Troubleshooting

### Skill não aparece

1. Verifique se o arquivo SKILL.md está presente:
```bash
ls -la /Users/victorcampos/Workspace/chat_with_bpmnjs/SKILL.md
```

2. Reinicie Claude Code:
```bash
# Limpar cache de skills
rm -rf ~/.cache/claude-code/skills
```

3. Verifique permissões:
```bash
chmod +x /Users/victorcampos/Workspace/chat_with_bpmnjs/navigator.sh
```

### Script falha

1. Verifique dependências:
```bash
which xmllint
which xsltproc
```

2. Teste com arquivo BPMN válido:
```bash
./navigator.sh "/Users/victorcampos/Downloads/Fluxo de Material - Brasil.bpmn" summary
```

3. Debug com bash -x:
```bash
bash -x navigator.sh "seu_arquivo.bpmn" summary
```

## Roadmap de Integração

- [ ] Publicar no GitHub (virtual360-io/chat_with_bpmnjs)
- [ ] Adicionar como submodule ao v360
- [ ] CI/CD: testes automáticos
- [ ] Liberar como ferramenta pública
- [ ] Documentar em docs.v360.io
