require_relative "lib/tree.rb"

new_tree = Tree.new(Array.new(15) { rand(1..100) })
new_tree.pretty_print


