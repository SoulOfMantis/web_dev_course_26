require_relative "quadratic_ci/version"

module QuadraticCi
  class Error < StandardError; end

  def self.solve(a, b, c)
    a = Float(a)
    b = Float(b)
    c = Float(c)

    raise Error, "a не может быть 0" if a.zero?

    d = b**2 - 4 * a * c
    return [] if d.negative?

    sqrt_d = Math.sqrt(d)

    if sqrt_d.zero?
      [(-b) / (2 * a)]
    else
      [(-b + sqrt_d) / (2 * a), (-b - sqrt_d) / (2 * a)]
    end
  end
end
