class Dog

#read/write attributes
attr_accessor :name, :breed, :id

#initialize method
def initialize(attributes)
    #id: nil, :name, breed:
    attributes.each{|key,value| self.send(("#{key}="), value)}
    self.id ||=nil
end

#create table
def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS dogs(
        id INTEGER PRIMARY KEY,
        name TEXT,
        breed TEXT
    )
    SQL
    DB[:conn].execute(sql)
end

#drop table
def self.drop_table
    sql =<<-SQL
    DROP TABLE IF EXISTS dogs
    SQL
    DB[:conn].execute(sql)
end

#save
def save
    sql = <<-SQL
    INSERT INTO dogs(name, breed) VALUES (?,?)
    SQL
    DB[:conn].execute(sql, self.name, self.breed)
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][0]

    self
end

#create
def self.create(hash_of_attributes)
    dog = Dog.new(hash_of_attributes)
    dog.save
    dog
end

#new_from_DB
def self.new_from_db(row)
    attributes_hash = {
    :id => row[0],
    :name => row[1],
    :breed => row[2]
    }
    dog = self.new(attributes_hash)
end

#find_by_ID
def self.find_by_id(id)
    sql = <<-SQL
    SELECT * FROM dogs WHERE id = ?
    SQL
    DB[:conn].execute(sql, id).map do |row|
        self.new_from_db(row)
    end.first
end


#find or create by
def self.find_or_create_by(name:, breed:)
    sql = <<-SQL
    SELECT * FROM dogs
    WHERE name = ? AND breed = ?
    SQL

    dog = DB[:conn].execute(sql, name,breed).first

    if dog
        new_dog = self.new_from_db(dog)
    else
        new_dog = self.create({:name =>name, :breed => breed})
end
new_dog
end

#find by name
def self.find_by_name(name)
    sql = <<-SQL
    SELECT *
    FROM dogs
    WHERE name = ?
    LIMIT 1
    SQL

    DB[:conn].execute(sql,name).map do |row|
        self.new_from_db(row)
    end.first
end

#update
def update
    sql = <<-SQL
    UPDATE dogs SET name = ?, breed = ? WHERE id = ?
    SQL
    DB[:conn].execute(sql, self.name, self.breed, self.id)
end
end