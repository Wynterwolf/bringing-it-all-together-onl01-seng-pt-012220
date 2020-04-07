class Dog

attr_accessor :id, :name, :breed 

#initialize method 
def initialize (id=null, name, breed)
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