require 'pry'
class Neopet
  attr_reader :name, :points, :species, :strength, :defence, :movement
  attr_accessor :happiness, :items

  def initialize(name="Jason")
    @name = name
    @strength = get_points
    @defence = get_points
    @movement = get_points
    @happiness = get_points
    @species = get_species
    @items = []
  end
  
  def get_points
  end
  
  def get_species
    neopets = Dir.entries('./public/img/neopets').reject do |f|
      File.directory?(f)
    end

    neopets.sample.chomp('.jpg')    
  end
  
  def get_points
    rand(1..10)
  end

  def mood
    moods = [nil, "depressed", "sad", "meh", "happy", "ecstatic"]
    moods[(happiness + 1) / 2]
  end

end