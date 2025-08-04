# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

puts "Seeding Started!"

firstUser = User.find_or_create_by(first_name: "Bishwo", last_name: "Dahal", username: "bishwodahal", email: "someemail@gmail.com", password: "abcd")
secondUser = User.find_or_create_by(first_name: "John", last_name: "doe", username: "doejohn", email: "johndoe@gmail.com", password: "strong")


# For Machines:
default_machines = [
{  name: "Frontier 2nd sample", storage: 9999999, cores:64, cpus:1, nodes:9402, gpus: 8, user_id:firstUser.id},
{  name: "Odo Sample", storage: 9999999, cores:64, cpus:1, nodes:32, gpus: 8,  user_id:firstUser.id},
{  name: "Andes Sample", storage: 9999999, cores:32, cpus:1, nodes:504, gpus: 8, user_id:secondUser.id},
{  name: "Summit Sample", storage: 9999999, cores:32, cpus:3, nodes:5000, gpus: 8, user_id:firstUser.id},
{  name: "Defiant Sample", storage: 9999999, cores:16, cpus:1, nodes:64, gpus: 8, user_id:firstUser.id}
]
machines = []
puts "\nCreating Machines!"
default_machines.each do |machine|
  currMachine = Machine.find_or_create_by(machine)
  machines.push(currMachine)
  puts "Machine Name: #{machines[machines.length()-1].name}"
end
puts "Completed Creating #{machines.length()} Machines!"

# :name, :storage, :cores, :cpus, :nodes, :gpus, :modules_list

# For Projects:
projects_name = [
  {name: "GEN007RATS"},
  {name: "TRN023"},
  {name: "GEN243"},
  {name: "GEN007"}
]
projects = []


puts "\nCreating Projects! "
projects_name.each do |project|
  currProject = Project.find_or_create_by(project)
  projects.push(currProject)
  puts "Project id: #{currProject.id.to_i} name: #{currProject.name}"
end
puts "Completed creating #{projects.length()} projects! "


puts "\nCreating Jobs! "

jobs = []

machines.each do |machine|
  projects.each do |project|
    currJob = Job.find_or_create_by(name:"Sample Job",project_id: project.id, nodes:2, walltime:56000, cores: 3, script: "Some genuine script", machine_id:machine.id, user_id: firstUser.id )
    jobs.push(currJob)
  end
end


puts "Completed creating #{jobs.length()} jobs!"

# Missions, Chapters, Quizzes
puts "\nCreating Quizzes, Chapters, and Missions! "
require_relative 'missions_chapters_quizzes'


puts "\nSeeding Completed!"