# Setup do chat_with_bpmnjs

## 📋 Pré-requisitos

- `bash` (≥ 3.2)
- `xmllint` (libxml2)
- `xsltproc` (libxslt)

### Instalar Dependências

**macOS:**
```bash
brew install libxml2 libxslt
```

**Ubuntu/Debian:**
```bash
sudo apt-get install libxml2-utils libxslt1-tools
```

**CentOS/RHEL:**
```bash
sudo yum install libxml2 libxslt
```

## 🚀 Instalação Rápida

```bash
# Clonar repositório
git clone git@github.com:virtual360-io/chat_with_bpmnjs.git
cd chat_with_bpmnjs

# Tornar script executável
chmod +x navigator.sh

# Testar
./navigator.sh "/caminho/seu_processo.bpmn" summary
```

## 🎯 Uso Básico

```bash
# Resumo do processo
./navigator.sh "arquivo.bpmn" summary

# Listar tarefas de usuário
./navigator.sh "arquivo.bpmn" nodes userTask

# Buscar por palavra-chave
./navigator.sh "arquivo.bpmn" search "validar"

# Explorar fluxo (3 níveis para frente)
./navigator.sh "arquivo.bpmn" neighbors "Início" 3 out

# Encontrar caminho entre dois nós
./navigator.sh "arquivo.bpmn" path "Início" "Fim"
```

## 🔗 Integração com v360

### Opção 1: Como Submodule (Recomendado)

```bash
cd /path/to/v360

# Adicionar submodule
git submodule add git@github.com:virtual360-io/chat_with_bpmnjs.git .claude/skills/chat_with_bpmnjs

# Commit
git add .gitmodules .claude/skills/chat_with_bpmnjs
git commit -m "chore: add chat_with_bpmnjs as submodule"
```

### Opção 2: Como Symlink (Desenvolvimento)

```bash
cd /path/to/v360/.claude/skills

# Criar symlink para seu clone local
ln -s /path/to/chat_with_bpmnjs chat_with_bpmnjs
```

## 🎓 Usar como Skill no Claude Code

Após integrar ao v360, a skill `/bpmn` estará disponível:

```bash
/bpmn "/caminho/seu_processo.bpmn" "Faça um resumo do fluxo"
```

### Exemplos

```bash
# Analisar gargalos
/bpmn "processo.bpmn" "Quais são os gargalos?"

# Entender fluxos de erro
/bpmn "processo.bpmn" "Como são tratados os erros?"

# Validar processo
/bpmn "processo.bpmn" "Há algum ponto de falha?"
```

## 📝 Estrutura de Arquivos

```
chat_with_bpmnjs/
├── navigator.sh      # Script principal
├── SKILL.md          # Definição da skill para Claude Code
├── README.md         # Documentação completa
├── DEVELOPMENT.md    # Guia para contribuidores
├── INTEGRATION.md    # Integração com v360
├── SETUP.md          # Este arquivo
├── LICENSE           # MIT License
└── .gitignore        # Padrão Git
```

## 📚 Documentação

- **README.md** - Guia de uso completo com exemplos
- **SKILL.md** - Como usar no Claude Code (instruções para IA)
- **DEVELOPMENT.md** - Arquitetura e roadmap
- **INTEGRATION.md** - Guia de integração com v360

## 🧪 Validar Instalação

```bash
# Verificar dependências
which xmllint xsltproc

# Testar com arquivo BPMN de exemplo
./navigator.sh "seu_arquivo.bpmn" summary

# Se vir "=== BPMN Summary ===" - está funcionando! ✅
```

## 🆘 Troubleshooting

### Erro: "xmllint: not found"
Instale libxml2 conforme seção de pré-requisitos.

### Script retorna erro
```bash
# Debug com bash -x
bash -x navigator.sh "arquivo.bpmn" summary

# Validar arquivo BPMN
xmllint --noout "arquivo.bpmn"
```

### Skill não aparece no Claude Code
1. Certifique-se que `SKILL.md` está presente
2. Reinicie Claude Code
3. Verifique permissões: `chmod +x navigator.sh`

## 🤝 Contribuindo

Veja [DEVELOPMENT.md](DEVELOPMENT.md) para:
- Como adicionar novos comandos
- Padrões de codificação
- Roadmap de funcionalidades

## 📄 Licença

MIT License - veja [LICENSE](LICENSE)

---

**Pronto para usar!** 🚀

Próximo passo: Integrar ao v360 (Opção 1 ou 2 acima) ou testar localmente.
