# Shaman: System Optimization Guide

This document describes the technical optimizations implemented in the Shaman performance module, covering boot parameters, hardware profiles, and real-time kernel tweaks.

---

## 1. Kernel Boot Parameters (`kernelModel`)
*These settings modify core kernel behavior from boot and require a system restart.*

### Hardware Virtualization
* **Enable Intel IOMMU (VT-d)**: Required for GPU and PCIe passthrough on Intel systems.
* **Enable AMD IOMMU (AMD-Vi)**: Required for GPU and PCIe passthrough on AMD systems.
* **Enable IOMMU Pass-through mode**: Improves performance by skipping DMA translation for devices not assigned to VMs.

### Latency & Performance
* **Full Kernel Preemption**: Optimizes the kernel for desktop interactivity and low-latency response.
* **Disable Transparent Hugepages**: Prevents memory management spikes that can cause micro-stutters in the UI.
* **Disable CPU Security Mitigations**: Boosts performance by disabling Spectre/Meltdown patches. Note: This involves a higher security risk.

### System Boot Appearance
* **Quiet Boot with Splash Screen**: Hides technical kernel logs behind a clean splash screen (Plymouth).
* **Verbose Debug Logging**: Displays all kernel messages during boot. Essential for troubleshooting.

---

## 2. Dynamic Hardware Profiles (`tunedModel`)
*Profiles managed by the Tuned daemon that dynamically adjust hardware for different workloads.*

### Cloud & Virtualization
* **Virtual Guest**: Configures the system to be an efficient guest in VirtualBox, VMware, or KVM.
* **Virtual Host**: Prepares the kernel to manage multiple containers and virtualization overhead.

### Desktop & Portability
* **Balanced**: Recommended balance for general use; dynamically scales hardware between power saving and speed.
* **Balanced Battery**: A hybrid profile designed to extend battery life while maintaining usability.
* **Desktop**: Improves system UI fluidity and responsiveness for daily interactive use.
* **Powersave**: Aggressively throttles hardware to preserve every drop of battery power.

### Network & Throughput
* **Minimize network jitter and delay**: Reduces network fluctuations at the cost of higher power consumption.
* **Maximum bandwidth for large data transfers**: Optimizes the system for moving massive files over high-speed networks.
* **Raw performance for background server tasks**: Excellent for code compilation and services running in the background.

### Performance & High-Intensity
* **Accelerator Performance**: Maximum raw throughput with low-latency states disabled. Best for heavy calculations.
* **HPC Compute**: Extreme configuration for clusters and complex mathematical tasks.
* **Intel SST**: Optimizes base speeds on supported Intel processors with SST-BF technology.
* **Latency Performance**: Prioritizes response time over power saving. Greatly reduces input lag for gaming.

---

## 3. Runtime Kernel Tuning (`sysctlModel`)
*Fine-tuning applied via the sysctl interface to optimize memory, networking, and responsiveness.*

### Gaming & Large Scale Apps
* **Enhance Gaming Memory Limits**: Increases memory map counts for modern games compatibility.
* **Increase Global File Handles**: Allows the system to handle more simultaneous open files.

### Kernel Hardening & Resources
* **Increase Inotify Watches**: Allows IDEs and file managers to monitor more files.
* **Expand PID Limit**: Useful for heavy multitasking and container workloads.

### Network & Internet Speed
* **Enable TCP Fast Open**: Reduces latency when re-establishing connections to websites.
* **Optimize TCP SACK**: Improves performance on high-speed connections.
* **Optimize for Gigabit Internet**: Increases buffer sizes and window scaling for high-speed connections.
* **IPv6 Privacy Extensions**: Generates temporary addresses to improve privacy online.
* **Optimized IPv6 Neighbor Table**: Improves stability on networks with many IPv6 devices.

### System Responsiveness
* **Prefer RAM over disk**: Increases RAM use over disk, reducing stutter.
* **Optimize File Browsing Speed**: Increases directory caching for faster file manager response.
* **Background Write Threshold**: Starts background disk writing sooner to prevent lag.

---

## Technical References
* [Linux Kernel Parameters](https://www.kernel.org/doc/html/latest/admin-guide/kernel-parameters.html)
* [Tuned Project](https://tuned-project.org/)
* [Sysctl Explorer](https://sysctl-explorer.net/)
* [Proton/Wine Guide](https://github.com/ValveSoftware/Proton)
