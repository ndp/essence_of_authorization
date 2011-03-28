module EssenceOfAuthorization
  def self.restrict_subject(subject_class, verb, p)
    @@restrictions                ||= {}
    @@restrictions[subject_class] ||= {}
    if p.nil?
      @@restrictions[subject_class][verb] = []
    else
      @@restrictions[subject_class][verb] ||= []
      @@restrictions[subject_class][verb].push p
    end
  end

  def self.allow_allow?(subject, verb, direct_object)
    return true if !EssenceOfAuthorization.class_variable_defined?(:@@restrictions) ||
          @@restrictions.nil? || @@restrictions[subject.class].nil?
    r = @@restrictions[subject.class]
    (r[verb].nil? || r[verb].all? { |r| r.call(subject, direct_object) })
  end


end