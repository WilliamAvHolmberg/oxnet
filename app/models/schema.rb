class Schema < ApplicationRecord
  has_many :tasks, dependent: :destroy
  has_many :accounts

  def get_suitable_task
    puts "lets get a good task"
    puts self.tasks
    self.tasks.all.each do |task|
      time = Time.now.change(:month => 1, :day => 1, :year => 2000)
      puts time
      puts task.get_start_time
      puts task.get_end_time
      if time > task.get_start_time && time < task.get_end_time
        puts "found good task"
        return task
      end
      puts "no good task"
      return nil
    end
    puts "noope"
  end
end
