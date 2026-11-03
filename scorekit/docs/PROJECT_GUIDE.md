# ScoreKit: общая инструкция

ScoreKit — переиспользуемый инструмент LilyPond для сборки, проверки, экспорта и публикации партитур. Родительский репозиторий хранит музыкальное произведение и свою редакционную историю; ScoreKit не должен содержать ноты, названия произведений, состав оркестра и музыкальные исключения.

## Структура проекта

`score.ly`, `concert-score.ly`, `orchestra.ily` и `metadata.ily` принадлежат произведению. Исполнители хранятся отдельно в `music/*.ily`, а печатные обёртки — в `parts/*.ly` и при необходимости `parts/combined/*.ly`. Печатные варианты оформляются через `scorekit/lilypond/layout/*.ily`, а колонтитул Git определяется `scorekit/lilypond/version.ily`. Данные о повторах и проверках можно задать в `music/playback-map.json`.

## Сборка

Из корня проекта:

```bash
python3 scorekit/scripts/check_music_structure.py
python3 scorekit/scripts/build.py build
python3 scorekit/scripts/build.py package
```

Для MIDI, MP3 и SVG/JSON-просмотрщика (нужны SoundFont, FluidSynth и FFmpeg):

```bash
python3 scorekit/scripts/build.py build --audio --soundfont /path/to/MS_Basic.sf3
python3 scorekit/scripts/build.py package --full
```

Результаты хранятся в `dist/`. Каждый PDF A4 включает Git-версию на каждой странице. `music_hash` отслеживает музыкальные события, `print_hash` — печатное представление; точные байты файла — `pdf_sha256`. Эти хеши не должны зависеть от Git-версии.

## GitHub Actions

В корне проекта остаётся только `.github/workflows/build.yml`: события `push`, `pull_request`, ручной запуск и теги определяются там, так как GitHub не ищет workflow в подмодуле. Сами шаги сборки и релиза расположены в `scorekit/actions/build/action.yml` и `scorekit/actions/release/action.yml`.

При push/PR собираются PDF и манифест. `workflow_dispatch` с `full_export=true` и тег `v*` собирают также аудио и синхронизированный просмотрщик. Тег создаёт GitHub Release.

## Редактирование и повторное использование

В `parts/*.ly` можно указать `#(define partStaffSize 22)` и `#(define partTargetPages 2)`: сборщик подбирает максимально крупный стан, умещающийся на целевое число страниц. Печатные `R2.*N` с `\compressEmptyMeasures` образуют многотактовые паузы; метки репетиций разделяют их только в нужных местах.

Команды `python3 scorekit/scripts/navigation.py --check` и `--write` сверяют простую нотационную навигацию D.C./Fine с печатными метками. Сложные D.S., Coda и альтернативы требуют расширения механизма и не должны интерпретироваться молча. Ударные можно собирать в единый печатный голос командой `python3 scorekit/scripts/merge_percussion.py --write`; исходники по инструментам остаются самостоятельными для MIDI.

Подробнее: [Стиль](CODE_STYLE.md), [Объединение партий](PART_COMBINING.md), [Импорт](IMPORT_FROM_MUSESCORE.md), [SoundFont](SOUNDFONTS.md).
