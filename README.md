# MeuPet+

App de acompanhamento da saúde de pets — **vacinas, consultas e peso** —
desenvolvido em Flutter/Dart para a disciplina de Mobile II.

Identidade: [TEMA.md](TEMA.md) · Protótipo: [prototipo/telas.html](prototipo/telas.html) ·
Contrato da API: [API.md](API.md)

## Estrutura (padrão da disciplina)

```
lib/scenes/<cena>/   MVVM + Factory + Coordinator (5 arquivos por cena)
packages/core/       meupet_core — modelos, Result, ApiClient, repositórios (Dart puro)
packages/design_system/  meupet_design_system — tokens, tema e componentes
packages/design_system/example/  sample app (galeria dos componentes)
server/              API mock em Dart (Shelf) — implementa o API.md
```

## Como rodar

**1. Suba a API mock** (terminal 1):

```bash
cd server
dart pub get
dart run bin/server.dart   # http://localhost:8080
```

Login de teste: `ana@exemplo.com` / `123456`

**2. Rode o app** (terminal 2):

```bash
flutter pub get
flutter run -d chrome      # web
# ou flutter run          # emulador/dispositivo Android
```

Emulador Android fala com o PC em `http://10.0.2.2:8080` (já configurado em
`lib/app/app_dependencies.dart`).

## Rodar a galeria do design system

```bash
cd packages/design_system/example
flutter pub get
flutter run -d chrome
```

## Checklist do professor

- [x] Tema e identidade visual — `TEMA.md`
- [x] Protótipo das telas — `prototipo/telas.html`
- [x] Design system + sample app — `packages/design_system` + `example/`
- [x] Documentação da API — `API.md`
- [x] Padrões de projeto (MVVM + Factory + Coordinator) — `lib/scenes`
