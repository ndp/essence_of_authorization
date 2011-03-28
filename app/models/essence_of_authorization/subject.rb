module EssenceOfAuthorization::Subject

  class AllowNotAllowed<RuntimeError
  end

  # Ask if this subject can do something to the designated object
  def can?(verb, direct_object)
    EssenceOfAuthorization::Authorization.query(self, verb.to_s, direct_object).count > 0
  end

  # Allow the user to do it.
  # Does nothing if the user is already allowed to do it.
  def allow!(verb, direct_object)
    raise AllowNotAllowed unless EssenceOfAuthorization.allow_allow?(self, verb, direct_object)
    EssenceOfAuthorization::Authorization.allow!(self, verb.to_s, direct_object)
  end

  # Deny the user from being allowed to do it
  # Does nothing if the user already is denied.
  def deny!(verb, direct_object)
    EssenceOfAuthorization::Authorization.query(self, verb.to_s, direct_object).destroy_all
  end


end
