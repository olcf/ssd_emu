# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

puts "Seeding Started!"

firstUser = User.find_or_create_by(first_name: "First", last_name: "Last", username: "default_username", email: "someemail@gmail.com", password: "abcd")


# For Machines:
default_machines = [
{  name: "frontier", storage: 9999999, cores:64, cpus:1, nodes:9856, gpus: 8, user_id:firstUser.id},
{  name: "odo", storage: 9999999, cores:64, cpus:1, nodes:32, gpus: 8,  user_id:firstUser.id},
{  name: "andes", storage: 9999999, cores:16, cpus:1, nodes:704, gpus: 8, user_id:firstUser.id},
{  name: "summit", storage: 9999999, cores:32, cpus:1, nodes:4608, gpus: 6, user_id:firstUser.id},
{  name: "defiant", storage: 9999999, cores:16, cpus:1, nodes:64, gpus: 8, user_id:firstUser.id}
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

sample_scripts = [
  {
    suffix: "hello",
    script: <<~'BASH',
      #!/usr/bin/env bash
      #SBATCH -J hello_world
      #SBATCH -o slurm-%j.out
      #SBATCH -e slurm-%j.err
      #SBATCH -t 00:01:00
      #SBATCH -N 1
      #SBATCH --ntasks=1

      set -euo pipefail

      echo "Hello from $(hostname) at $(date)"
      echo "SLURM_JOB_ID=${SLURM_JOB_ID:-}"
      echo "SLURM_JOB_NODELIST=${SLURM_JOB_NODELIST:-}"
    BASH
  },
  {
    suffix: "mpi",
    script: <<~'BASH',
      #!/usr/bin/env bash
      #SBATCH -J mpi_example
      #SBATCH -o slurm-%j.out
      #SBATCH -e slurm-%j.err
      #SBATCH -t 00:05:00
      #SBATCH -N 2
      #SBATCH --ntasks-per-node=4

      set -euo pipefail

      echo "MPI example (will run even without an MPI binary)."
      echo "Nodes: ${SLURM_JOB_NODELIST:-}"
      echo "Tasks: ${SLURM_NTASKS:-}"

      if command -v srun >/dev/null 2>&1; then
        srun -n "${SLURM_NTASKS:-8}" bash -lc 'echo "rank-ish: ${SLURM_PROCID:-0} on $(hostname)"'
      else
        echo "srun not available in this environment."
      fi
    BASH
  },
  {
    suffix: "array",
    script: <<~'BASH',
      #!/usr/bin/env bash
      #SBATCH -J array_demo
      #SBATCH -o slurm-%A_%a.out
      #SBATCH -e slurm-%A_%a.err
      #SBATCH -t 00:02:00
      #SBATCH -N 1
      #SBATCH --ntasks=1
      #SBATCH --array=1-5

      set -euo pipefail

      i="${SLURM_ARRAY_TASK_ID:-0}"
      echo "Array task ${i} running on $(hostname) at $(date)"
      sleep 1
      echo "Array task ${i} done"
    BASH
  },
  {
    suffix: "io",
    script: <<~'BASH',
      #!/usr/bin/env bash
      #SBATCH -J io_demo
      #SBATCH -o slurm-%j.out
      #SBATCH -e slurm-%j.err
      #SBATCH -t 00:02:00
      #SBATCH -N 1
      #SBATCH --ntasks=1

      set -euo pipefail

      workdir="${SLURM_SUBMIT_DIR:-$PWD}"
      outdir="${workdir}/sample-job-output"
      mkdir -p "${outdir}"

      echo "Writing a small output artifact to: ${outdir}"
      dd if=/dev/zero of="${outdir}/data.bin" bs=1M count=4 status=none
      sha256sum "${outdir}/data.bin" | tee "${outdir}/data.sha256"
      ls -lh "${outdir}"
    BASH
  },
]

machines.each do |machine|
  projects.each do |project|
    sample_scripts.each do |s|
      currJob = Job.find_or_create_by(
        name: "sample_#{s[:suffix]}",
        project_id: project.id,
        nodes: 2,
        walltime: 56000,
        cores: 3,
        script: s[:script],
        machine_id: machine.id,
        user_id: firstUser.id,
      )
      jobs.push(currJob)
    end
  end
end


puts "Completed creating #{jobs.length()} jobs!"

# Missions, Chapters, Quizzes
puts "\nCreating Quizzes, Chapters, and Missions! "
require_relative 'seeds/missions_chapters_quizzes'


puts "\nSeeding Completed!"