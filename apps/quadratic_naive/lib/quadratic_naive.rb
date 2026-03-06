require_relative "quadratic_naive/version"

module QuadraticNaive
  class Error < StandardError; end

  # Наивное решение квадратного уравнения ax^2 + bx + c = 0
  # Возвращает массив из двух корней (или nil, если корней нет).
  def self.solve(a, b, c)
    raise Error, "a не может быть 0" if a.to_f == 0.0

    d = b.to_f**2 - 4 * a.to_f * c.to_f
    return nil if d < 0

    sqrt_d = Math.sqrt(d)
    x1 = (-b.to_f + sqrt_d) / (2 * a.to_f)
    x2 = (-b.to_f - sqrt_d) / (2 * a.to_f)
    [x1, x2]
  end
end
