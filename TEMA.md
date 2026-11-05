# TEMA — MeuPet+

App Flutter da disciplina Mobile II para tutores acompanharem a saúde do
seu animal de estimação: **vacinas, consultas e peso**.

## Nome do app

**MeuPet+**

## Identidade visual (definida pelo aluno)

- **Logo**: nome "MeuPet+" com elementos de cachorro, gato e patinha
  (`Logo MeuPet+ com Cães e Gatos.png`, mesma pasta deste arquivo).
- **Slogan**: "Cuidado, amor e bem-estar sempre!"
- **Personalidade**: confiança, carinho, qualidade e proximidade.
- **Paleta**:
  - Azul-marinho `#102D59` — confiança e segurança (cor primária)
  - Laranja `#FF9100` — energia e alegria (cor de destaque)
  - Off-white `#F8F7F3` — leveza e simplicidade (fundo)

## Problema que o app resolve

Quem tem pet esquece vacinas, perde o histórico de consultas e não
consegue perceber se o animal está ganhando ou perdendo peso
saudavelmente. Hoje isso fica espalhado em caderninho, print de
WhatsApp e memória.

## Objetivo

Centralizar em um só lugar, por pet:

- **Vacinas** — qual vacina foi tomada, quando e quando é a próxima.
- **Consultas** — histórico de atendimentos veterinários (motivo,
  diagnóstico, observações).
- **Peso** — registro do peso ao longo do tempo, para ver evolução
  em gráfico.

## Persona

**Ana, 28 anos, tutora de uma cachorra (e às vezes de um gato).**
Cuida da saúde do pet mas trabalha muito e esquece datas. Quer abrir
o app e responder rápido: "a vacina do filhote está em dia?",
"quando foi a última consulta?", "ele está engordando?".

## Escopo decidido

| Decisão | Escolha | Por quê |
|---|---|---|
| Pets por usuário | **Vários pets** | O professor não definiu; um tutor real pode ter mais de um animal. O modelo de dados quase não muda — cada registro (vacina, consulta, peso) aponta para um `petId`. |
| Backend | **API mock em Dart (shelf)** | Mesmo padrão do projeto de referência (carteira digital). Permite documentar requests/responses de verdade e trocar por backend real depois sem mexer na UI. |
| Dados locais | Nenhum (fase de protótipo) | Tudo vem da API mock, como no app de referência. |
| Autenticação | Login simples | O projeto de referência tem login; seguir o mesmo padrão facilita a apresentação. |

## Telas (protótipo aprovado — 15 telas)

Wireframe visual autocontido em `prototipo/telas.html` (abrir no
navegador; logo em base64 e ícones SVG — funciona offline).
Identidade: azul-marinho `#102D59`, laranja `#FF9100`, off-white
`#F8F7F3`, Poppins (títulos) + Inter (texto), Material-style icons.

1. **Splash** — logo em fundo azul claro; decide Login ou Home.
2. **Login** — marca no topo, email + senha, botão laranja.
3. **Home** — header com marca, lista de pets com chip de status,
   "+" para cadastrar pet.
4. **Home — carregando** — skeleton dos cards.
5. **Home — vazio** — ilustração + texto + botão "Cadastrar pet".
6. **Home — erro** — mensagem + "Tentar novamente".
7. **Detalhe do Pet — Visão geral** — resumo de vacinas, última
   consulta e peso.
8. **Detalhe — Vacinas** — 3 estados: em dia / vence em breve / vencida.
9. **Detalhe — Consultas** — data, veterinário, motivo, observações.
10. **Detalhe — Peso** — gráfico de linha + histórico + variação.
11. **Formulário — Nova vacina** — POST /pets/:id/vaccines.
12. **Formulário — Nova consulta** — POST /pets/:id/consultations.
13. **Formulário — Peso** — POST /pets/:id/weights.
14. **Formulário — Novo pet** — POST /pets (espécie em chips).
15. **Perfil** — dados do usuário, switches de notificações/tema,
    logout.

Navegação: bottom bar só com **Início** e **Perfil** (Home e Perfil);
telas internas usam barra única com voltar + título. Marca (logo +
 nome) aparece só em Splash, Login e Home. O "+" laranja (FAB) existe
na Home (cadastra pet) e em cada aba do pet (cadastra o registro).

## Entidades da API (rascunho para a próxima parte)

- `User` — id, nome, email
- `Pet` — id, nome, espécie (cachorro/gato), raça, data de nascimento, tutorId
- `Vaccine` — id, petId, nome, dataAplicacao, proximaData
- `Consultation` — id, petId, data, veterinario, motivo, observacoes
- `WeightRecord` — id, petId, data, pesoKg

## Checklist do professor

- [x] Definir o tema
- [x] Protótipo das telas (`prototipo/telas.html`)
- [ ] Design system + sample app
- [ ] Documentação da API (requests e responses)
- [ ] Seguir padrões de projeto da disciplina (MVVM + Factory + Coordinator)
