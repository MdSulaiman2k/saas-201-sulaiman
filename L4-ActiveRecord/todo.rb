require "active_record"

class Todo < ActiveRecord::Base
  def self.overdue
    where("due_date < ?", Date.today)
  end

  def self.due_today
    where("due_date = ?", Date.today)
  end

  def due_today?
    @due_date == Date.today
  end

  def self.due_later
    where("due_date > ?", Date.today)
  end

  # retuns the string what pattern user wants
  def to_displayable_string
    display_status = completed ? "[X]" : "[ ]"
    display_date = due_today? ? nil : due_date
    "#{id} . #{display_status} #{todo_text} #{display_date}"
  end

  # display the todolist
  def self.to_displayable_list
    all.map { |todo| todo.to_displayable_string }.join("\n")
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
    puts all.overdue.to_displayable_list
    puts "\n\n"

    puts "Due Today\n"
    puts all.due_today.to_displayable_list
    puts "\n\n"

    puts "Due Later\n"
    puts all.due_later.to_displayable_list
    puts "\n\n"
  end
end
