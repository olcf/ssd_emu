# command -v will return 0 if "docker" is available else returns 1
if ! command -v docker &> /dev/null; then 
    echo "Docker is not installed in your setup! Please install docker following instructions at https://docs.docker.com/desktop/"
    exit;
fi

# Add colors using FG and BG here! Docs at: https://tldp.org/HOWTO/Bash-Prompt-HOWTO/x329.html
# \033[0m will reset to no color;
blue_text(){
    printf "\033[1;34m$1\033[0m"
}
green_text(){
    printf "\033[1;32m$1\033[0m"
}
red_text(){
    printf "\033[1;31m$1\033[0m"
}

blue_text "
    ████                                      █▓▒▒▓█ 
     █                                       ░░█                 ░░█       
  ░░░░░░░░ ░░▓░░░██░░░█  ░░░  █░░█           ▒░░████  ▓░░███░░ ██░░██ ░░█  █░░  ░░███░░█     
 █░░       ░░░░░░░░░░░░░ ░░░  █░░█                █░░ ▓░░  ░░█   ░░█  ░░█  █░░  ░░░  ░░█
 █░░░░░░░▓ ░░░  ░░░  ░░░ ░░░  █░░█           ░░█  █░░ ▓░░        ░░█  ░░█  █░░  ░░░  ░░█  
 █░ █      ░░░  ░░░  ░░░ ░░░  ▒░░█            █░░░░█   ▓▓░░░█▓   ░█░░  █░░░█░░  ░░▓░░▒█
  ▓░░░░░░░ ░░░  ░░░  ░░░  ░░░░░░█                                               ░░░   

  "
# Generated using https://www.asciiart.eu/image-to-ascii with ASCII Gradient (Code Page 437) at 52 Characters
echo "$(blue_text EMU) is a software that emulates the supercomputer environment at Oak Ridge National Laboratory(ORNL), allowing beginners to familiarize with supercomputers and the job submission process."
printf "Find the source code at $(blue_text http://www.github.com/olcf/ssd_emu) \n\n\n"

os=$(uname)

if [[ "$os" == "Darwin" ]]; then
    echo "Supported in MAC system\n Follow next steps for installation"
elif [[ "$os" == "Linux" ]]; then
    echo "Supported in Linux System\n Follow next steps for installation"
else
    echo "Not supported in $os as of now. Please create a pull request or issue in the official repository!"
fi


# Options for Environment
OPTIONS=("$(green_text Production)" "$(blue_text 'Development inside Docker(recommended)')" "$(red_text 'Development without Docker(not recommended)' )")

cluster_setup() {
    echo "Building Clusters: "
    cd ./slurm-docker-cluster && docker compose up -d
    cd ../
}

# Set the prompt for the select menu with PS3 variable
PS3="$(blue_text '\nPlease select your environment: ')"

# Use the select command to display the menu and get user input
select choice in "${OPTIONS[@]}"; do
    case $REPLY in
        "1")
            cluster_setup
            docker compose -f compose.yaml  build && docker compose -f compose.yaml up -d
            break
            ;;
        "2")
            cluster_setup
            docker compose -f compose.dev.yaml  build && docker compose -f compose.dev.yaml up
            break
            ;;
        "3")
            echo "Please install all dependencies following README.md file for manual setup!"
            break
            ;;
        *)
            echo "$(red_text 'Invalid option. Please enter again.')"
            ;;
    esac
done