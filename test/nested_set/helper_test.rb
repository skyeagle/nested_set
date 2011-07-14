require 'test_helper'

class HelperTest < ActionView::TestCase
  include CollectiveIdea::Acts::NestedSet::Helper
  fixtures :categories

  def test_nested_set_options
    expected = [
      [" Top Level", 1],
      ["- Child 1", 2],
      ['- Child 2', 3],
      ['-- Child 2.1', 4],
      ['- Child 3', 5],
      [" Top Level 2", 6]
    ]
    actual = nested_set_options(Category) do |c, level|
      "#{'-' * level} #{c.name}"
    end
    assert_equal expected, actual
  end

  def test_nested_set_options_without_root
    expected = [
      [" Child 1", 2],
      [' Child 2', 3],
      ['- Child 2.1', 4],
      [' Child 3', 5]
    ]
    actual = nested_set_options(categories(:top_level), nil, :include_root => false) do |c, level|
      "#{'-' * level} #{c.name}"
    end
    assert_equal expected, actual
  end

  def test_nested_set_options_with_mover
    expected = [
      [" Top Level", 1],
      ["- Child 1", 2],
      ['- Child 3', 5],
      [" Top Level 2", 6]
    ]
    actual = nested_set_options(Category, categories(:child_2)) do |c, level|
      "#{'-' * level} #{c.name}"
    end
    assert_equal expected, actual
  end

  def test_build_node
    set = categories(:top_level).self_and_descendants
    expected = set.map{|i| [i.name, i.id]}

    hash = set.arrange
    actual = build_node(hash, lambda(&:lft)){|i, level| i.name }
    assert_equal expected, actual
  end

  def test_build_node_with_back_id_order
    expected = [
      ["Top Level", 1],
      ["Child 3", 5],
      ["Child 2", 3],
      ["Child 2.1", 4],
      ["Child 1", 2]
    ]

    hash = categories(:top_level).self_and_descendants.arrange
    actual = build_node(hash, lambda{|x| -x.id}){|i, level| i.name }
    assert_equal expected, actual
  end

  def test_sorted_nested_set
    expected = [
      [" Top Level 2", 6],
      [" Top Level", 1],
      ['- Child 3', 5],
      ['- Child 2', 3],
      ['-- Child 2.1', 4],
      ["- Child 1", 2]
    ]

    actual = sorted_nested_set_options(Category, lambda{|x| -x.id}) do |c, level|
      "#{'-' * level} #{c.name}"
    end
    assert_equal expected, actual
  end

  def test_sorted_nested_set_with_mover
    expected = [
      [" Top Level 2", 6],
      [" Top Level", 1],
      ['- Child 3', 5],
      ["- Child 1", 2]
    ]

    actual = sorted_nested_set_options(Category, lambda{|x| -x.id}, categories(:child_2)) do |c, level|
      "#{'-' * level} #{c.name}"
    end
    assert_equal expected, actual
  end
  def test_render_tree
    html = render_tree(Category.arrange) do |category, child|
      concat content_tag(:li, category)
      concat child
    end
    assert_equal html, "<ul><li>Top Level</li><ul><li>Child 1</li><li>Child 2</li><ul><li>Child 2.1</li></ul><li>Child 3</li></ul><li>Top Level 2</li></ul>"
  end

  def test_sorted_render_tree
    html = render_tree(Category.arrange, :sort => lambda{|x| -x.id}) do |category, child|
      concat content_tag(:li, category)
      concat child
    end
    assert_equal html, "<ul><li>Top Level 2</li><li>Top Level</li><ul><li>Child 3</li><li>Child 2</li><ul><li>Child 2.1</li></ul><li>Child 1</li></ul></ul>"
  end

  def test_nested_set_options_does_not_call_to_a
    expected = [
      ['Child 2', 3],
      ['Child 2.1', 4]
    ]
    actual = nested_set_options Category_NoToArray.find(3) do |c, l|
      c.name
    end
    assert_equal expected, actual
  end

end
