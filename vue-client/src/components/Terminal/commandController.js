import { api } from '@/apis'
import { generateCmdList } from './styleCmdResponse'
import { useCLIStore } from '@/stores/commandLine'
import { useUserStore } from '@/stores/user'

/**
 * All commands for command line are combined in this file. Every command should have following structure:
 * {
 * command: "Command Name",
 * docs: "Explain what this feature can do",
 * execute: ()=>{return String}
 * }
 */

export const validCommands = [
  {
    name: 'info',
    docs: 'Info command is used to show information about this software!',
    execute: () => {
      return 'This application is EMU(Supercomputer emulation program)!'
    },
  },
  {
    name: 'ls',
    docs: 'ls works similar to other `ls` command on other applications<br/> ls machine: Displays list of all machines that user created',
    execute: async command => {
      let lsOutput = ''
      if (
        command._args.length === 0 ||
        command._args.includes('machine') ||
        command._args.includes('machines')
      ) {
        lsOutput += 'List of machine for your user: <br/>'
        let listOfMachines = await api.Machine.getAllMachines()
        listOfMachines = listOfMachines.map(machine => machine.name)
        lsOutput += generateCmdList(listOfMachines, { numbered: true })
      }
      return lsOutput
    },
  },
  {
    name: 'ssh',
    docs: 'SSH is a program for simulating real world ssh command. Here, it can be used to log in to specific machine. You can follow other commands after connecting to machine of your choice.',
    example:
      'ssh bishwodahal@frontier or ssh bishwodahal@"frontier sample" to log into frontier and "fronter sample" respectively',
    execute: async command => {
      if (command._args.length == 0) {
        throw new Error('ssh expects at least one argument')
      }

      // arguments will be in format username@host, hence splitting by @ and getting second element
      const splittedUserHost = command._args[0].split('@')
      const user = splittedUserHost[0]
      let host = splittedUserHost[1] //something like frontier.olcf.ornl.gov

      // if it doesn't include olcf.ornl.gov, we should show them the error
      if (!host.includes('.olcf.ornl.gov')) {
        let hostErrorMessage = `You should always add **olcf.ornl.gov** at the end of machine that you are trying to login.<br/> Example: **ssh username@frontier.olcf.ornl.gov** is Valid<br/> **ssh username@frontier** is InValid.<br/>
        <br/> You may also use login nodes name before **olcf.ornl.gov** like **ssh username@login1.odo.olcf.ornl.gov**
        Some of the list of popular machine and their login commands could be:<br/>
        `
        let listOfValidSSH = [
          'Frontier: **ssh USERNAME@frontier.olcf.ornl.gov**',
          'Ascent: **ssh USERNAME@ascent.olcf.ornl.gov**',
          'Andes: **ssh USERNAME@andes.olcf.ornl.gov**',
          'Odo: $ **ssh USERNAME@odo.olcf.ornl.gov** or **ssh USERNAME@login1.odo.olcf.ornl.gov**',
          'Crusher: **ssh USERNAME@crusher.olcf.ornl.gov**',
        ]
        hostErrorMessage += generateCmdList(listOfValidSSH, { numbered: true })
        throw new Error(hostErrorMessage)
      }
      // Here we are sure that host they are trying to connect is valid ornl host.
      // extracting just the machine name part by splitting by ornl host, ('frontier sample.olcf.ornl.gov' to ['frontier sample' '']) and taking first part
      host = host.split('.olcf.ornl.gov')[0]
      let sshOutput = ''
      let listOfMachines = await api.Machine.getAllMachines()
      let askedHost = listOfMachines.findIndex(machine => machine.name == host)
      if (askedHost < 0) {
        throw new Error('Looks like there is no machine having name ' + host)
      } else if (useUserStore().getUsername !== user) {
        throw new Error(
          'You are trying to log into machine with different username than yours. You should only login to your account in ORNL environment.',
        )
      } else {
        sshOutput += `Trying to connect to ${user} with username of ${host} ....! `
        sshOutput +=
          'In ORNL environment, you will need to enter your password that you have been assigned!<br/>'
        const CLIStore = useCLIStore()
        CLIStore.setLoginHost(host)
        return sshOutput
      }
    },
  },
  {
    name: 'man',
    docs: 'gives information for all commands',
    execute: command => {
      // if only man is provided.
      if (command._args.length === 0) {
        // create a list of docs of each command
        let manOutput = ''
        validCommands.forEach(command => {
          manOutput += command.name + '  --  ' + command.docs + '<br/>'
        })
        return manOutput
      }

      // if asked for specific command
      let manSpecificCommandOut = ''
      if (command._args.length > 0) {
        command._args.forEach(commandName => {
          const askedCommandDocs = validCommands.findIndex(
            command => command.name == commandName,
          )

          if (askedCommandDocs == -1) {
            throw new Error(
              `Couldn't find documentation of given command '${commandName}'`,
            )
          }
          manSpecificCommandOut +=
            validCommands[askedCommandDocs].docs + '<br/>'

          // if example exists, include it
          if (validCommands[askedCommandDocs].example) {
            manSpecificCommandOut += 'Example--<br/>'
            manSpecificCommandOut += validCommands[askedCommandDocs].example
          }
        })
      }

      return manSpecificCommandOut
    },
  },
  {
    name: 'help',
    docs: 'Alias to man.',
    execute: command => {
      // find man
      const manCommand = validCommands.find(command => command.name === 'man')
      return manCommand.execute(command)
    },
  },
]
