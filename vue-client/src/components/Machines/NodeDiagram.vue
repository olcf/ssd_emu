<template>
  <VueMermaidString :value="nodeDiagram" />
</template>

<script setup>
import VueMermaidString from 'vue-mermaid-string'
import { ref } from 'vue'
const props = defineProps({
  cores: Number,
  gpus: Number,
})
let lastCPUNames = []
let CPUNames = []
let NUMANames = []
let L3Names = []
function updateConnection() {
  let connections = ''
  for (let i = 0; i < lastCPUNames.length; i++) {
    connections += `\n${lastCPUNames[i]}---GPU${i} \n`
    connections += `\nGPU${i}---${lastCPUNames[i]} \n`
  }
  return connections
}
function addGPU() {
  let GPUDiagram = ''
  let numberOfGPUs = props.gpus
  for (let i = 0; i < numberOfGPUs; i++) {
    GPUDiagram += `block \nGPU${i}\n end `
  }
  return GPUDiagram
}
function addStyle() {
  let defaultStyle = `
  classDef CPU fill:#4174c7,stroke-width:0px,color:#ffffff
classDef L3 fill:#dae3f4,stroke-width:0px
classDef NUMA fill:#dae3f4,stroke:#f66,stroke-width:0px,color:#fff`
  const listOfCPU = CPUNames.concat(',')
  const listOfNUMA = NUMANames.concat(',')
  const listOfL3 = L3Names.concat(',')
  defaultStyle += `
class ${listOfL3} L3
class ${listOfCPU} CPU
class ${listOfNUMA} NUMA\n
`

  return defaultStyle
}
function updateCPU() {
  let numberOfCores = props.cores || 64
  //TODO: remove the default cores
  let numberOfNUMA = numberOfCores / 16 // dividing by 16 will provide number of lines of cores to put in diagram since each line as 16 small cores inside it
  let numberOfGPUs = props.gpus
  let output = ``
  let CPUctr = 0

  for (let i = 0; i < numberOfNUMA; i++) {
    // for each L3 line, we need a separate block which has 9 columns including L3 at very first.
    output += `\nblock:NUMA${i}
                columns 1
                    \nblock:NUMA${i}0
                        columns 9
                          L${i}0("L3") `
    for (let j = 0; j < 8; j++) {
      output += `CPU${i}${j}["${CPUctr}(${CPUctr},${CPUctr + numberOfCores})"]`
      CPUctr++
      // adding cpu name in list for styling
      CPUNames.push(`CPU${i}${j}`)
    }

    output += `end\n
              \tblock:NUMA${i}1\n
                \t\tcolumns 9
                L${i}1("L3") `
    for (let j = 0; j < 8; j++) {
      // we are using numberOfNUMA so that two different cpu don't have same name
      output += `CPU${i + numberOfNUMA * 2}${j}["${CPUctr}(${CPUctr},${CPUctr + numberOfCores})"]`
      CPUctr++
      // adding cpu name in list for styling
      CPUNames.push(`CPU${i + numberOfNUMA * 2}${j}`)
    }
    output += 'end\nend\n'

    // adding name of numa for styling
    NUMANames.push(`NUMA${i}`, `NUMA${i}0`, `NUMA${i}1`)

    // adding name of L3 for styling
    L3Names.push(`L${i}0`, `L${i}1`)

    // To generate connections between CPU and GPU, we need to find the last CPU of each L3 line
    // the last possible L3 cpu name could have highest first index of i and second index of 8-1=7
    lastCPUNames.push(`CPU${i}${7}`)
    lastCPUNames.push(`CPU${i + numberOfNUMA * 2}${7}`)
  }
  return output
}
let nodeDiagram = ref(`
block-beta
    columns 2
        block
        columns 1
        ${updateCPU()}
        end

        block
        columns 1
        ${addGPU()}
        ${updateConnection()}
        end
        ${addStyle()}

`)
alert(nodeDiagram.value)
</script>
