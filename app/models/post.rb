class Post < ActiveRecord::Base
    belongs_to :rsvinfo
    has_many :comments
end
