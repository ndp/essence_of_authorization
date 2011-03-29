module EssenceOfAuthorization::Subject

  class GrantNotAllowed<RuntimeError
  end

  class RevokeNotAllowed<RuntimeError
  end

  # Ask if this subject can do something to the designated object
  def can?(verb, direct_object)
    EssenceOfAuthorization::Authorization.query(self, verb.to_s, direct_object).count > 0
  end

  def allow_grant?(verb, direct_object)
    EssenceOfAuthorization.allow_grant?(self, verb.to_s, direct_object)
  end

  # Does nothing if the user is already allowed to do it.
  def grant!(verb, direct_object)
    raise GrantNotAllowed unless allow_grant?(verb, direct_object)
    EssenceOfAuthorization::Authorization.grant!(self, verb.to_s, direct_object)
  end

  def allow_revoke?(verb, direct_object)
    EssenceOfAuthorization.allow_revoke?(self, verb.to_s, direct_object)
  end

  # Does nothing if the user already is denied.
  def revoke!(verb, direct_object)
    raise RevokeNotAllowed unless allow_revoke?(verb, direct_object)
    EssenceOfAuthorization::Authorization.query(self, verb.to_s, direct_object).destroy_all
  end

end
