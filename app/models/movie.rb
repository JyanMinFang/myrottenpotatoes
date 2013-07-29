class Movie < ActiveRecord::Base
  def self.allratings()
   select(:rating).order(:rating.to_s).map(&:rating).uniq
  end
end
