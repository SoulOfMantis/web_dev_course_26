# quadratic_ci

Демонстрационный гем для решения квадратного уравнения с автотестами на `minitest` и CI через GitHub Actions.

## Установка

```bash
bundle install
```

## Запуск тестов локально

```bash
bundle exec rake test
```

## Инструкция по публикации на RubyGems

1. Создайте аккаунт на [rubygems.org](https://rubygems.org).
2. Выполните вход в RubyGems CLI:
   ```bash
   gem signin
   ```
3. Соберите гем:
   ```bash
   gem build quadratic_ci.gemspec
   ```
4. Опубликуйте собранный файл:
   ```bash
   gem push quadratic_ci-0.1.0.gem
   ```
5. После публикации установка будет доступна командой:
   ```bash
   gem install quadratic_ci
   ```
