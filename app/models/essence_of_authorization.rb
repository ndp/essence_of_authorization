

module EssenceOfAuthorization

  def self.approve_grants(subject_class, verb, direct_object_class, &block)
    @approve_grants ||= []
    @approve_grants <<
          EssenceOfAuthorization::Approval.new(subject_class, verb, direct_object_class, &block)
  end

  def self.allow_grant?(subject, verb, direct_object)
    return true if @approve_grants.nil?
    @approve_grants.all? do |r|
      r.approve?(subject, verb, direct_object)
    end
  end

  def self.allow_revoke?(subject, verb, direct_object)
    return true;
  end


end