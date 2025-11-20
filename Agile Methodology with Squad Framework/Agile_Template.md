
# Agile — SkillBridge.AI (Template)

## 1. Visão do Produto
**É:** plataforma de requalificação com IA.  
**Não é:** marketplace completo ou sistema de RH.  
**Faz:** diagnóstico, recomendação de trilhas, simulação AR/VR, métricas.  
**Não faz:** pagamentos, SSO corporativo.

## 2. Persona & Mapa de Empatia
- Persona: Aprendiz em transição de carreira (20–28 anos).
- Dores, ganhos, tarefas, influências, canais.

## 3. Requisitos
### Funcionais (mín. 7)
1. Gerar trilhas (1–3) por gap de skills.
2. Exibir módulos com carga horária e previsão.
3. Matrícula em trilha.
4. Registrar progresso do módulo.
5. Agendamento de mentoria.
6. Exibir dashboard de progresso.
7. Exportar evidência (print/PDF).

### Não-funcionais (mín. 7)
- Usabilidade (protótipo responsivo), desempenho (carregar em <2s em rede local), segurança básica, etc.

## 4. Backlog (épicos → histórias)
| ID | Épico | História | Critérios de Aceite |
|----|------|---------|---------------------|
| H1 | Diagnóstico | Como aprendiz, quero responder 10–15 perguntas para medir meu gap. | Salvar no perfil; exibir resumo. |
| H2 | Recomendação | Quero receber 1–3 trilhas ranqueadas. | JSON com `id, nome, fit[0..1], duracaoDias`. |
| H3 | Aprendizagem | Quero iniciar trilha e ver progresso. | Atualizar % ao concluir módulo. |
| H4 | Mentorias | Quero agendar mentoria em janelas fixas. | Confirmar horário e status. |
| H5 | AR/VR | Quero simular feedback em 1:1. | 3 cenas e vídeo 2–3 min. |
| H6 | Dashboard | Quero ver previsão de conclusão. | Cards + gráfico simples. |

## 5. Casos de Uso (UC-01..)
- UC-01 Gerar Recomendação
- UC-02 Matrícula em Trilha
- UC-03 Registrar Progresso
- UC-04 Agendar Mentoria

## 6. Protótipo
(cole prints de 3–5 telas e comentários de UX)

## 7. Review & Retro
- O que foi planejado vs. entregue; TCO (CAPEX/OPEX).
