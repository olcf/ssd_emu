/**
 * Break string commands to array of commands with appropriate quotation
 * @param {String} command string to be broken into array
 * @returns array of commands
 */

const breakCommands = command => {
  const brokenCommand = []
  let inSingleQuote = false
  let inDoubleQuote = false
  let currentToken = ''
  let escapeNext = false

  for (let i = 0; i < command.length; i++) {
    const currentChar = command[i]

    if (escapeNext) {
      currentToken += currentChar
      escapeNext = false
      continue
    }
    if (currentChar === '\\') {
      escapeNext = true
      continue
    }
    // if found single quotation
    if (currentChar === "'" && !inDoubleQuote) {
      inSingleQuote = !inSingleQuote
      // we don't need to do any check after this
      continue
    }

    // if found double quotation
    if (currentChar === '"' && !inSingleQuote) {
      inDoubleQuote = !inDoubleQuote
      continue
    }
    if (currentChar === ' ' && !inSingleQuote && !inDoubleQuote) {
      brokenCommand.push(currentToken)
      currentToken = ''
    } else {
      currentToken += currentChar
    }
  }
  // If we still have token after last space.
  if (currentToken) {
    brokenCommand.push(currentToken)
  }
  return brokenCommand
}

/**
 * Converts plain text string to Object with {_args:[list of arguments], name:'Command Name'} along with key,value pair and options if they exist.
 * @param {String} command command to be parsed by using tokenizer
 * @returns Returns the parsed command  in the format
 */
export const parseCommand = command => {
  const parsedCommand = { _args: [], name: '' }

  const brokenCommands = breakCommands(command)
  const mainCommand = brokenCommands.splice(0, 1)
  parsedCommand.name = mainCommand[0]

  brokenCommands.forEach(singleCommand => {
    if (singleCommand.startsWith('--')) {
      const token = singleCommand.slice(2)
      // if the string still has other valid content after two --
      if (token) {
        // find the first Equals sign and assign answer part to string before =.
        let firstEqual = token.indexOf('=')
        if (firstEqual > 0) {
          parsedCommand[token.substring(0, firstEqual)] = token.substring(
            firstEqual + 1,
          )
        } else {
          parsedCommand[token] = true
        }
      }
    } else if (singleCommand.startsWith('-')) {
      const token = singleCommand.slice(1)
      for (let x = 0; x < token.length; x++) {
        parsedCommand[token[x]] = true
      }
    } else {
      parsedCommand._args.push(singleCommand)
    }
  })
  return parsedCommand
}
