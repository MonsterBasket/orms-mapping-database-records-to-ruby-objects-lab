class Student
  attr_accessor :id, :name, :grade

  def initialize(name = nil, grade = nil, id = nil)
    @name = name
    @grade = grade
    @id = id
  end

  def self.new_from_db(row)
    self.new row[1], row[2], row[0]
  end

  def self.all
    custom_search "SELECT * FROM students"
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
  end

  def self.all_students_in_grade_9
    custom_search "SELECT * FROM students WHERE grade = 9"
  end

  def self.students_below_12th_grade
    custom_search "SELECT * FROM students WHERE grade < 12"
  end

  def self.first_X_students_in_grade_10(x)
    custom_search "SELECT * FROM students WHERE grade = 10 LIMIT #{x}" # allows for SQL injection, but mehhhhhhhhhh...
  end

  def self.first_student_in_grade_10
    first_X_students_in_grade_10(1)[0] # this is getting really fucking stupid...
  end

  def self.all_students_in_grade_X(x)
    custom_search "SELECT * FROM students WHERE grade = #{x}"
  end

  def self.find_by_name(name)
    sql = "SELECT * FROM students WHERE name = ?"
    new_from_db DB[:conn].execute(sql, name)[0]
    # details = DB[:conn].execute(sql, name)
    # self.new details[0][1], details[0][2], details[0][0]
    # find the student in the database given a name
    # return a new instance of the Student class
  end

  def self.custom_search(sql)
    DB[:conn].execute(sql).map {|row| self.new_from_db row}
  end
  private_class_method :custom_search
  
  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end
  
  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
end
