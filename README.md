# The Snowstorm — Waltz

[![Build](https://github.com/0SNP0/lilypond-template/actions/workflows/build.yml/badge.svg)](https://github.com/0SNP0/lilypond-template/actions/workflows/build.yml)
[![Releases](https://img.shields.io/github/v/release/0SNP0/lilypond-template?label=latest%20release)](https://github.com/0SNP0/lilypond-template/releases/latest)

## Партитура и партии

**«Метель. Вальс» — Георгий Свиридов.** Оркестровая партитура в транспонированном и концертном строе и отдельные партии для печати **только на A4**.

**[Последний опубликованный комплект](https://github.com/0SNP0/lilypond-template/releases/latest)** · [Все релизы](https://github.com/0SNP0/lilypond-template/releases) · [Сборки текущей ветки](https://github.com/0SNP0/lilypond-template/actions/workflows/build.yml).

Обычные коммиты запускают быстрый PDF-билд. Полный экспорт включает MP3, MIDI и интерактивные SVG с общим JSON-таймлайном; он создаётся при релизе или вручную через **Run workflow → full_export**. Git-версия видна на каждой странице.

## Сведения о произведении

| Поле | Значение |
|---|---|
<!-- SCORE-METADATA:START -->
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

## Работа над партитурой

[Транспонированная партитура](score.ly) · [Концертный строй](concert-score.ly) · [Порядок инструментов](orchestra.ily) · [Метаданные](metadata.ily).

**[Инструкция по редактированию, объединённым станам, сборке и просмотрщику](docs/PROJECT_GUIDE.md)**. Музыкальные исходники расположены в `music/*.ily`; там нет вторых копий нот для сдвоенных нотоносцев. Отчёт [сверки с MusicXML](docs/MXL_AUDIT.md).
