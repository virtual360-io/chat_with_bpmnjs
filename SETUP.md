# Setup do chat_with_bpmnjs

## 📍 Localização

O repositório foi criado em:
```
/Users/victorcampos/Workspace/chat_with_bpmnjs
```

## ✅ O que foi criado

- ✅ **navigator.sh** - Script principal para análise de BPMN
- ✅ **SKILL.md** - Definição da skill para Claude Code
- ✅ **README.md** - Documentação completa
- ✅ **DEVELOPMENT.md** - Guia de desenvolvimento
- ✅ **INTEGRATION.md** - Como integrar ao v360
- ✅ **LICENSE** - MIT License
- ✅ **.gitignore** - Padrão Git
- ✅ Commit inicial no git

## 🚀 Próximas Etapas

### Opção 1: Usar Localmente (Rápido)

```bash
cd /Users/victorcampos/Workspace/chat_with_bpmnjs
./navigator.sh "/Users/victorcampos/Downloads/Fluxo de Material - Brasil.bpmn" summary
```

### Opção 2: Integrar como Submodule do v360

```bash
# No diretório do v360
cd /Users/victorcampos/Workspace/v360

# Adicionar como submodule
git submodule add git@github.com:virtual360-io/chat_with_bpmnjs.git .claude/skills/chat_with_bpmnjs

# Commit
git add .gitmodules .claude/skills/chat_with_bpmnjs
git commit -m "chore: add chat_with_bpmnjs as submodule"
```

### Opção 3: Usar Symlink (Desenvolvimento)

```bash
# No diretório do v360
cd /Users/victorcampos/Workspace/v360/.claude/skills

# Criar symlink
ln -s /Users/victorcampos/Workspace/chat_with_bpmnjs chat_with_bpmnjs
```

## 🔗 Integração com Claude Code

Após integrar (opção 2 ou 3), a skill `/bpmn` estará disponível:

```bash
/bpmn "/caminho/seu_processo.bpmn" "Faça um resumo"
```

## 📝 Comandos Disponíveis

```bash
# Resumo
./navigator.sh "arquivo.bpmn" summary

# Listar tarefas
./navigator.sh "arquivo.bpmn" nodes userTask

# Buscar
./navigator.sh "arquivo.bpmn" search "Validar"

# Explorar fluxo
./navigator.sh "arquivo.bpmn" neighbors "Início" 3 out

# Encontrar caminho
./navigator.sh "arquivo.bpmn" path "Início" "Fim"
```

## 🐙 Push para GitHub (Opcional)

Se quiser colocar no GitHub:

```bash
cd /Users/victorcampos/Workspace/chat_with_bpmnjs

# Adicionar remote (substitua com seu repo)
git remote add origin git@github.com:virtual360-io/chat_with_bpmnjs.git

# Push
git branch -M main
git push -u origin main
```

## ✨ Próximas Melhorias

Com o repositório pronto, você pode:

1. **Adicionar testes** - `test.sh` para validar comandos
2. **CI/CD** - GitHub Actions para validar BPMN files
3. **Documentação** - Expandir exemplos de uso
4. **Novos comandos** - Adicionar análises avançadas
5. **Performance** - Otimizar para BPMNs grandes (1000+ nós)

## 📚 Documentação

- **README.md** - Guia de uso geral
- **SKILL.md** - Como usar no Claude Code
- **DEVELOPMENT.md** - Para contribuidores
- **INTEGRATION.md** - Como integrar ao v360
- **LICENSE** - MIT License

## 🆘 Suporte

Para dúvidas:
1. Verifique `README.md`
2. Veja exemplos em `SKILL.md`
3. Consult `DEVELOPMENT.md` para debug

---

**Status**: ✅ Repositório criado e pronto para uso!

Próximo passo: Integrar ao v360 (Opção 2 ou 3 acima).
