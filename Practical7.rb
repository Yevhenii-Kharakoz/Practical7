class Node
  attr_accessor :value, :left, :right

  def initialize(value, left = nil, right = nil)
    @value = value
    @left = left
    @right = right
  end

  def leaf?
    left.nil? && right.nil?
  end
end

def huffman_encode(text)
  frequencies = text.chars.each_with_object(Hash.new(0)) { |char, freq| freq[char] += 1 }
  nodes = frequencies.map { |char, freq| Node.new(char, nil, nil) }
  while nodes.length > 1
    nodes.sort_by! { |node| node.value }
    left, right = nodes.shift(2)
    parent = Node.new(left.value + right.value, left, right)
    nodes.unshift(parent)
  end
  codes = {}
  build_huffman_codes(nodes[0], '', codes)
  encoded_text = text.chars.map { |char| codes[char] }.join
  [encoded_text, nodes[0]]
end

def build_huffman_codes(tree, prefix, codes)
  if tree.leaf?
    codes[tree.value] = prefix
  else
    build_huffman_codes(tree.left, prefix + '0', codes)
    build_huffman_codes(tree.right, prefix + '1', codes)
  end
end

def huffman_decode(encoded_text, tree)
  decoded_text = ''
  node = tree
  encoded_text.each_char do |bit|
    if bit == '0'
      node = node.left
    else
      node = node.right
    end

    if node.leaf?
      decoded_text += node.value
      node = tree
    end
  end
  decoded_text
end


text = "Ruby"
encoded_text, huffman_tree = huffman_encode(text)
puts "Encoded text: #{encoded_text}"
decoded_text = huffman_decode(encoded_text, huffman_tree)
puts "Decoded text: #{decoded_text}"
