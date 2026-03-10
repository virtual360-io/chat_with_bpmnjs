# Desenvolvimento

## Arquitetura

### Componentes

- **navigator.sh**: Script principal que parseia BPMN XML e executa queries
  - Usa `xmllint` para parsing
  - Usa `xsltproc` para XPath queries
  - Implementa BFS para traversal

- **SKILL.md**: Definição da skill para Claude Code
  - Metadata e instruções para o Claude usar a ferramenta

### Fluxo de Execução

1. Usuário executa: `navigator.sh "arquivo.bpmn" "comando" [args]`
2. Script valida arquivo BPMN
3. Extrai estrutura XML relevante
4. Executa query apropriada (summary, search, path, etc.)
5. Formata e retorna resultado

## Estrutura BPMN

O script trabalha com elementos BPMN padrão:

```xml
<bpmn:definitions>
  <bpmn:process id="Process_1">
    <!-- Eventos -->
    <bpmn:startEvent id="Event_1"/>
    <bpmn:endEvent id="Event_2"/>
    <bpmn:intermediateThrowEvent id="Event_3"/>

    <!-- Tarefas -->
    <bpmn:userTask id="Task_1"/>
    <bpmn:serviceTask id="Task_2"/>
    <bpmn:scriptTask id="Task_3"/>

    <!-- Fluxos -->
    <bpmn:sequenceFlow id="Flow_1"
                       sourceRef="Task_1"
                       targetRef="Task_2"
                       name="Transição"/>

    <!-- Dados -->
    <bpmn:dataStoreReference id="Data_1"/>
  </bpmn:process>
</bpmn:definitions>
```

## Melhorias Planejadas

- [ ] Suporte a subprocessos
- [ ] Análise de parallelismo
- [ ] Exportar análise em JSON
- [ ] Detectar ciclos/deadlocks
- [ ] Estatísticas de complexidade
- [ ] Visualizar fluxo em ASCII
- [ ] Testes unitários

## Testing

Para testar o script:

```bash
# Teste simples
./navigator.sh "seu_processo.bpmn" summary

# Debug
bash -x navigator.sh "seu_processo.bpmn" nodes userTask
```

## Padrões de Codificação

- Use `#!/bin/bash` no topo de scripts
- Prefira `[[ ]]` em vez de `[ ]` para testes condicionais
- Use `local` para variáveis de função
- Documente funções com comentários descritivos
- Use `set -e` para falhar em erros

## Adicionando Novos Comandos

1. Adicione função em `navigator.sh`:
```bash
handle_new_command() {
  local bpmn_file="$1"
  local arg1="$2"

  # Implemente lógica
  # Use XPath/xmllint conforme necessário
}
```

2. Adicione case no main:
```bash
new_command)
  handle_new_command "$bpmn_file" "$@"
  ;;
```

3. Documente em SKILL.md:
```markdown
| `new_command` | Descrição | `new_command ARG` |
```

## Integração com Claude Code

A skill é registrada em `.claude/skills/` quando o repositório é um submodule.

Para usar localmente:
1. Copie `SKILL.md` para `.claude/skills/bpmn/SKILL.md`
2. Copie `navigator.sh` para `.claude/skills/bpmn/navigator.sh`
3. Ou configure o symlink

## Reporting Bugs

Abra uma issue com:
- Descrição do problema
- Arquivo BPMN (se possível)
- Comando executado
- Output esperado vs. actual

## Roadmap

### v1.0 (Atual)
- [x] Summary
- [x] Nodes listing com filtro
- [x] Search
- [x] Node details
- [x] Neighbors traversal
- [x] Path finding

### v1.1 (Próximo)
- [ ] Detectar problemas comuns (tarefas órfãs, loops infinitos)
- [ ] Sugerir otimizações automáticas
- [ ] Export em diferentes formatos (JSON, CSV, Mermaid)

### v2.0
- [ ] Análise de performance
- [ ] Simulação de fluxo
- [ ] Machine learning para detectar anomalias
