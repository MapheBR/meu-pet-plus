# API do MeuPet+

Documentação dos endpoints consumidos pelo app. A API é **mock em Dart (Shelf)**,
rodando localmente — mesmo padrão do projeto de referência da disciplina.

- **Base URL (dev):** `http://localhost:8080`
- **Formato:** JSON (`Content-Type: application/json; charset=utf-8`)
- **Health check:** `GET /health` → `200 {"status": "ok"}`
- **Usuário de teste do mock:** `ana@exemplo.com` / senha `123456`

## Convenções

### Autenticação

Após o login, o app envia o token em todas as requisições autenticadas:

```
Authorization: Bearer <token>
```

### Datas

Campos de data usam string ISO `YYYY-MM-DD` (ex.: `"2026-11-20"`).
`createdAt` usa ISO 8601 completo (`"2026-01-10T00:00:00.000Z"`).

### Enum `species`

| Valor na API | Opção no app (protótipo) |
|---|---|
| `dog` | Cachorro |
| `cat` | Gato |

### Status de vacina — calculado no app

A API **não** envia status pronto. O app compara `nextDueDate` com a data de
hoje e define o chip (regra do protótipo):

| Condição | Chip |
|---|---|
| `nextDueDate` < hoje | Vencida (vermelho) |
| `nextDueDate` ≤ hoje + 30 dias | Vence em breve (laranja) |
| `nextDueDate` > hoje + 30 dias | Em dia (verde) |
| Pet sem vacinas | Sem registro |

### Envelope de erro

Toda resposta de erro segue o mesmo formato:

```json
{
  "error": {
    "code": "validation_error",
    "message": "Verifique os campos destacados",
    "fields": { "nextDueDate": "Deve ser posterior à data de aplicação" }
  }
}
```

| HTTP | `code` | Quando |
|---|---|---|
| 401 | `invalid_credentials` | Login com e-mail/senha errados |
| 401 | `token_expired` | Token ausente, inválido ou expirado |
| 404 | `not_found` | Recurso inexistente (pet, vacina...) |
| 422 | `validation_error` | Dados inválidos; `fields` aponta o campo e o motivo |
| 500+ | `server_error` | Falha do servidor mock |

---

## Autenticação

### `POST /auth/login`

Entra na conta de teste do mock. Não exige token.

**Request**

```json
{ "email": "ana@exemplo.com", "password": "123456" }
```

**Response `200`**

```json
{
  "token": "mock_token_9f27c1",
  "user": {
    "id": "usr_001",
    "name": "Ana Souza",
    "email": "ana@exemplo.com",
    "createdAt": "2026-01-10T00:00:00.000Z"
  }
}
```

**Response `401`**

```json
{ "error": { "code": "invalid_credentials", "message": "E-mail ou senha inválidos" } }
```

**Response `422`** — campos obrigatórios ausentes (`email`, `password`).

### `POST /auth/logout`

Encerra a sessão no servidor. O app limpa a sessão local mesmo se a chamada falhar.

**Headers:** `Authorization: Bearer <token>`

**Response `204`** — sem corpo.

### `GET /me`

Retorna o usuário logado (tela de Perfil).

**Response `200`**

```json
{
  "id": "usr_001",
  "name": "Ana Souza",
  "email": "ana@exemplo.com",
  "createdAt": "2026-01-10T00:00:00.000Z"
}
```

**Response `401`** — `token_expired`.

---

## Pets

### `GET /pets`

Lista os pets do usuário logado (tela Home). Cada item já traz o objeto
`summary` — é ele que alimenta o chip de saúde do card, sem chamada extra.

**Response `200`**

```json
[
  {
    "id": "pet_001",
    "name": "Thor",
    "species": "dog",
    "breed": "Golden Retriever",
    "birthDate": "2024-03-10",
    "tutorId": "usr_001",
    "summary": {
      "nextVaccine": {
        "id": "vac_002",
        "name": "V10",
        "applicationDate": "2026-05-20",
        "nextDueDate": "2026-11-20"
      },
      "lastConsultation": {
        "id": "con_001",
        "date": "2026-09-12",
        "veterinarian": "Dra. Camila Reis",
        "reason": "Check-up anual"
      },
      "weight": {
        "currentKg": 12.5,
        "variationKg": 0.5,
        "firstDate": "2026-06-15",
        "lastDate": "2026-11-02"
      }
    }
  }
]
```

`summary` usa os mesmos campos do endpoint `GET /pets/:id/summary` (ver abaixo).
Campos podem ser `null` quando não há registros.

### `POST /pets`

Cadastra um pet (botão "+" da Home).

**Request**

```json
{
  "name": "Mel",
  "species": "cat",
  "breed": "Siamês",
  "birthDate": "2025-06-01"
}
```

| Campo | Obrigatório | Observação |
|---|---|---|
| `name` | sim | texto livre |
| `species` | sim | `dog` ou `cat` |
| `breed` | não | texto livre |
| `birthDate` | sim | `YYYY-MM-DD`, não pode ser futura |

**Response `201`** — objeto do pet criado (mesmo formato do item de `GET /pets`,
com `summary` zerado).

**Response `422`**

```json
{
  "error": {
    "code": "validation_error",
    "message": "Verifique os campos destacados",
    "fields": { "birthDate": "Data de nascimento não pode ser futura" }
  }
}
```

### `GET /pets/:id`

Detalhes de um pet (tela de Detalhe).

**Response `200`** — objeto do pet, mesmo formato de `GET /pets` (sem `summary`).

**Response `404`**

```json
{ "error": { "code": "not_found", "message": "Pet não encontrado" } }
```

