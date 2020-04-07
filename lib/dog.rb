class Dog

attr_accessor :name, :breed
attr_reader :id 

#initialize method 
def initialize (id=nil, name, breed)
  @id = id
  @name = name
  @breed = breed
end

#create table 
def self.create_table #class method
  sql = <<-SQL
    CREATE TABLE IF NOT EXISTS dogs(
    id INTEGER PRIMARY KEY,
    name TEXT,
    breed TEXT
    )
    SQL
    
    DB[:conn].execute(sql)
  end
  
  
end