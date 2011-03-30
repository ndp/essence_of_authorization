class Resource < ActiveRecord::Base
  include EssenceOfAuthorization::Mixin::DirectObject
end