### `GET /pets/:id/summary`

Resumo agregado do pet para a aba **Resumo** do detalhe. A API devolve os dados
brutos; o app calcula os textos e o status (ex.: "vence em 15 dias (20/11)").

**Response `200`**

```json
{
  "nextVaccine": {
    "id": "vac_002",
    "name": "V10",
    "applicationDate": "2026-05-20",
    "nextDueDate": "2026-11-20"
  },
  "lastConsultation": {
    "id": "con_001",
    "date": "2026-09-12",
    "veterinarian": "Dra. Camila Reis",
    "reason": "Check-up anual"
  },
  "weight": {
    "currentKg": 12.5,
    "variationKg": 0.5,
    "firstDate": "2026-06-15",
    "lastDate": "2026-11-02"
  }
}
```

Cada bloco é `null` quando o pet não tem registros daquele tipo.
`variationKg` = último peso − primeiro peso; `null` se houver menos de 2 registros.

**Response `404`** — pet inexistente.

---

## Vacinas

### `GET /pets/:id/vaccines`

Lista as vacinas do pet, **ordenada por `nextDueDate` crescente** (a mais urgente
primeiro). Alimenta a aba Vacinas e o cálculo do chip de status.

**Response `200`**

```json
[
  {
    "id": "vac_001",
    "petId": "pet_001",
    "name": "V8",
    "applicationDate": "2026-03-20",
    "nextDueDate": "2026-09-20"
  },
  {
    "id": "vac_002",
    "petId": "pet_001",
    "name": "V10",
    "applicationDate": "2026-05-20",
    "nextDueDate": "2026-11-20"
  }
]
```

**Response `404`** — pet inexistente.

### `POST /pets/:id/vaccines`

Registra uma vacina (botão "+" da aba Vacinas). Erros de validação voltam como
`422` e o app exibe a mensagem no campo correspondente.

**Request**

```json
{
  "name": "V11",
  "applicationDate": "2026-11-20",
  "nextDueDate": "2027-05-20",
  "veterinarian": "Dra. Camila Reis",
  "notes": "Animal quieto durante a aplicação."
}
```

| Campo | Obrigatório | Observação |
|---|---|---|
| `name` | sim | nome da vacina |
| `applicationDate` | sim | `YYYY-MM-DD` |
| `nextDueDate` | sim | `YYYY-MM-DD`, deve ser ≥ `applicationDate` |
| `veterinarian` | não | nome do profissional |
| `notes` | não | anotações livres |

**Response `201`** — objeto da vacina criada (mesmo formato do item da lista).

**Response `422`** — ex.: `fields.nextDueDate` quando a próxima dose é anterior
à aplicação.

---

## Consultas

### `GET /pets/:id/consultations`

Lista as consultas do pet, **ordenada por `date` decrescente** (mais recente
primeiro). Alimenta a aba Consultas.

**Response `200`**

```json
[
  {
    "id": "con_001",
    "petId": "pet_001",
    "date": "2026-09-12",
    "veterinarian": "Dra. Camila Reis",
    "reason": "Check-up anual",
    "notes": "Animal saudável, peso estável."
  }
]
```

`notes` é opcional e pode vir `null`.

**Response `404`** — pet inexistente.

### `POST /pets/:id/consultations`

Registra uma consulta (botão "+" da aba Consultas). Mesmo padrão do POST de
vacina.

**Request**

```json
{
  "date": "2026-11-05",
  "veterinarian": "Dr. Paulo Mendes",
  "reason": "Vacinação de rotina",
  "notes": "Sem intercorrências."
}
```

| Campo | Obrigatório | Observação |
|---|---|---|
| `date` | sim | `YYYY-MM-DD`, não pode ser futura |
| `veterinarian` | sim | nome do veterinário |
| `reason` | sim | motivo da consulta |
| `notes` | não | observações livres |

**Response `201`** — objeto da consulta criada.

**Response `422`** — `fields` aponta o campo inválido.

---

## Peso

### `GET /pets/:id/weights`

Lista os registros de peso do pet, **ordenada por `date` crescente** (ordem do
gráfico de linha). Alimenta a aba Peso.

**Response `200`**

```json
[
  { "id": "wei_001", "petId": "pet_001", "date": "2026-06-15", "weightKg": 12.0 },
  { "id": "wei_002", "petId": "pet_001", "date": "2026-09-12", "weightKg": 12.3 },
  { "id": "wei_003", "petId": "pet_001", "date": "2026-11-02", "weightKg": 12.5 }
]
```

**Response `404`** — pet inexistente.

### `POST /pets/:id/weights`

Registra um peso (botão "+" da aba Peso). Mesmo padrão dos demais POSTs.

**Request**

```json
{ "date": "2026-11-05", "weightKg": 12.6 }
```

| Campo | Obrigatório | Observação |
|---|---|---|
| `date` | sim | `YYYY-MM-DD`, não pode ser futura |
| `weightKg` | sim | número > 0, até 1 casa decimal |

**Response `201`** — objeto do registro criado.

**Response `422`** — `fields.weightKg` quando o valor é inválido.

---

## Fora do escopo do protótipo

Estes endpoints **não** fazem parte da API do MeuPet+ (itens removidos do
protótipo por não terem tela):

- `POST /auth/register` — não há cadastro de conta; o mock tem usuário fixo.
- `PUT`/`DELETE` de pets, vacinas, consultas e pesos — o protótipo só prevê
  criação e listagem.
- Endpoints de lembretes/notificações e preferências de tema — são ajustes
  **locais** do app (AsyncStorage), não passam pela API.
