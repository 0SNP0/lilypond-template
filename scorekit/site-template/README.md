# Сайт конкретной партитуры на основе ScoreKit

**Один репозиторий партитуры — один сайт.** Нет центрального каталога
в ScoreKit и нет выбора чужих репозиториев или архивных версий.

Репозиторий партитуры владеет нотами, `site/index.html` и базовым Pages
workflow. ScoreKit может подключаться в виде Git-сабмодуля по пути
`scorekit/` и предоставляет HTML/JS-движок и сборку сайта.

```text
score-repository/
├── .github/workflows/pages.yml
├── site/index.html
├── scorekit/               # Git submodule, пока может быть папкой
├── score.ly, metadata.ily, orchestra.ily
├── music/, parts/
└── ...
```

Сайт собирается из **одного последнего опубликованного GitHub Release**
командами:

```bash
python3 scorekit/viewer/build_site.py --output _site
python3 scorekit/viewer/publish_latest.py --output _site --repo OWNER/REPO
```

В `_site/viewer/latest.json` содержатся название, версия и URL Release;
в `_site/viewer/latest/viewer/` — SVG и JSON; в
`_site/viewer/latest/audio/` — прямые MP3. Все страницы и дорожки
запрашиваются с того же домена Pages, без CORS и без промежуточных ZIP.
В предыдущие версии сайт не заглядывает, старые файлы не публикуются.
Страница Release остаётся источником PDF и архивов для скачивания.

Локальный просмотр из сабмодуля:

```bash
python3 scorekit/viewer/serve.py
```

При наличии `dist/viewer/` и `dist/audio/` используются локально
собранные ресурсы; иначе можно передать `--from-release` для скачивания
последнего релиза (установленный GitHub CLI с доступом к репозиторию).

При выпуске тега ScoreKit вызывает `repository_dispatch`, чтобы обновить
Pages; изменения `site/` и `scorekit/viewer/` тоже переиздают текущий
последний релиз. Отдельный будущий сайт-каталог содержит **только ссылки
на эти сайты** и не зависит от внутреннего формата данных ScoreKit.
