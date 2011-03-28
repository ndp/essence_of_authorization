class User < ActiveRecord::Base

  include EssenceOfAuthorization::Subject

end
