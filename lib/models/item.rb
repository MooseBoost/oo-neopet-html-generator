require 'pry'

class Item
 attr_reader :type

  def initialize
    @type = get_type
  end
  
  def get_type
    types = Dir.entries('./public/img/items').reject do |f|
      File.directory?(f)
    end
    
    types.sample.chomp('.jpg')
  end
  
  def format_type
    type.split('_').map { |i| i.capitalize }.join(' ')
  end
end