<template>
  <VueMermaidString :value="nodeDiagram" />
</template>

<script setup>
import VueMermaidString from 'vue-mermaid-string'
import { ref } from 'vue'
const props = defineProps({
  cores: Number,
  gpu: Number,
})
let lastCPUNames = []
function updateConnection() {
  let connections = ''
  for (let i = 0; i < lastCPUNames.length; i++) {
    connections += `\n${lastCPUNames[i]}---gpu${i}\n`
  }
  return connections
}
function updateCPU() {
  let numberOfCores = props.cores || 64
  //TODO: remove the default cores
  let numberOfNUMA = numberOfCores / 16 // dividing by 16 will provide number of lines of cores to put in diagram since each line as 16 small cores inside it
  let numberOfGPUs = props.gpu
  let output = ``
  let CPUctr = 0

  for (let i = 0; i < numberOfNUMA; i++) {
    // for each L3 line, we need a separate block which has 9 columns including L3 at very first.
    output += `\nblock
                columns 1
                    \nblock
                        columns 9
                          L${i}1("L3") `
    for (let j = 0; j < 8; j++) {
      output += `CPU${i}${j}["${CPUctr}(${CPUctr},${CPUctr + numberOfCores})"]`
      CPUctr++
    }

    output += `end\n
              \tblock\n
                \t\tcolumns 9
                L${i}2("L3") `
    for (let j = 0; j < 8; j++) {
      // we are using numberOfNUMA so that two different cpu don't have same name
      output += `CPU${i + numberOfNUMA * 2}${j}["${CPUctr}(${CPUctr},${CPUctr + numberOfCores})"]`
      CPUctr++
    }
    output += 'end\nend\n'

    // To generate connections between CPU and GPU, we need to find the last CPU of each L3 line
    // the last possible L3 cpu name could have highest first index of i and second index of 8-1=7
    lastCPUNames.push(`CPU${i}${7}`)
    lastCPUNames.push(`CPU${i + numberOfNUMA * 2}${7}`)
  }
  alert(output)
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
            columns 2
                NIC2["NIC(hsn2)"]
                NIC1["NIC(hsn1)"]
            space:4

            columns 2
            block
                gpu5["GPU 5"] space:2 gpu4["GPU 4"]
                gpu5 --- gpu4
                gpu4--"connect"-->gpu5
            end
            block
                gpu2["GPU 2"] space:2 gpu3["GPU 3"]
                gpu2 --- gpu3
                gpu3--"connect"-->gpu2
            end
            space:4
            columns 2
            block
                gpu7["GPU 7"] space:2 gpu6["GPU 6"]
                gpu7 --- gpu6
                gpu6--"connect"-->gpu7
            end
            block
                gpu0["GPU 0"] space:2 gpu1["GPU 1"]
                gpu0 --- gpu1
                gpu1--"connect"-->gpu0
            end
            space:4
            columns 2
            block
                NIC3["NIC(hsn3)"]
            end
            block
                NIC0["NIC(hsn0)"]
            end

        end
        gpu5 --- gpu0
        gpu5 --- gpu7
        gpu4 --- gpu2
        gpu2 --- gpu4
        gpu2 --- gpu0
        gpu3 --- gpu1
        gpu3 --- gpu7
        gpu6 --- gpu0
        gpu0 --- gpu6
        gpu5 --- NIC2
        gpu3 --- NIC1
        gpu7 --- NIC3
        gpu1 --- NIC0
        ${updateConnection()}
`)
</script>
