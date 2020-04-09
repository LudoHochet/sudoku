class Backtracker
  attr_reader :initial_state

  def initialize(state:, next_states:, solved:)
    @initial_state = state
    @next_states = next_states
    @solved = solved
  end

  def next_states
    @next_states.call(initial_state)
  end

  def solved?
    @solved.call(initial_state)
  end

  def solve
    return initial_state if solved?
    raise 'No solutions' if next_states.empty?
    next_states.each do |next_state|
      branch = Backtracker.new(state: next_state, next_states: @next_states, solved: @solved)
      return branch.solve
    rescue
      next
    end
    raise 'No solutions'
  end
end