class Rotation < ActiveRecord::Base

  belongs_to :user
  has_and_belongs_to_many :artists

  def self.create_from_rdio_artists(rdio_artists)
    new_rotation = Rotation.create

    rdio_artists.each do |rr|
      current_artist = Artist.find_or_create_from_rdio(rr)
      new_rotation.artists << current_artist
    end

    new_rotation
  end

  def previous
    user.rotations.where('id < ?', id).first
  end

end