# Orchestral Sketch — Ensemble, Assemble

[![Build](https://github.com/0SNP0/lilypond-template/actions/workflows/build.yml/badge.svg)](https://github.com/0SNP0/lilypond-template/actions/workflows/build.yml)
[![Releases](https://img.shields.io/github/v/release/0SNP0/lilypond-template?label=latest%20release)](https://github.com/0SNP0/lilypond-template/releases/latest)

## Партитура и партии

Короткий оркестровый этюд для **Ensemble, Assemble**. PDF отдельных партий, общая партитура в транспонированном и концертном строе, а также звуковые дорожки доступны в выпусках проекта.

<!-- LATEST-RELEASE:START -->
**Последняя опубликованная версия: [v0.2](https://github.com/0SNP0/lilypond-template/releases/tag/v0.2).** [Скачать партии и аудио](https://github.com/0SNP0/lilypond-template/releases/tag/v0.2).
<!-- LATEST-RELEASE:END -->

В каждом релизе: **23 PDF-файла** по отдельности, архив `scores-pdf.zip` со всеми PDF и `audio.zip` со сводным MP3, 21 отдельной инструментальной MP3-дорожкой и MIDI. Дополнительно GitHub Actions хранит артефакты новых сборок на ограниченный срок.

## Сведения о произведении

| Поле | Значение |
|---|---|
<!-- SCORE-METADATA:START -->
| Произведение | Orchestral Sketch |
| Подзаголовок | An original eight-bar orchestral example |
| Оркестр | Ensemble, Assemble |
| Композитор | Original demonstration music |
| Автор текста | — |
| Перевод | — |
| Транскрипция | — |
| Аранжировка | Template contributor — replace for your arrangement |
| Корректура | — |
| Источник | Original demo, no external score used |
| Авторские права | Original demonstration music; replace credits and rights for real arrangements |
<!-- SCORE-METADATA:END -->

## Для аранжировщика

**[Открыть общую партитуру](score.ly)** — этот файл самодостаточен для предпросмотра в Frescobaldi, VS Code (LilyPond) и нативном LilyPond на Windows. Достаточно открыть `score.ly` и запустить компиляцию; предварительно запускать Python не требуется. **[Открыть концертную партитуру](concert-score.ly)**.

Музыка находится в `music/*.ily`. **[Порядок инструментов](orchestra.ily)** задаётся ровно там: по секциям и в желаемой последовательности, а не номерами в именах файлов. Отдельные файлы `parts/*.ly` открываются точно так же. Все названия инструментов английские. При изменении состава добавь/удали соответствующий `parts/name.ly`, `music/name.ily` и нотоносец в `orchestra.ily`.

Сведения о произведении меняются в **[metadata.ily](metadata.ily)**. Они используются самой партитурой и синхронизируются в README командой `python scripts/build.py readme`. Поле `ensembleName` — название оркестра, **не исполнитель и не аранжировщик**.

### Сборка Windows (без WSL)

Установить Python 3, Git for Windows и нативный LilyPond, доступные в PATH:

```powershell
py -3 scripts/build.py build
```

Для MP3 дополнительно нужны FluidSynth, FFmpeg и SoundFont:

```powershell
py -3 scripts/build.py build --audio --soundfont "C:\SoundFonts\MS_Basic.sf3"
py -3 scripts/build.py package
```

На Linux команды те же, только `python3`. Файлы результата находятся в игнорируемой папке `dist/`. `python scripts/build.py clean` удаляет сгенерированные файлы.

### Оформление

Все страницы — **A4**, поля 15 мм. Отдельные партии имеют увеличенный нотоносец, незаполненная часть страницы не растягивается. Название инструмента печатается в верхнем колонтитуле, но **не** слева от нотоносцев партии. При необходимости конкретную партию можно дополнить локальной директивой `\paper { page-count = #2 }`, следя за читаемостью.

Общая партитура автоматически выбирает масштаб исходя из числа реальных нотоносцев (включая пары станков у фортепиано и аккордеона), а сборка дополнительно уменьшает его, если LilyPond предупреждает о переполнении. Заголовок и версия центрируются относительно листа. Превью без Git-подстановки показывает метку `working-copy`.

### Версии

Версия печатается **как Git её сформировал**: например, `v1.2.0`, `v1.2.0-3-gabcdef12`, `abcdef12`, `abcdef12-dirty`. Никакая дополнительная `V` перед хешем не добавляется. При запуске из редактора вместо неизвестной версии показывается `working-copy`. Релизы собираются из чистых тегированных коммитов и содержат `build-info.json`.

### Тесты и качество

Вместо искусственных unit-тестов структура проверяется во время настоящей сборки: LilyPond должен успешно скомпилировать **все** партии, MIDI и PDF, а PDF должны быть A4 (проверяется `pypdf`, если установлен). Сборка останавливается при переполнении партитуры. Workflow вызывается на push и Pull Request; Release создаётся по Git-тегу `v*`.

### Перенос из MuseScore

См. [импорт из MusicXML](docs/IMPORT_FROM_MUSESCORE.md). Не используйте циклическую конвертацию как источник истины: LilyPond остаётся редактируемым проектом.
