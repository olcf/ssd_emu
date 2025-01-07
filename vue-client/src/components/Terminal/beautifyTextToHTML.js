import { validCommands } from './commandController'

const specialKeywords = ['is', 'for']

// Inspired from https://github.com/dracula/notepad-plus-plus/blob/master/Dracula.xml powershell
export const beautifyTextToHTML = response => {
  let finalHTML = String(response)

  // replace numbers with #BD93F9 color
  finalHTML = finalHTML.replace(
    /([0-9])/g,
    '<span style="color:#BD93F9">$1</span>',
  )

  // replace all special keywords with <key></key> as #50FA7B
  const keywordsRegex = new RegExp(`\\b(${specialKeywords.join('|')})`, 'gi')
  finalHTML = finalHTML.replace(
    keywordsRegex,
    '<key style="color: #50FA7B">$1</key>',
  )

  // replace available commands inside this command line as #FF79C6
  const availableCommands = validCommands.map(command => command.name).join('|')
  const availableCommandsRegex = new RegExp(`\\b(${availableCommands})`, 'gi')
  finalHTML = finalHTML.replace(
    availableCommandsRegex,
    '<key style="color:#FF79C6">$1</key>',
  )

  // replace ** with bold tag

  // Here (.*?) captures everything in non-greedy fashion.
  // .* means capture anything except new line
  // ? makes this non-greedy. (NON Greedy means  it will stop after first occurrence)
  // () captures the group and provide it to $1 or \1
  // More of this here: https://superuser.com/a/1749987
  finalHTML = finalHTML.replace(
    /\*\*(.*?)\*\*/g,
    '<cmd style="color:#BD93F9 !important; background-color:#3c3e4a">$1</cmd>',
  )
  finalHTML = finalHTML.replace(/\n/g, '<br/>')

  return finalHTML
}
