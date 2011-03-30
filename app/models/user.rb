class User < ActiveRecord::Base

  include EssenceOfAuthorization::Mixin::User

end
