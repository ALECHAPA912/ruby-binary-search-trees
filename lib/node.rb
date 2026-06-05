class Node 
  include Comparable
  attr_reader :value, :left_node, :right_node

  def initialize(value, left_node = nil, right_node = nil)
    @value = value
    @left_node = left_node
    @right_node = right_node
  end

  def set_value(value)
    @value = value
  end

  def set_left(node)
    @left_node = node
  end

  def set_right(node)
    @right_node = node
  end

  def <=>(other)
    @value <=> other.value
  end

  def to_s
    "#{@value}"
  end
end