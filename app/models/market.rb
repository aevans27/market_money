class Market < ApplicationRecord
  has_many :market_vendors
  has_many :vendors, through: :market_vendors
  

  validates_presence_of :name
  validates_presence_of :street
  validates_presence_of :city
  validates_presence_of :county
  validates_presence_of :state
  validates_presence_of :zip
  validates_presence_of :lat
  validates_presence_of :lon
  # validates_presence_of :vendor_count

  def vendor_count
    if self.vendors != nil
      self.vendors.count
    else
      0
    end
  end

  def self.find_by_name(name)
    self.where("name ILIKE ?", "%#{name}%")
    #self.where(name: name)
  end

  def self.find_by_state(state)
    self.where("state ILIKE ?", "%#{state}%")
  end

  def self.find_by_state_and_name(state, name)
    self.where("state ILIKE ? AND name ILIKE ?", "%#{state}%", "%#{name}%")
  end

  def self.find_by_state_and_city(state, city)
    self.where("state ILIKE ? AND city ILIKE ?", "%#{state}%", "%#{city}%")
  end

  def self.find_by_3(state, name, city)
    self.where("state ILIKE ? AND name ILIKE ? AND city ILIKE ?", "%#{state}%", "%#{name}%", "%#{city}%")
  end
end