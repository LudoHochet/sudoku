require 'minitest/autorun'
require_relative 'backtracker'

class BacktrackerTest < Minitest::Test
  def test_instanciation
    assert Backtracker.new(state: 0, next_states: -> {}, solved: -> {})
  end

  def test_next_states
    next_states = Proc.new { |current_state| [current_state + 1] }
    assert_equal [1], Backtracker.new(state: 0, next_states: next_states, solved: -> {}).next_states
  end

  def test_solved
    # next_states = Proc.new { |current_state| [ current_state + 1 ] }
    solved = Proc.new { |current_state| current_state == 0 }
    assert Backtracker.new(state: 0, next_states: -> {}, solved: solved).solved?
  end

  def test_not_solved
    solved = Proc.new { |current_state| current_state == 1 }
    refute Backtracker.new(state: 0, next_states: -> {}, solved: solved).solved?
  end

  def test_no_solution
    next_states = Proc.new { |current_state| [] }
    solved = Proc.new { |current_state| current_state == 9 }
    assert_raises do
      Backtracker.new(state: 0, next_states: next_states, solved: solved).solve
    end
  end

  def test_no_solution_after_many
    next_states = Proc.new { |current_state| current_state == 5 ? [] : [current_state + 1] }
    solved = Proc.new { |current_state| current_state == 9 }
    assert_raises do
      Backtracker.new(state: 0, next_states: next_states, solved: solved).solve
    end
  end

  def test_solvable_in_one
    next_states = Proc.new { |current_state| [current_state + 1] }
    solved = Proc.new { |current_state| current_state == 1 }
    assert_equal 1, Backtracker.new(state: 0, next_states: next_states, solved: solved).solve
  end

  def test_solvable_in_many
    next_states = Proc.new { |current_state| [current_state + 1] }
    solved = Proc.new { |current_state| current_state == 9 }
    assert_equal 9, Backtracker.new(state: 0, next_states: next_states, solved: solved).solve
  end

  def test_solvable_in_many_ways
    next_states_2 = Proc.new { |current_state| [current_state + 2, current_state + 1] }
    next_states_1 = Proc.new { |current_state| [current_state + 1, current_state + 2] }
    solved = Proc.new { |current_state| current_state >= 9 }
    assert_equal 10, Backtracker.new(state: 0, next_states: next_states_2, solved: solved).solve
    assert_equal 9, Backtracker.new(state: 0, next_states: next_states_1, solved: solved).solve
  end

  def test_solvable_with_backtracking
    next_states = Proc.new do |current_state|
      if current_state == 5
        []
      elsif current_state > 5
        [current_state + 2]
      else
        [current_state + 1, current_state + 2]
      end
    end
    solved = Proc.new { |current_state| current_state >= 9 }
    assert_equal 10, Backtracker.new(state: 0, next_states: next_states, solved: solved).solve
  end


  def test_unsolvable_with_backtracking
    next_states = Proc.new do |current_state|
      if current_state >= 5
        []
      else
        [current_state + 1, current_state + 2]
      end
    end
    solved = Proc.new { |current_state| current_state >= 9 }
    assert_raises { Backtracker.new(state: 0, next_states: next_states, solved: solved).solve }
  end

  def test_initial_state_is_solution
    next_states = Proc.new { |current_state| [] }
    solved = Proc.new { |_| true }
    assert_equal 0, Backtracker.new(state: 0, next_states: next_states, solved: solved).solve
  end
end
