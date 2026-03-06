require_relative "test_helper"

class QuadraticCiTest < Minitest::Test
  def test_two_roots
    roots = QuadraticCi.solve(1, -3, 2).sort
    assert_equal [1.0, 2.0], roots
  end

  def test_one_root
    roots = QuadraticCi.solve(1, -2, 1)
    assert_equal [1.0], roots
  end

  def test_no_real_roots
    roots = QuadraticCi.solve(1, 0, 1)
    assert_equal [], roots
  end

  def test_raises_when_a_is_zero
    assert_raises(QuadraticCi::Error) { QuadraticCi.solve(0, 1, 1) }
  end
end
