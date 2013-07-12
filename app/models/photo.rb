class Photo < ActiveRecord::Base
  attr_accessible :desc, :tag, :uuid
  belongs_to :user
  attr_accessible :user
  acts_as_taggable
end
