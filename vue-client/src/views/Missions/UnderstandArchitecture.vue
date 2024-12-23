<template>
  <div class="flex items-center flex-col">
    <img
      src="https://docs.olcf.ornl.gov/_images/Frontier_Node_Diagram.jpg"
      width="70%"
    />
    Each Frontier compute node consists of [1x] 64-core AMD “Optimized 3rd Gen
    EPYC” CPU (with 2 hardware threads per physical core) with access to 512 GB
    of DDR4 memory. Each node also contains [4x] AMD MI250X, each with 2
    Graphics Compute Dies (GCDs) for a total of 8 GCDs per node. The programmer
    can think of the 8 GCDs as 8 separate GPUs, each having 64 GB of
    high-bandwidth memory (HBM2E). The CPU is connected to each GCD via Infinity
    Fabric CPU-GPU, allowing a peak host-to-device (H2D) and device-to-host
    (D2H) bandwidth of 36+36 GB/s. The 2 GCDs on the same MI250X are connected
    with Infinity Fabric GPU-GPU with a peak bandwidth of 200 GB/s. The GCDs on
    different MI250X are connected with Infinity Fabric GPU-GPU in the
    arrangement shown in the Frontier Node Diagram below, where the peak
    bandwidth ranges from 50-100 GB/s based on the number of Infinity Fabric
    connections between individual GCDs.
  </div>
</template>
