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
]
