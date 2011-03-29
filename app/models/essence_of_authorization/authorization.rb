class EssenceOfAuthorization::Authorization < ActiveRecord::Base
  set_table_name :authorizations
  belongs_to :subject, :polymorphic => true
  belongs_to :direct_object, :polymorphic => true

  def self.grant!(subject, verb, direct_object)
    if query(subject, verb, direct_object).count == 0
      EssenceOfAuthorization::Authorization.create!(:subject=>subject, :verb=>verb, :direct_object=>direct_object)
    end
  end

  def self.who_can?(verb, direct_object)
    where(:verb            => verb,
          :direct_object_id=> direct_object.id, :direct_object_type=> direct_object.class.name).map(&:subject)
  end

  def self.query(subject, verb, direct_object)
    where(:subject_id      => subject.id, :subject_type=> subject.class.name,
          :verb            => verb,
          :direct_object_id=> direct_object.id, :direct_object_type=> direct_object.class.name)
  end
end
