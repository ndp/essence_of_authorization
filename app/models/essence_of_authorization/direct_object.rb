module EssenceOfAuthorization::DirectObject

  def who_can?(verb)
    EssenceOfAuthorization::Authorization.who_can?(verb, self)
  end


end