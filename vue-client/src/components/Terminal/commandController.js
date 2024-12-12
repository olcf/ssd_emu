import { api } from '@/apis'
import { generateCmdList } from './styleCmdResponse'

const loginInformation = `<br/>
****************************************************************************<br/>
                          NOTICE TO USERS<br/>
<br/>
This is a Federal computer system and is the property of the United States<br/>
Government.  It is for authorized use only.  Users (authorized or<br/>
unauthorized) have no explicit or implicit expectation of privacy.<br/>
<br/>
Any or all uses of this system and all files on this system may be<br/>
intercepted, monitored, recorded, copied, audited, inspected, and disclosed<br/>
to authorized site, Department of Energy, and law enforcement personnel, as<br/>
well as authorized officials of other agencies, both domestic and foreign.<br/>
By using this system, the user consents to such interception, monitoring,<br/>
recording, copying, auditing, inspection, and disclosure at the discretion<br/>
of authorized site or Department of Energy personnel.<br/>
<br/>
Unauthorized or improper use of this system may result in administrative<br/>
disciplinary action and civil and criminal penalties.  By continuing to use<br/>
this system you indicate your awareness of and consent to these terms and<br/>
conditions of use.  LOG OFF IMMEDIATELY if you do not agree to the<br/>
conditions stated in this warning.<br/>
****************************************************************************<br/>
`

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
      const host = splittedUserHost[1]

      let sshOutput = ''
      let listOfMachines = await api.Machine.getAllMachines()
      let askedHost = listOfMachines.findIndex(machine => machine.name == host)
      if (askedHost < 0) {
        throw new Error('Looks like there is no machine having name ' + host)
      } else {
        // TODO: add special stylings here
        sshOutput += `Trying to connect to ${user} with username of ${host} ....! `
        sshOutput += loginInformation
        sshOutput +=
          'In ORNL environment, you will need to enter your password that you have been assigned!<br/>'

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
        })
      }

      return manSpecificCommandOut
    },
  },
  {
    name: 'help',
    docs: 'Use `man` or `man command` instead.',
    execute: () => {
      return 'Use `man` or `man command` instead.'
    },
  },
]
