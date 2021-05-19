require "active_record"

class Todo < ActiveRecord::Base
  # returns -1 (or) 0 (or) 1 when overdue (or) due_today (or) due_later
  def todo_due?
    due_date <=> Date.today
  end

  #the functions  returns the array of todos according to the check_todo
  def self.todo_due(check_todo)
    all.order(:due_date, :id).filter { |todo| todo.todo_due? == check_todo }
  end

  # retuns the string what pattern user wants
  def to_displayable_string
    display_status = completed ? "[X]" : "[ ]"
    display_date = todo_due? == 0 ? nil : due_date
    "#{id} . #{display_status} #{todo_text} #{display_date}"
  end

  # display the todolist
  def self.to_displayable_list(todo_list)
    todo_list.map { |todo| todo.to_displayable_string }
  end

  # To add the task
  def self.add_task(new_todo)
    Todo.create!(todo_text: new_todo[:todo_text], due_date: Date.today + new_todo[:due_in_days], completed: false)
  end

  # the function helps  to set the completed status of todo true
  def self.mark_as_complete!(todo_id)
    todo = find_by_id(todo_id)
    # when the id is invalid
    if (todo.nil?)
      puts "Sorry,id was not found"
      exit
    end
    # It only change when todo[:completed] is false we dont want to change todo[:completed] is already true
    if (!todo[:completed])
      todo[:completed] = true
      todo.save
    end
    todo
  end

  # Display the Total todo
  def self.show_list
    puts "My Todo-list\n\n"

    puts "Overdue\n"
    puts to_displayable_list Todo.todo_due -1
    puts "\n\n"

    puts "Due Today\n"
    puts to_displayable_list Todo.todo_due 0
    puts "\n\n"

    puts "Due Later\n"
    puts to_displayable_list Todo.todo_due 1
    puts "\n\n"
  end
end
