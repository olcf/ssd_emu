export const generateCmdList = function (
  list = [],
  options = { numbered: false },
) {
  let htmlList = ''
  for (let i = 0; i < list.length; i++) {
    if (options.numbered) {
      htmlList += i + 1 + '. '
    }
    htmlList += list[i] + '<br/>'
  }
  return htmlList
}
