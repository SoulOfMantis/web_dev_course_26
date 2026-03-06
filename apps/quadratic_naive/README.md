# quadratic_naive

Демонстрационный гем с **наивной** реализацией решения квадратного уравнения.

## Установка

```bash
gem build quadratic_naive.gemspec
gem install ./quadratic_naive-0.1.0.gem
```

## Использование

```ruby
require "quadratic_naive"

roots = QuadraticNaive.solve(1, -3, 2)
# => [2.0, 1.0]
```

## Важно

В этом геме **нет тестов** специально (по условиям демонстрации).
