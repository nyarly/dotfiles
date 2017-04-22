def find_focused(path, tree)
  if tree["focused"]
    return path + [tree]
  else
    focus_list = tree["nodes"].map do |node|
      find_focused(path + [tree], node)
    end.find_all do |result|
      result != nil
    end

    if focus_list.length > 1
      raise "Multiple focused windows... huh?"
    else
      return focus_list.first
    end
  end
end

def each_node(nodes, &block)
  nodes.each do |sub|
    yield sub
    each_node(sub["nodes"], &block)
  end
end
