class User < ActiveRecord::Base
  has_one :webhook
end