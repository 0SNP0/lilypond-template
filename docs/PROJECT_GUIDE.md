# «Метель» — работа с текущей редакцией

## Где находятся файлы

Музыка Свиридова и состав оркестра хранятся здесь, в корне репозитория: `music/*.ily`, `orchestra.ily`, `score.ly`, `concert-score.ly`, `metadata.ily`, `parts/*.ly` и `parts/combined/*.ly`.

Общие скрипты сборки, MIDI/MP3/SVG-экспорт, LilyPond-оформление и инструкции теперь в [ScoreKit](../scorekit/), подробности — в [руководстве фреймворка](../scorekit/docs/PROJECT_GUIDE.md). Git-версия остаётся на каждой странице. `music_hash`, `print_hash` и `pdf_sha256` сохраняют разные назначения.

## Текущая музыкальная форма

В этой редакции **152 печатных такта** и **268 проигрываемых**: 1–116, 117–152, 1–116, по знакам Fine и D.C. al Fine. Печатный маршрут и дополнительные редакционные проверки записаны в `music/playback-map.json`. После изменения знаков можно запустить `python3 scorekit/scripts/navigation.py --write`, затем `python3 scorekit/scripts/check_music_structure.py`.

Каждый исполнитель хранит ноты отдельно. `music/paired.ily` объединяет парные инструменты в партитуре. Источники ударных — `music/snare-drum.ily`, `music/cymbals.ily`, `music/bass-drum.ily`. Печатный единый голос `music/percussion.ily` пересобирается через `python3 scorekit/scripts/merge_percussion.py --write` и проверяется перед сборкой.

В `parts/violins-2.ly` заданы стартовый размер стана `partStaffSize = 22` и требование `partTargetPages = 2`. Сборщик увеличивает стан до предельного размера для двух страниц A4.

## Печать и выпуск

```bash
python3 scorekit/scripts/build.py build
python3 scorekit/scripts/build.py package
```

Любой push, PR, ручной запуск или тег сначала запускает PDF-задачу, публикует PDF-артефакт для раннего скачивания, после чего отдельная задача создаёт MIDI, MP3 и SVG/JSON-просмотрщик без повторной PDF-компиляции. Тег `v*` публикует в GitHub Release отдельные PDF, общий MP3 оркестра и три архива: PDF, MP3 всех дорожек и SVG/JSON просмотрщика. MIDI остаётся внутренним файлом сборки и не распространяется. Подробная [сверка с импортом](MXL_AUDIT.md) остаётся документацией именно этого произведения.


## Локальный просмотр SVG

Из корня репозитория выполните `python3 scorekit/viewer/serve.py` и откройте появившийся адрес. В поле **SVG/JSON ZIP** можно выбрать целый медиаартефакт из Actions, в том числе из приватной сборки. Вы увидите все настоящие страницы SVG партитуры и партий; звук можно загрузить отдельно. Подробнее: [инструкция ScoreKit Viewer](../scorekit/viewer/README.md).
