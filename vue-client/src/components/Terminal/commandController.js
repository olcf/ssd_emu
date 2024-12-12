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
    command: 'info',
    docs: 'Info command is used to show information about this software!',
    execute: () => {
      return 'This application is EMU(Supercomputer emulation program)!'
    },
  },
  {
    command: 'ls',
    docs: 'ls works similar to other `ls` command on other applications',
    execute: command => {
      throw new Error(command + ' Feature on progress')
    },
  },
  {
    command: 'man',
    docs: 'gives information for all commands',
    execute: command => {
      const commandList = command.split(' ')
      if (commandList.length <= 1) {
        // create a list of everything in this command except man
        let manOutput = ''
        validCommands.forEach(command => {
          manOutput += command.command + '  --  ' + command.docs + '<br/>'
        })
        return manOutput
      }
      const askedCommandDocs = validCommands.findIndex(
        obj => obj.command == commandList[1],
      )
      if (askedCommandDocs == -1) {
        throw new Error(
          `Couldn't find documentation of given command '${command}'`,
        )
      }
      return validCommands[askedCommandDocs].docs
    },
  },
  {
    command: 'help',
    docs: 'Use `man` or `man command` instead.',
    execute: () => {
      return 'Use `man` or `man command` instead.'
    },
  },
]
