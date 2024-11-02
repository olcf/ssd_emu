# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)


User.create(first_name: "Bishwo", last_name: "Dahal", username: "bishwodahal", email: "someemail@gmail.com", password: "abcd")
User.create(first_name: "John", last_name: "doe", username: "doejohn", email: "johndoe@gmail.com", password: "strong")



# For Machines:
Machine.create(name:"Frontier Sample", storage:9999999, cores:64, cpus: 1, nodes:9402, gpus: 8, modules_list:{}, user_id:1 )
# :name, :storage, :cores, :cpus, :nodes, :gpus, :modules_list


# For specific Job
Job.create(project_name:"GEN007RATS", nodes:2, walltime:500,cores:1,script:'Run C++ Codes',machine_id: 1, user_id: 1, state:'NA')
Job.create(project_name:"TRN025", nodes:8, walltime:7,cores:10,script:'long list of commands',machine_id: 1, user_id: 1, state:'CA', job_reason_code:'NonZeroExitCode')
# :project_name, :nodes, :walltime, :cores, :mail_type, :mail_user, :state, :job_reason_code, :script, :out, :err, :machine_id, :user_id