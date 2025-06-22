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

# Understand basic architecture of machines:
understandBasicArchitectureOfMachines = <<~CONTENT
    High-Performance Computing (HPC) systems rely on sophisticated architectures to perform complex simulations and data analysis efficiently. This chapter introduces three important machines at the Oak Ridge Leadership Computing Facility (OLCF): **Odo**, **Frontier**, and **Andes**.

    ### 🖥️ Odo
    Odo is a 32-node training system designed to provide hands-on HPC experience through OLCF training events. Although it shares the same architecture as Frontier, Odo is not intended as a production resource and is located in the NCCS Open Security Enclave, which allows for streamlined access during training.

    **Key features of Odo nodes:**
    - 32 nodes total (2 login nodes, 30 compute nodes)
    - Each compute node has:
      - 1× 64-core AMD “Optimized 3rd Gen EPYC” CPU (with 2 hardware threads per core)
      - 4× AMD MI250X GPUs (each MI250X with 2 Graphics Compute Dies, totaling 8 GPUs per node)
      - 512 GB DDR4 memory
    - File systems differ from Frontier due to enclave separation:
      - NFS personal home directories: `/ccsopen/home/[userid]`
      - NFS project directories: `/ccsopen/proj/[projid]`
      - GPFS parallel file system (wolf2) with directories for project-shared, scratch, and world-shared data
    - Primarily used for training, so access is granted through OLCF events only

    For detailed hardware architecture, the Frontier User Guide applies well to Odo compute nodes.

    ### ⚡ Frontier – The Exascale Supercomputer
    Frontier is the world’s first exascale supercomputer, a HPE Cray EX system delivering a peak of approximately 2 exaflops. It powers cutting-edge science with a hybrid CPU-GPU architecture.

    **Key specs:**
    - 9,856 compute nodes, each with:
      - 1× 64-core AMD Optimized 3rd Gen EPYC CPU
      - 4× AMD MI250X GPUs (8 GPUs total per node)
      - 512 GB DDR4 RAM
    - Advanced Infinity Fabric connections enabling high bandwidth CPU-GPU and GPU-GPU communication
    - Slingshot interconnect providing up to 800 Gbps per node for fast node-to-node communication
    - File systems:
      - Orion Lustre parallel filesystem (679 PB usable)
      - On-node NVMe burst buffer SSDs (2× 1.92 TB per node)
    - Cray OS 2.4 based on SUSE Linux Enterprise Server 15.4
    - Login nodes for job management; compute nodes run parallel jobs

    More details: [Frontier User Guide](https://docs.olcf.ornl.gov/systems/frontier_user_guide.html)

    ### 🧮 Andes – Pre/Post-Processing Cluster
    Andes supports pre- and post-processing tasks and complements Frontier by offering:
    - AMD EPYC processors
    - Large memory nodes
    - Access to Orion filesystem
    - Ideal for data analysis and preparation workflows

    ### Summary
    These systems serve distinct roles in the HPC ecosystem:
    - **Odo:** Training and development with Frontier-like architecture
    - **Frontier:** Production exascale computing with hybrid CPU-GPU nodes
    - **Andes:** Data preparation and analysis with large memory nodes

    Understanding their architecture helps users select the best resource for their computational needs.
  CONTENT

basicsHPCChapters = [
  {title: "Introduction to HPC", mission_id: firstMissionId, content: "Introduction to HPC"},
  {title: "Understand basic architecture of machines", mission_id: firstMissionId, content: understandBasicArchitectureOfMachines, short_description:"Here you will understand the architecture of 3 systems: Frontier, Andes, and Odo"},
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


basic_architecture_chapter = Chapter.find_by(title: "Understand basic architecture of machines")
Quiz.create!([
  {
    chapter: basic_architecture_chapter,
    question: "Which system is designed specifically for HPC training at OLCF?",
    question_type: "mcq",
    options: ["Frontier", "Odo", "Andes", "Summit"],
    correct_option_index: 1,
    explanation: "Odo is a training system with the same architecture as Frontier but used only during OLCF training events."
  },
  {
    chapter: basic_architecture_chapter,
    question: "How many compute nodes does Frontier have approximately?",
    question_type: "mcq",
    options: ["32", "128", "9,856", "20,000"],
    correct_option_index: 2,
    explanation: "Frontier has about 9,856 compute nodes, making it one of the largest supercomputers in the world."
  },
  {
    chapter: basic_architecture_chapter,
    question: "What is the key architectural difference between Odo and Frontier?",
    question_type: "mcq",
    options: [
      "Odo uses AMD CPUs, Frontier uses Intel CPUs",
      "Odo has fewer nodes and is in a different security enclave",
      "Odo uses GPUs, Frontier does not",
      "Odo has more memory per node"
    ],
    correct_option_index: 1,
    explanation: "Odo has fewer compute nodes and is located in the NCCS Open Security Enclave, while Frontier is in the Moderate Security Enclave."
  },
  {
    chapter: basic_architecture_chapter,
    question: "How many GPUs are available per compute node on Frontier?",
    question_type: "mcq",
    options: ["4", "8", "16", "32"],
    correct_option_index: 1,
    explanation: "Each Frontier compute node contains 4 AMD MI250X GPUs, each with 2 GPU dies, totaling 8 GPUs."
  },
  {
    chapter: basic_architecture_chapter,
    question: "Which filesystem does Frontier primarily use for high-performance data storage?",
    question_type: "mcq",
    options: ["NFS", "Orion Lustre", "GPFS Wolf2", "Kronos Archival Storage"],
    correct_option_index: 1,
    explanation: "Frontier uses the Orion Lustre parallel filesystem for primary high-performance storage."
  },
  {
    chapter: basic_architecture_chapter,
    question: "What type of processors are used in Frontier and Odo compute nodes?",
    question_type: "mcq",
    options: ["Intel Xeon", "AMD EPYC 3rd Gen", "ARM Cortex", "IBM Power9"],
    correct_option_index: 1,
    explanation: "Both Frontier and Odo use the 3rd Generation AMD EPYC processors."
  },
  {
    chapter: basic_architecture_chapter,
    question: "What is the role of Andes in the OLCF HPC ecosystem?",
    question_type: "mcq",
    options: [
      "Running large-scale simulations",
      "Pre- and post-processing of data",
      "Training users on HPC",
      "Providing login access to Frontier"
    ],
    correct_option_index: 1,
    explanation: "Andes is primarily used for pre- and post-processing tasks, offering large memory nodes."
  },
  {
    chapter: basic_architecture_chapter,
    question: "Which interconnect technology does Frontier use to connect compute nodes?",
    question_type: "mcq",
    options: ["Infiniband", "Slingshot", "Ethernet", "Omni-Path"],
    correct_option_index: 1,
    explanation: "Frontier uses the HPE Slingshot interconnect, providing 800 Gbps bandwidth per node."
  },
  {
    chapter: basic_architecture_chapter,
    question: "What kind of memory is connected to each GPU on Frontier nodes?",
    question_type: "mcq",
    options: ["DDR4", "HBM2E", "GDDR6", "LPDDR4"],
    correct_option_index: 1,
    explanation: "Each GPU in Frontier nodes has 64 GB of high-bandwidth memory (HBM2E)."
  },
  {
    chapter: basic_architecture_chapter,
    question: "Where can users find the official documentation for Frontier?",
    question_type: "mcq",
    options: [
      "https://docs.olcf.ornl.gov/systems/frontier_user_guide.html",
      "https://hpc-training.org/frontier",
      "https://amd.com/frontier-guide",
      "https://olcf.gov/training"
    ],
    correct_option_index: 0,
    explanation: "The official user guide for Frontier is hosted at https://docs.olcf.ornl.gov/systems/frontier_user_guide.html"
  }
])



puts "\nSeeding Completed!"