class Employee
  attr_reader :name, :title, :salary, :boss

  def initialize(name, title, salary, boss)
    @name = name
    @title = title
    @salary = salary
    @boss = boss
  end

  def bonus(multiplier)
    bonus = salary * multiplier
  end
end

class Manager < Employee
  attr_reader :employees
  
  def initialize(name, title, salary, boss, employees)
    super(name, title, salary, boss)
    @employees = employees
  end

  def bonus(multiplier)
    salaries = 0
    queue = employees.clone
    until queue.empty?
      employee = queue.shift
      salaries += employee.salary
      queue += employee.employees if employee.is_a?(Manager)
    end

    bonus = salaries * multiplier
  end  
end

e1 = Employee.new('worker 1', 'associate', 50000, 'mid manager')
e2 = Employee.new('worker 2', 'associate', 50000, 'mid manager')
m1 = Manager.new('mid manager', 'avp', 60000, 'big boss',[e1, e2])
e3 = Employee.new('mid employee', 'avp', 60000, 'big boss')
m2 = Manager.new('big boss', 'vp', 80000, nil, [m1,e3])

p e1.bonus(2) == 100000
p m1.bonus(2) == 200000
p m2.bonus(2) == 440000