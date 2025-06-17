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

puts "\nCreating Quizzes, Chapters, and Missions! "

# Create Missions
understandBasicsHPCMission = "Understand the Basics of HPC"

Mission.find_or_create_by(title: understandBasicsHPCMission, is_completed: false, content: "Description of the mission", difficulty_level: 1)

# Create Chapters
firstMissionId = Mission.find_by(title: understandBasicsHPCMission).id
basicsHPCChapters = [
  {title: "Introduction to HPC", mission_id: firstMissionId, content: "Introduction to HPC"},
  {title: "Understand basic architecture of machine", mission_id: firstMissionId, content: "Understand basic architecture of machine"},
  {title: "Login to two different machines", mission_id: firstMissionId, content: "Login to two different machines"},
  {title: "Create a new job", mission_id: firstMissionId, content: "Create a new job"},
  {title: "Run a job from both GUI and CLI", mission_id: firstMissionId, content: "Run a job from both GUI and CLI"},
  {title: "Create jobs for different scenarios", mission_id: firstMissionId, content: "Create jobs for different scenarios"},
  {title: "Loading modules", mission_id: firstMissionId, content: "Loading modules"},
]
basicsHPCChapters.each do |chapter|
  Chapter.find_or_create_by(chapter)
end

intro_chapter = Chapter.find_by(title: "Introduction to HPC")
Quiz.create!([
  {
    chapter: intro_chapter,
    question: "What does HPC stand for?",
    question_type: "mcq",
    options: ["High Processing Capability", "High-Performance Computing", "Hybrid Parallel Cluster", "Hyper Precision Control"],
    correct_option_index: 1,
    explanation: "HPC stands for High-Performance Computing, used to solve complex problems with powerful computing systems."
  },
  {
    chapter: intro_chapter,
    question: "Which of the following is a common goal of HPC?",
    question_type: "mcq",
    options: ["Reducing monitor latency", "Maximizing FPS in games", "Solving large-scale computational problems", "Running social media apps faster"],
    correct_option_index: 2,
    explanation: "HPC is used to solve large-scale scientific, engineering, or data-intensive problems efficiently."
  },
  {
    chapter: intro_chapter,
    question: "Which area commonly uses HPC?",
    question_type: "mcq",
    options: ["Mobile App Development", "Genomic Sequencing", "UI Design", "Spreadsheet Formatting"],
    correct_option_index: 1,
    explanation: "Genomic sequencing, climate modeling, and simulations are major HPC use cases."
  },
  {
    chapter: intro_chapter,
    question: "Which of these best describes a supercomputer?",
    question_type: "mcq",
    options: ["A regular desktop with extra RAM", "A smartphone with AI features", "A high-speed computer system used for intensive tasks", "A web server running multiple sites"],
    correct_option_index: 2,
    explanation: "A supercomputer is designed to perform complex calculations at high speed, often used in HPC contexts."
  },
  {
    chapter: intro_chapter,
    question: "What kind of computing does HPC focus on?",
    question_type: "mcq",
    options: ["Serial computing", "Single-core processing", "Massively parallel processing", "Blockchain processing"],
    correct_option_index: 2,
    explanation: "HPC typically leverages massively parallel processing to achieve high performance."
  }
])



puts "\nSeeding Completed!"