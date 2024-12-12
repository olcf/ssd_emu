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
    docs: 'ls works similar to other `ls` command on other applications',
    execute: command => {
      throw new Error(command.name + ' Feature on progress')
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
