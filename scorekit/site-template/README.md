# Отдельный сайт на основе ScoreKit

Это шаблон **будущего независимого репозитория сайта**, а не запущенный сайт.
И проект партитуры, и проект сайта подключают один и тот же Git-сабмодуль
`scorekit/`. Пока фактического сабмодуля нет: здесь подготовлены шаблоны.

Структура будущего сайта:

```text
scorekit-site/
├── .github/workflows/pages.yml
├── .gitmodules
├── scorekit/                  # Git submodule — фреймворк
├── catalog.json              # [] — хранится в сайте, НЕ в ScoreKit
└── site/
    ├── index.html            # главная страница сайта
    └── docs/                 # будущие дополнительные страницы
```

После выделения фреймворка в репозиторий:

```bash
git submodule add https://github.com/OWNER/scorekit.git scorekit
cp scorekit/site-template/catalog.json .
mkdir -p site .github/workflows
cp scorekit/site-template/site/index.html site/index.html
cp scorekit/site-template/.github/workflows/pages.yml .github/workflows/pages.yml
python3 scorekit/viewer/serve.py
```

Результат локального запуска: `http://127.0.0.1:8000/viewer/`,
а корень сайта доступен по `http://127.0.0.1:8000/`.
Самостоятельная сборка: `python3 scorekit/viewer/build_site.py --output _site`.

GitHub Pages публикует `_site/`. Для проектного сайта адрес
`https://OWNER.github.io/REPOSITORY/viewer/`, для персонального
`https://OWNER.github.io/viewer/`. Относительные пути сохранены.
В настройках GitHub Pages выбрать **Build and deployment → GitHub Actions**.
Для приватного сабмодуля потребуется доступ из workflow к его репозиторию.

Обновление только `catalog.json` и `site/` не требует нового коммита
в ScoreKit. Никакого реального Pages-деплоя здесь пока нет.
