#  This class deals with collecting items under specific tags
#    in a passive manner without explicitly specifying each map
#  The purpose is to enable metaprogramming patterns with method_missing
#
# Example:
#  tag1
#    item1
#    item2
#    item3
#  tag2
#    item4
#
#  Initialization:
#   collector = LazyDslTagCollector.new
#   collector.next_tag(:tag1,[])
#   collector.next_tag(:tag2, [item1,item2,item3])
#
#  Usage
#   collector.find_tag(item2)   # returns tag1
#   collector.find_tag(item4)   # returns tag2
#
#   collector.list_by_tag(tag1,[item1,item2,item3,item4])  # returns [item1,item2,item3]
#   collector.list_by_tag(tag2,[item1,item2,item3,item4])  # returns [item4]
#

class LazyDslTagCollector
  def initialize()
    @current_antecedents = []
    @current_default = nil
    @mapping = {}
    @inverse_map = {}
  end

  # antecedents indicates the list that came *BEFORE* this tag
  #  and do not actually apply to this tag, but indicate that the previous
  #  default should now be populated with the antecedents, and
  #  the default should now be set to this new tag
  def next_tag(tag_name,antecedents)
    # base case, some antecedents will land in @mapping[nil]
    # this gives us a convenient mechanism to differentiate starting
    # methods from tailing methods.
    @mapping[@current_default] ||= []
    @mapping[@current_default] += (antecedents - @current_antecedents)
    @current_default = tag_name
    @current_antecedents = antecedents
    @inverse_map.clear # force the inverse map to reload if necessary
  end

  def find_tag(value)
    construct_inverse_map! # results get cached, subsequent calls are no-op
    return @inverse_map[value] if @inverse_map.has_key?(value)
    return nil if @mapping[nil].include?(value) if !@mapping.empty?
    return @current_default
  end

  def list_by_tag(tag_name,final_list)
    return_list = @mapping[tag_name] || []
    if tag_name == @current_default
      return_list += (final_list - @current_antecedents)
    end
    return return_list
  end

  def construct_inverse_map!
    if @inverse_map.empty?
      # drop nil antecedent set from consideration via compact
      @mapping.keys.compact.each do |tag|
        @mapping[tag].each do |value|
          @inverse_map[value] = tag
        end
      end
    end
  end
end