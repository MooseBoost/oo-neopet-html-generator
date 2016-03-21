class User
  attr_reader :name, :items, :neopets
  attr_accessor :neopoints

  PET_NAMES = ["Angel", "Baby", "Bailey", "Bandit", "Bella", "Buddy", "Charlie", 
  "Chloe", "Coco", "Daisy", "Lily", "Lucy", "Maggie", "Max", "Molly", "Oliver", 
  "Rocky", "Shadow", "Sophie", "Sunny", "Tiger"]

  def initialize(name)
    @name = name
    @neopoints = 2500
    @items = []
    @neopets = []
  end

  def select_pet_name
    neonames = neopets.map { |n| n.name }
    PET_NAMES.find { |name| !neonames.include? name }
  end
  
  def make_file_name_for_index_page
    name.split(' ').join('-').downcase
  end
  
  def buy_item
    if neopoints >= 150
      self.neopoints -= 150
      item = Item.new
      items << item
      "You have purchased a #{item.type}."
    else
      "Sorry, you do not have enough Neopoints."
    end
  end
 
  def find_item_by_type(type)
    items.find { |item| item.type == type }
  end
  
  def buy_neopet
    if neopoints >= 250
      self.neopoints -= 250
      neopet = Neopet.new(select_pet_name)
      neopets << neopet
      "You have purchased a #{neopet.species} named #{neopet.name}."
    else
      "Sorry, you do not have enough Neopoints."
    end
  end
  
  def find_neopet_by_name(name)
    neopets.find { |neopet| neopet.name == name }
  end
  
  def sell_neopet_by_name(name)
    unless find_neopet_by_name(name).nil?
      neopets.reject! { |neopet| neopet.name == name }
      self.neopoints += 200
      "You have sold #{name}. You now have #{neopoints} neopoints."
    else
      "Sorry, there are no pets named #{name}."
    end
  end
  
  def feed_neopet_by_name(name)
    neopet = find_neopet_by_name(name)
    happy = neopet.happiness
    
    if happy == 10
      "Sorry, feeding was unsuccessful as #{neopet.name} is already ecstatic."
    else
      happy == 9 ? neopet.happiness += 1 : neopet.happiness += 2
      "After feeding, #{neopet.name} is #{neopet.mood}."
    end
  end
  
  def give_present(type, neo_name)
    gift = find_item_by_type(type)
    neopet = find_neopet_by_name(neo_name)
    unless gift.nil? || neopet.nil?
      items.reject! { |item| item == gift }
      neopet.items << gift
      neopet.happiness += 5
      neopet.happiness = 10 if neopet.happiness > 10
      "You have given a #{gift.type} to #{neopet.name}, "\
      "who is now #{neopet.mood}."
    else
      "Sorry, an error occurred. "\
      "Please double check the item type and neopet name."
    end
  end
  
  def make_index_page
    filename = make_file_name_for_index_page
    fileHtml = File.new("./views/users/#{filename}.html", "w+")
    fileHtml.puts "<!DOCTYPE html>"
    fileHtml.puts "<html>"
    fileHtml.puts "  <head>"
    fileHtml.puts %[    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css">]
    fileHtml.puts %[    <link rel="stylesheet" href="http://getbootstrap.com/examples/jumbotron-narrow/jumbotron-narrow.css">]
    fileHtml.puts "    <title>#{name}</title>"
    fileHtml.puts "  </head>"
    fileHtml.puts "  <body>"
    fileHtml.puts %[    <div class="container">]
    fileHtml.puts ""
    fileHtml.puts "      <!-- begin jumbotron -->"
    fileHtml.puts %[      <div class="jumbotron">]
    fileHtml.puts "        <h1>#{name}</h1>"
    fileHtml.puts "        <h3><strong>Neopoints:</strong> #{neopoints}</h3>"
    fileHtml.puts "      </div>"
    fileHtml.puts "      <!-- end jumbotron -->"
    fileHtml.puts ""
    fileHtml.puts %[      <div class="row marketing">]
    fileHtml.puts ""
    fileHtml.puts "        <!-- begin listing neopets -->"
    fileHtml.puts %[        <div class="col-lg-6">]
    fileHtml.puts "          <h3>Neopets</h3>"
    
    fileHtml.puts "          <!-- neopet begin -->"     
    self.neopets.each do |neopet|
      fileHtml.puts "          <ul>"
      fileHtml.puts %[            <li><img src="../../public/img/neopets/#{neopet.species}.jpg"></li>]
      fileHtml.puts "            <ul>"
      fileHtml.puts "              <li><strong>Name:</strong> #{neopet.name}</li>"
      fileHtml.puts "              <li><strong>Mood:</strong> #{neopet.mood}</li>"
      fileHtml.puts "              <li><strong>Species:</strong> #{neopet.species}</li>"
      fileHtml.puts "              <li><strong>Strength:</strong> #{neopet.strength}</li>"
      fileHtml.puts "              <li><strong>Defence:</strong> #{neopet.defence}</li>"
      fileHtml.puts "              <li><strong>Movement:</strong> #{neopet.movement}</li>"
      fileHtml.puts "              <li><strong>Items:</strong></li>"
      fileHtml.puts "              <ul>"
      
      fileHtml.puts "                <!-- begin neopet's items -->"
      neopet.items.each do |item|
        fileHtml.puts %[                <li><img src="../../public/img/items/#{item.type}.jpg"></li>]
        fileHtml.puts "                <ul>"
        fileHtml.puts "                  <li><strong>Type:</strong> #{item.format_type}</li>"
        fileHtml.puts "                </ul>"        
      end
  
      fileHtml.puts "              </ul>"
      fileHtml.puts "            </ul>"
    end

    fileHtml.puts "          </ul>"
    fileHtml.puts "        </div>"
    fileHtml.puts "        <!-- end listing neopets -->"
    fileHtml.puts ""

    fileHtml.puts %[        <div class="col-lg-6">]
    fileHtml.puts "          <h3>Items</h3>"
    fileHtml.puts "          <ul>"    
    fileHtml.puts "        <!-- begin listing items -->"
    items.each do |item|
      fileHtml.puts %[            <li><img src="../../public/img/items/#{item.type}.jpg"></li>]
      fileHtml.puts "            <ul>"
      fileHtml.puts "              <li><strong>Type:</strong> #{item.format_type}</li>"
      fileHtml.puts "            </ul>"      
    end

    # fileHtml.puts %[            <li><img src="../../public/img/items/bluemirror.jpg"></li>]
    # fileHtml.puts "            <ul>"
    # fileHtml.puts "              <li><strong>Type:</strong> Bluemirror</li>"
    # fileHtml.puts "            </ul>"
    # fileHtml.puts %[            <li><img src="../../public/img/items/red_bouncy_ball.jpg"></li>]
    # fileHtml.puts "            <ul>"
    # fileHtml.puts "              <li><strong>Type:</strong> Red Bouncy Ball</li>"
    # fileHtml.puts "            </ul>"
    fileHtml.puts "          </ul>"
    fileHtml.puts "        </div>"
    fileHtml.puts "        <!-- end listing items -->"
    fileHtml.puts ""
    fileHtml.puts "      </div><!-- end row marketing -->"
    fileHtml.puts "    </div><!-- end container -->"
    fileHtml.puts "  </body>"
    fileHtml.puts "</html>"
    fileHtml.close()
  end
end