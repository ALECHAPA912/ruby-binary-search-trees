require_relative "node.rb"
class Tree 
  def initialize(arr)
    clean_array = prepare_array(arr)
    @root = build_tree(clean_array, 0, clean_array.length - 1)
  end

  def prepare_array(arr)
    arr.uniq.sort
  end

  def build_tree(arr, start, final)
    return nil if start > final
    mid = ((start + final) / 2).floor
    root = Node.new(arr[mid])
    root.set_left(build_tree(arr, start, mid-1))
    root.set_right(build_tree(arr,mid+1,final))
    root
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    return puts "└── EMPTY TREE" if @root.nil?
    pretty_print(node.right_node, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right_node
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.value}"
    pretty_print(node.left_node, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left_node
  end

  def insert(value)
    current_node = @root
    new_node = Node.new(value)
    while current_node 
      if current_node.value < value
        if current_node.right_node.nil?
          current_node.set_right(new_node)
          break
        end
        current_node = current_node.right_node
      elsif current_node.value > value
          if current_node.left_node.nil?
            current_node.set_left(new_node)
            break
          end
        current_node = current_node.left_node
      else
        return puts "EL VALOR #{value} NO SE AGREGO PORQUE YA EXISTE EN EL ARBOL!"
      end
    end
    puts "NODO #{value} AGREGADO!"
  end

  def delete(value)
    current_node = @root
    last_node = nil
    while current_node && current_node.value != value
      if current_node.value > value
        last_node = current_node
        current_node = current_node.left_node
      elsif current_node.value < value
        last_node = current_node
        current_node = current_node.right_node
      end
    end
    return puts "EL VALOR #{value} QUE DESEA BORRAR NO SE ENCUENTRA EN EL ARBOL" if current_node.nil?

    if current_node.left_node.nil? && current_node.right_node.nil? #si no tiene hijos
      if current_node == @root # si es nodo raiz
        @root = nil
      elsif current_node < last_node
        last_node.set_left(nil)
      else
        last_node.set_right(nil)
      end
    end

    if current_node.right_node.nil? && current_node.left_node #si tiene solo hijo 
      if current_node == @root # si es nodo raiz
        @root = current_node.left_node
      elsif current_node.left_node < last_node
        last_node.set_left(current_node.left_node)
      else
        last_node.set_right(current_node.left_node)
      end
    end

    if current_node.left_node.nil? && current_node.right_node #si tiene solo hijo derecho
      if current_node == @root #si es nodo raiz
        @root = current_node.right_node
      elsif current_node.right_node < last_node
        last_node.set_left(current_node.right_node)
      else
        last_node.set_right(current_node.right_node)
      end
    end 

    if current_node.left_node && current_node.right_node #si el nodo a borrar tiene dos hijos
      right_next = current_node.right_node #right_next es el nodo mayor siguiente al nodo actual
      while right_next
        break if right_next.left_node.nil?
        last_right_next = right_next
        right_next = right_next.left_node
      end
      if current_node == @root # si es raiz 
        @root.set_value(right_next.value) #cambiamos solo el valor del nodo al mayor siguiente para no migrar todos los subarboles
        if last_right_next
          last_right_next.set_left(right_next.right_node)  
        else
          @root.set_right(right_next.right_node)
        end
      else # si NO es raiz
        right_next.set_left(current_node.left_node)
        if current_node < last_node
          last_node.set_left(right_next)
        else
          last_node.set_right(right_next)
        end
      end
    end

    puts "NODO #{value} ELIMINADO!"
    current_node
  end

  def find(value)
    current_node = @root
    while current_node 
      return current_node if current_node.value == value
      if current_node.value < value
        current_node = current_node.right_node
      else
        current_node = current_node.left_node
      end
    end
    nil
  end

  def level_order
    return [] if @root.nil?
    queue = [@root]
    result = []
    while !queue.empty?
      current_node = queue.shift
      queue << current_node.left_node if current_node.left_node
      queue << current_node.right_node if current_node.right_node
      result << current_node
    end
    if block_given?
      result.each {|node| yield node}
    else
      result
    end
  end
  
  def level_order_recursive(queue = [@root], result = [], &block)
    return result if queue.empty?
    current_node = queue.shift
    result << current_node.value
    yield current_node if block_given?
    queue << current_node.left_node if current_node.left_node
    queue << current_node.right_node if current_node.right_node
    level_order_recursive(queue, result, &block)
  end

  def inorder(root = @root, result = [], &block)
    return result if root.nil?
    inorder(root.left_node, result, &block)
    yield root if block_given?
    result << root.value
    inorder(root.right_node, result, &block)
  end

  def preorder(root = @root, result = [], &block)
    return result if root.nil?
    yield root if block_given?
    result << root.value
    preorder(root.left_node, result, &block)
    preorder(root.right_node, result, &block)
  end

  def postorder(root = @root, result = [], &block)
    return result if root.nil?
    postorder(root.left_node, result, &block)
    postorder(root.right_node, result, &block)
    yield root if block_given?
    result << root.value
  end

  def height(value)
    return nil if value.nil?
    node = find(value)
    if node
      node_height(node) - 1
    else 
      nil
    end
  end

  def node_height(current_node, total = 0)
    return total if current_node.nil?
    left_tree = node_height(current_node.left_node, total + 1)
    right_tree = node_height(current_node.right_node, total + 1)
    [left_tree, right_tree].max
  end
  
  def depth(value)
    current_node = @root
    result = 0
    while current_node
      return result if current_node.value == value
      if current_node.value < value
        current_node = current_node.right_node
      else
        current_node = current_node.left_node
      end
      result += 1
    end
    nil
  end
  
  def balanced?(current_node = @root)
    return true if current_node.nil?
    if current_node.left_node
      left_tree = height(current_node.left_node.value)
    else
      left_tree = 0
    end
    if current_node.right_node
      right_tree = height(current_node.right_node.value)
    else
      right_tree = 0
    end
    if are_balanced?(left_tree, right_tree)
      return balanced?(current_node.left_node) && balanced?(current_node.right_node)
    else
      return false
    end
  end
  
  def are_balanced?(left, right)
    (left - right).abs < 2
  end

  def rebalance
    aux = []
    inorder { |node| aux << node.value } 
    @root = build_tree(aux, 0, aux.length - 1)
    puts "TREE REBALANCED!"
  end
end