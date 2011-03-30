class EssenceOfAuthorization::Approval # < ActiveModel::Base

  attr_reader :verb
  attr_reader :direct_object_class
  attr_reader :block

  def initialize(verb, direct_object_class, &block)
    @verb                = verb
    @direct_object_class = direct_object_class
    @block               = block
  end

  def approve?(subject, verb, direct_object)
#    puts 'approve ' + self.inspect
#    puts '  match? ' + matches?(subject, verb, direct_object).to_s
#    puts '  call? ' + @block.call(subject, verb, direct_object).to_s
    !matches?(subject, verb, direct_object) ||
          @block.call(subject, verb, direct_object)
  end

  def matches?(subject, verb, direct_object)
          verb == @verb &&
          direct_object.class == @direct_object_class
  end


end