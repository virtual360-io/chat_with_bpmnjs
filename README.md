# Chat with BPMN.js

Um CLI tool para analisar e navegar processos BPMN (Business Process Model and Notation) interativamente, com suporte a queries complexas, pathfinding e traversal de fluxos.

## 🎯 Objetivo

Fornecer uma interface conversacional para compreender fluxos BPMN, identificar gargalos, sugerir melhorias e rastrear caminhos entre tarefas.

## 🚀 Quick Start

### Requisitos
- `bash`
- `xmllint` (libxml2)
- `xsltproc`

### Instalação

```bash
git clone git@github.com:virtual360-io/chat_with_bpmnjs.git
cd chat_with_bpmnjs
chmod +x navigator.sh
```

### Uso Básico

```bash
# Obter resumo do processo
./navigator.sh "seu_processo.bpmn" summary

# Listar todas as tarefas de usuário
./navigator.sh "seu_processo.bpmn" nodes userTask

# Buscar por nome
./navigator.sh "seu_processo.bpmn" search "validar"

# Obter detalhes de um nó
./navigator.sh "seu_processo.bpmn" node "Activity_123abc"

# Explorar vizinhos (3 níveis de profundidade)
./navigator.sh "seu_processo.bpmn" neighbors "Validar Nota" 3

# Encontrar caminho entre dois nós
./navigator.sh "seu_processo.bpmn" path "Início" "Fim"
```

## 📋 Comandos Disponíveis

| Comando | Descrição | Exemplo |
|---------|-----------|---------|
| `summary` | Resumo da estrutura: contagem de nós, eventos de início/fim | `summary` |
| `nodes [TYPE]` | Lista nós (filtro: userTask, serviceTask, scriptTask, startEvent, endEvent, intermediateThrowEvent) | `nodes userTask` |
| `search QUERY` | Busca case-insensitive por nome (nós + edges) | `search "MIRO"` |
| `node QUERY` | Detalhes do nó: tipo, entrada, saída, anotações | `node Activity_0az63ap` |
| `neighbors QUERY [DEPTH] [in\|out]` | Traversal BFS do nó. Padrão: depth 2, direction out | `neighbors "Buscar dados" 3` |
| `path FROM TO` | Caminho mais curto entre dois nós (ID ou nome) | `path Event_0dh083f Event_172sglm` |

## 📖 Tipos de Nós BPMN

- **`userTask`**: Tarefas que requerem ação humana
- **`serviceTask`**: Passos automatizados/integrações
- **`scriptTask`**: Lógica executada automaticamente
- **`startEvent`**: Ponto de início do fluxo
- **`endEvent`**: Ponto de término do fluxo
- **`intermediateThrowEvent`**: Mudanças de status ou eventos automáticos
- **`dataStoreReference`**: Sistemas de dados (ex: GRC, MIRO, SAP)

## 🎓 Estratégia de Análise

1. **Comece com summary**: Entenda a estrutura geral do fluxo
2. **Localize nós**: Use `search` para encontrar nós relevantes
3. **Estude um nó**: Use `node` para ver conexões de entrada/saída
4. **Explore para frente**: Use `neighbors QUERY N out` para ver o que acontece depois
5. **Explore para trás**: Use `neighbors QUERY N in` para ver o que leva a um nó
6. **Rastreie caminhos**: Use `path` para encontrar rotas entre pontos
7. **Itere**: Combine múltiplos comandos conforme necessário

## 💡 Exemplos de Uso

### Analisar Gargalos

```bash
# Encontrar todas as tarefas de espera
./navigator.sh "processo.bpmn" search "Aguardando"

# Explorar o que acontece após uma tarefa
./navigator.sh "processo.bpmn" neighbors "Aguardando Aprovação" 5 out
```

### Entender Fluxos de Erro

```bash
# Buscar tratamento de erro
./navigator.sh "processo.bpmn" search "Erro"

# Encontrar caminhos para conclusão após erro
./navigator.sh "processo.bpmn" path "Erro Validação" "Fim de Processo"
```

### Validar Fluxos

```bash
# Contar tarefas por tipo
./navigator.sh "processo.bpmn" nodes serviceTask | wc -l

# Listar todos os possíveis endpoints
./navigator.sh "processo.bpmn" nodes endEvent
```

## 🔧 Integração com Claude Code

Use o skill `/bpmn` no Claude Code para análises interativas:

```bash
/bpmn "/caminho/seu_processo.bpmn" "Quais são os gargalos?"
```

## 📝 Formato BPMN

O script aceita arquivos BPMN 2.0 XML padrão. Exemplo:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<bpmn:definitions xmlns:bpmn="http://www.omg.org/spec/BPMN/20100524/MODEL">
  <bpmn:process id="Process_1">
    <bpmn:startEvent id="Start_1" name="Início"/>
    <bpmn:userTask id="Task_1" name="Validar Nota"/>
    <bpmn:endEvent id="End_1" name="Fim"/>
    <bpmn:sequenceFlow id="Flow_1" sourceRef="Start_1" targetRef="Task_1"/>
    <bpmn:sequenceFlow id="Flow_2" sourceRef="Task_1" targetRef="End_1"/>
  </bpmn:process>
</bpmn:definitions>
```

## 🐛 Troubleshooting

### Erro: `xmllint: not found`
```bash
# macOS
brew install libxml2

# Ubuntu/Debian
sudo apt-get install libxml2-utils

# CentOS/RHEL
sudo yum install libxml2
```

### Erro: Arquivo não encontrado
Certifique-se de usar o caminho **absoluto** ou relativo correto para o arquivo BPMN.

### Query retorna vazio
- Use `search` antes para verificar o nome exato do nó
- Nomes são case-insensitive, mas devem ter fragmentos corretos
- Use IDs de nó (ex: `Activity_123`) como fallback

## 📚 Casos de Uso

- **Process Mining**: Analisar e otimizar fluxos de trabalho
- **Compliance**: Validar conformidade de processos
- **Troubleshooting**: Investigar bloqueios e gargalos
- **Documentation**: Gerar insights sobre fluxos complexos
- **Training**: Entender como processos funcionam

## 🤝 Contribuindo

Sugestões, bug reports e PRs são bem-vindos! Por favor, abra uma issue no GitHub.

## 📄 Licença

MIT License - veja [LICENSE](LICENSE) para detalhes.

## 📧 Suporte

Para dúvidas ou problemas, abra uma issue no repositório.
