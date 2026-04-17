# 📦 Nobreak — Documento Técnico Consolidado

## Identificação do equipamento
- Modelo: SMS Station II UST1400Bi
- Tipo: Nobreak (UPS) line-interactive
- Potência: 1400 VA
- Saída nominal: 115 V
- Entrada: bivolt automático (115/127/220 V)

---

## ⚙️ Arquitetura / funcionamento
- Topologia: line-interactive com autotransformador (AVR)
- Não é online (não double conversion)
- Forma de onda em bateria: não senoidal (PWM / quasi-quadrada)
- Tempo de comutação: ~0,5–1 ms
- Componentes principais:
  - relés de comutação
  - transformador com taps
  - carregador interno (float com controle pulsado)

---

## 🔋 Banco de baterias
- Configuração:
  - 2 × 12 V em série → 24 V
- Capacidade:
  - 5 Ah (VRLA AGM – Moura)
- Terminais:
  - F2 (6,3 mm)
- Estado:
  - novas
  - bem casadas
  - diferença ≤ 0,2 V sob carga
  - comportamento equilibrado

---

## 🔌 Comportamento elétrico

### Em rede (sem carga)
- Entrada: 127 V
- Saída: ~110 V
- Baterias: ~13,2–13,5 V

### Em rede (com carga)
- Saída: ~120 V
- AVR atuando corretamente

---

## 🔋 Em bateria (teste real)

### Início
- B1: 12,57 V
- B2: 12,49 V
- Δ: 0,08 V
- Comutação: imperceptível

### Após ~20 minutos
- B1: 12,2 V
- B2: 12,0 V
- Banco: 24,2 V
- Δ: 0,2 V
- Saída AC (multímetro): ~87–90 V (leitura não confiável)
- Carga: estável (Mac + monitor)

---

## 🔌 Retorno à rede
- Banco: 26,3 V
- B1: 13,1 V
- B2: 13,2 V
- Δ: 0,1 V
- Saída: 120 V

---

## 🌡️ Comportamento térmico
- Ambiente: ~28 °C
- Transformador: ~38 °C
- Baterias: <30 °C

Critério:
- ΔT baterias: ~+1–2 °C → excelente

---

## ⚡ Consumo medido

### Medições reais
| Cenário | Total (Mac + Nobreak) | Só Mac | Nobreak |
|--------|----------------------|--------|---------|
| Idle | 17 W | 8 W | 9 W |
| Compilando | 62 W | 32 W | 30 W |

### Valor adotado para projeto
👉 **Consumo do nobreak considerado: 30 W**

---

## ⚙️ Eficiência aproximada
- ~50% em cargas baixas
- Perdas elevadas típicas de UPS antigo com transformador

---

## ⏱️ Autonomia estimada

Banco:
- 24 V × 5 Ah = 120 Wh (bruto)

Energia útil:
- ~70–75% → ~85–90 Wh

Carga considerada:
- 30 W (nobreak + carga efetiva simplificada)

Autonomia:
- ~2h30 a 3h

---

## ⚠️ Características importantes
- Forma de onda não senoidal em bateria
- Multímetro comum não mede AC corretamente nesse modo
- Tensão AC deve ser inferida via:
  - comportamento da carga
  - tensão do banco DC

---

## 📊 Regras práticas de operação

- Monitorar:
  - tensão do banco DC
- Zona segura:
  - ≥ 24,0 V sob carga
- Desligamento recomendado:
  - ~23,5–24,0 V

---

## ✅ Estado geral do sistema
- Nobreak funcional
- Baterias saudáveis
- Carregador interno OK
- Sem problemas térmicos
- Comutação correta
- Autonomia consistente

---

## 📌 Conclusão

Sistema validado com:
- testes em carga real
- medições DC e térmicas
- ciclo completo (descarga + recarga)

Status:
👉 **100% operacional dentro das limitações da topologia**

---

## 🧠 Insight final
- Consumo próprio (~30 W) é significativo
- Eficiência baixa em cargas leves
- Ideal para:
  - continuidade
  - proteção
- Não ideal para:
  - uso contínuo visando eficiência energética

