# Работа с партитурой и экспорт

## Источники нот

**Единственный редактируемый источник нот** каждого исполнителя — `music/<instrument>.ily`. В файлах `parts/*.ly` находятся только контекст, метаданные и ссылки на музыкальные переменные: ноты туда не копируются. `orchestra.ily` определяет порядок оркестра. `music/paired.ily` соединяет два самостоятельных голоса через `\\partCombine` без дублирования музыкального текста. `parts/combined/*.ly` — печатные представления этих пар. Управление унисонами и раздельными голосами описано в [PART_COMBINING.md](PART_COMBINING.md). `music/global.ily` хранит единый метр, темп и репетиционные метки.

Для ударных единственные музыкальные источники — `snare-drum.ily`, `cymbals.ily`, `bass-drum.ily`. `music/percussion.ily` собирает их в один `DrumStaff`; отдельная печатная партия находится в `parts/percussion.ly`. Если инструмент не входит в произведение, его файл не нужен.

Правки нот делают в `music/`, а не в `parts/combined/`. Для добавления инструмента потребуются музыкальный исходник, небольшой wrapper в `parts/` и строка в `orchestra.ily`.

## Транспонирование и октавные ключи

Партитура в написанном строе: [score.ly](../score.ly); партитура в концертном: [concert-score.ly](../concert-score.ly). В концертном строе флейта-пикколо использует `treble^8`, контрафагот и контрабас — `bass_8`; инструментальная октавная запись не должна изменять реальную звучащую высоту. Когда в составе появляются бас-кларнет или тенор-саксофон, для них нужна `treble_8` в концертной партитуре. Транспонирование настроено только в партитурных обёртках, MIDI — в звучащем строе. Смена ключа внутри нотного текста должна быть отдельно проверена.

## Формат и версии

Все PDF — **A4**, в том числе полная дирижёрская партитура. Масштаб нот зависит от числа станов; скрывать пустые станы ради экономии страниц не требуется. Версия Git печатается в колонтитуле на каждой странице. `SCORE_BUILD_REVISION`, `SCORE_STAFF_SIZE` и `PART_STAFF_SIZE` — служебные переменные сборки и никак не связаны с названием оркестра.

`print_hash` рассчитан по нормализованным музыкальным исходникам без учёта текста Git-версии. При изменении системы гравировки или вёрстки проверяйте старые распечатки отдельно: неизменность нот не гарантирует идентичность PDF.

## GitHub Actions

- **Push / Pull Request:** компилирует PDF, делает PDF-архив и `print-manifest.json`; аудио- и SVG-экспорт не запускается.
- **Actions → Build orchestra → Run workflow → full_export:** PDF, MIDI, MP3 по инструментам и общий микс, SVG/JSON для просмотрщика и архивы.
- **Тег `v*`:** автоматически запускает полный экспорт и создаёт GitHub Release.

Для всех режимов устанавливается **последняя стабильная LilyPond**. В аудиорежиме используется официальный `MS Basic.sf3` MuseScore и FluidSynth (это не MuseSounds). Выбор нотного вида и дорожки в просмотрщике независим; общая шкала `timeline.json` связывает 152 напечатанных и 268 исполняемых тактов, включая D.C. al Fine.

## Локальная сборка

Python 3 и LilyPond должны находиться в PATH. Для предпросмотра PDF:

```powershell
py -3 scripts/build.py build
py -3 scripts/build.py package
```

Для полного комплекта (нужны FluidSynth, FFmpeg и SoundFont):

```powershell
py -3 scripts/build.py build --audio --soundfont "C:\SoundFonts\MS_Basic.sf3"
py -3 scripts/build.py package --full
```

На Linux команды те же через `python3`. Файлы сохраняются в игнорируемую папку `dist/`. Для локального интерактивного просмотрщика из `dist/` выполните `python3 -m http.server` и откройте `/viewer/` в браузере.

## Контроль качества

`python3 scripts/check_music_structure.py` проверяет границы репризы, единственность нотных источников, четвёртый такт, сольные паузы и ожидаемые ремарки. [Сверка с MusicXML](MXL_AUDIT.md) фиксирует найденные неоднозначности; зелёная сборка не заменяет музыкальную корректуру. [Соглашения об исходниках](CODE_STYLE.md) · [Перенос из MuseScore](IMPORT_FROM_MUSESCORE.md).


## Music/print hashes and printed part scaling

In dist/print-manifest.json (and viewer/manifest.json when exporting fully),
music_hash changes when musical content changes, not when engraving-only
instructions change. print_hash also tracks print wrappers, layout and credits.
Both are independent of the Git revision shown in every PDF footer.
pdf_sha256 fingerprints actual PDF bytes and therefore includes that revision.

Individual/combined printed parts use partPrintLayout to compress multi-measure
rests (with a measure count), automatically interrupted by rehearsal marks.
Neither conductor scores nor MIDI are compressed.

In parts/violins-2.ly, "#(define partStaffSize 22)" means preferred staff size
22 pt (edit the number to 21, 23, etc.); "\paper { page-count = #2 }"
requests two A4 pages. The default for other parts is 20 pt. If a page
overflows, the builder can reduce the chosen part size in 0.5 pt steps.


Для вторых скрипок `partTargetPages = 2` теперь означает автоматический
подбор *максимального* размера стана в двух страницах A4. `partStaffSize = 22`
— начальная точка поиска; размер увеличивается по 0,5 pt, пока не возникает
третья страница или переполнение. Обе страницы растягиваются по высоте,
а выбранное значение выводится в лог сборки. `page-count` намеренно не
используется: он скрывал недостаточно заполненную последнюю страницу.


## Навигация D.C. / Fine из партитуры

scripts/navigation.py --check сверяет печатные Fine / D.C. al Fine с
music/playback-map.json, числом тактов MIDI и центральной функцией playback.
После изменения надписей в music/global.ily выполните
python3 scripts/navigation.py --write, затем сохраните обновлённые файлы.
CI автоматически проверяет синхронизацию. Поддержаны линейная форма,
D.C. и D.C. al Fine. Сложные D.S./Coda/volta требуют отдельных секций
или нативного LilyPond repeat segno и намеренно не угадываются.
