# The Snowstorm — Waltz

[![Build](https://github.com/0SNP0/lilypond-template/actions/workflows/build.yml/badge.svg)](https://github.com/0SNP0/lilypond-template/actions/workflows/build.yml)
[![Releases](https://img.shields.io/badge/Releases-view%20releases-2f6fbd?logo=github)](https://github.com/0SNP0/lilypond-template/releases)

## Партитура и партии

**«Метель. Вальс» — Георгий Свиридов.** Оркестровая партитура в транспонированном и концертном строе и отдельные партии для печати **только на A4**.

**[Последний опубликованный комплект](https://github.com/0SNP0/lilypond-template/releases/latest)** · [Все релизы](https://github.com/0SNP0/lilypond-template/releases) · [Сборки текущей ветки](https://github.com/0SNP0/lilypond-template/actions/workflows/build.yml).

Каждый push запускает две последовательные сборки: сначала PDF партитур и партий, затем MP3 и интерактивные SVG с общим JSON-таймлайном. MIDI используется только как промежуточный формат и не распространяется. Git-версия видна на каждой странице.

## Сведения о произведении

<!-- SCORE-METADATA:START -->
| Поле | Значение |
|---|---|
| Произведение | The Snowstorm |
| Короткое имя файлов | sviridov-snowstorm-waltz |
| Подзаголовок | Waltz |
| Оркестр | Ensemble, Assemble |
| Композитор | Georgy Sviridov |
| Автор текста | — |
| Перевод | — |
| Транскрипция | — |
| Аранжировка | — |
| Корректура | — |
| Источник | Imported from user-provided MusicXML; proofread before performance |
| Авторские права | Copyright belongs to the respective rightsholders |
<!-- SCORE-METADATA:END -->

## Тестовый сайт и просмотрщик

Страницы тестового сайта находятся в [`site/`](site/), список
репозиториев — в [`catalog.json`](catalog.json), а общий движок
просмотрщика — в [`scorekit/viewer/`](scorekit/viewer/).

- [Сборка тестового сайта в GitHub Actions](https://github.com/0SNP0/lilypond-template/actions/workflows/pages.yml) — сборка сайта и публикация на GitHub Pages из `main`; preview-артефакт остаётся доступен.
- [Адрес сайта](https://0snp0.github.io/lilypond-template/) и [просмотрщик](https://0snp0.github.io/lilypond-template/viewer/).
- [Инструкция по включению и локальному запуску](docs/TEST_SITE.md).

Репозиторий теперь **public**, а публикация сайта запускается из **`main`**.
Для первого развёртывания нужно один раз выбрать **Settings → Pages → Source: GitHub Actions**. Если Pages ещё не активирован, шаг `Configure GitHub Pages` сообщит об этом в логе.

## Фреймворк сборки

Универсальная часть проекта находится в [ScoreKit](scorekit/): сборка и экспорт, оформление LilyPond, CI/CD-компоненты, просмотрщик и [общие инструкции](scorekit/docs/PROJECT_GUIDE.md). В корне остаются только музыкальное произведение, минимальный workflow GitHub Actions и его документация. Каталог `scorekit/` подготовлен для последующего перевода в Git-сабмодуль без изменения расположения.

```bash
python3 scorekit/scripts/check_music_structure.py
python3 scorekit/scripts/build.py build
python3 scorekit/scripts/build.py package
```

## Работа над партитурой

[Транспонированная партитура](score.ly) · [Концертный строй](concert-score.ly) · [Порядок инструментов](orchestra.ily) · [Метаданные](metadata.ily).

**[Инструкция по редактированию, объединённым станам, сборке и просмотрщику](docs/PROJECT_GUIDE.md)**. Музыкальные исходники расположены в `music/*.ily`; там нет вторых копий нот для сдвоенных нотоносцев. Отчёт [сверки с MusicXML](docs/MXL_AUDIT.md).
