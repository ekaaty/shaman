/**
 * @page perf_refs Reference Sources
 * @brief Technical foundation for the Shaman Performance Model.
 *
 * This section lists the official documentation used to validate the kernel
 * and system parameters.
 *
 * - [Linux Kernel Parameters](https://www.kernel.org/doc/html/latest/admin-guide/kernel-parameters.html)
 * - [Tuned Project](https://tuned-project.org/)
 * - [Sysctl Explorer](https://sysctl-explorer.net/)
 * - [Proton/Wine Guide](https://github.com/ValveSoftware/Proton)
 */

import QtQuick

QtObject {
    property var kernelModel: [
        {
            title: "Latency & Performance",
            type: "multiselect",
            items: [
                {
                    id: "preempt_full",
                    text: "Full Kernel Preemption",
                    description: "Optimizes the kernel for desktop interactivity and low-latency response.",
                    kernel_cmdline_args: "preempt=full",
                    checked: true
                },
                {
                    id: "thp_never",
                    text: "Disable Transparent Hugepages",
                    description: "Prevents memory management spikes that can cause micro-stutters in the UI.",
                    kernel_cmdline_args: "transparent_hugepage=never",
                    checked: false
                },
                {
                    id: "mitigations_off",
                    text: "Disable CPU Security Mitigations",
                    description: "Boosts performance by disabling Spectre/Meltdown patches. Higher security risk.",
                    kernel_cmdline_args: "mitigations=off",
                    checked: false
                }
            ]
        },
        {
            title: "System Boot Appearance",
            type: "multiselect",
            items: [
                {
                    id: "quiet_splash",
                    text: "Quiet Boot with Splash Screen",
                    description: "Hides technical kernel logs behind a clean splash screen (Plymouth).",
                    kernel_cmdline_args: "quiet splash",
                    checked: true
                },
                {
                    id: "verbose_logging",
                    text: "Verbose Debug Logging",
                    description: "Displays all kernel messages during boot. Essential for troubleshooting.",
                    kernel_cmdline_args: "debug ignore_loglevel",
                    checked: false
                }
            ]
        },
        {
            title: "Hardware Virtualization",
            type: "multiselect",
            items: [
                {
                    id: "intel_iommu",
                    text: "Enable Intel IOMMU (VT-d)",
                    description: "Required for GPU and PCIe passthrough on Intel systems.",
                    kernel_cmdline_args: "iommu=on intel_iommu=on",
                    checked: false
                },
                {
                    id: "amd_iommu",
                    text: "Enable AMD IOMMU (AMD-Vi)",
                    description: "Required for GPU and PCIe passthrough on AMD systems.",
                    kernel_cmdline_args: "iommu=on amd_iommu=on",
                    checked: false
                },
                {
                    id: "iommu_pt",
                    text: "Enable IOMMU Pass-through mode",
                    description: "Improves performance by skipping DMA translation for devices not assigned to VMs.",
                    kernel_cmdline_args: "iommu=pt",
                    checked: false
                }
            ]
        }
    ]

    property var tunedModel: [
        {
            title: "Desktop & Portability",
            type: "oneselect",
            items: [
                {
                    id: "balanced",
                    text: "Recommended balance for general use",
                    description: "Dynamically scales hardware between power saving and speed.",
                    tuned_profile_name: "balanced",
                    checked: false
                },
                {
                    id: "balanced_battery",
                    text: "Balanced power saving for laptops",
                    description: "A hybrid profile designed to extend battery life while maintaining usability.",
                    tuned_profile_name: "balanced-battery",
                    checked: false
                },
                {
                    id: "desktop",
                    text: "General desktop and workstation optimization",
                    description: "Improves system UI fluidity and responsiveness for daily interactive use.",
                    tuned_profile_name: "desktop",
                    checked: false
                },
                {
                    id: "powersave",
                    text: "Maximum energy savings for battery life",
                    description: "Aggressively throttles hardware to preserve every drop of battery power.",
                    tuned_profile_name: "powersave",
                    checked: false
                }
            ]
        },
        {
            title: "Network & Throughput",
            type: "oneselect",
            items: [
                {
                    id: "network_latency",
                    text: "Minimize network jitter and delay",
                    description: "Reduces network fluctuations at the cost of higher power consumption.",
                    tuned_profile_name: "network-latency",
                    checked: false
                },
                {
                    id: "network_throughput",
                    text: "Maximum bandwidth for large data transfers",
                    description: "Optimizes the system for moving massive files over high-speed networks.",
                    tuned_profile_name: "network-throughput",
                    checked: false
                },
                {
                    id: "throughput_performance",
                    text: "Raw performance for background server tasks",
                    description: "Excellent for code compilation and services running in the background.",
                    tuned_profile_name: "throughput-performance",
                    checked: false
                }
            ]
        },
        {
            title: "Cloud & Virtualization",
            type: "oneselect",
            items: [
                {
                    id: "virtual_guest",
                    text: "Optimized for running inside a virtual machine",
                    description: "Configures the system to be an efficient guest in VirtualBox, VMware, or KVM.",
                    tuned_profile_name: "virtual-guest",
                    checked: false
                },
                {
                    id: "virtual_host",
                    text: "Hosting virtual machines and Docker containers",
                    description: "Prepares the kernel to manage multiple containers and virtualization overhead.",
                    tuned_profile_name: "virtual-host",
                    checked: false
                }
            ]
        },
        {
            title: "Performance & High-Intensity",
            type: "oneselect",
            items: [
                {
                    id: "accelerator_performance",
                    text: "High-intensity computing workloads",
                    description: "Maximum raw throughput with low-latency states disabled. Best for heavy calculations.",
                    tuned_profile_name: "accelerator-performance",
                    checked: false
                },
                {
                    id: "hpc_compute",
                    text: "High-performance scientific computing",
                    description: "Extreme configuration for clusters and complex mathematical tasks.",
                    tuned_profile_name: "hpc-compute",
                    checked: false
                },
                {
                    id: "intel_sst",
                    text: "Base frequency tuning for Intel CPUs",
                    description: "Optimizes base speeds on supported Intel processors with SST-BF technology.",
                    tuned_profile_name: "intel-sst",
                    checked: false
                },
                {
                    id: "latency_performance",
                    text: "Maximum performance for gaming and low latency",
                    description: "Prioritizes response time over power saving. Greatly reduces input lag.",
                    tuned_profile_name: "latency-performance",
                    checked: false
                }
            ]
        }
    ]

    property var sysctlModel: [
        {
            title: "Gaming & Large Scale Apps",
            type: "multiselect",
            items: [
                {
                    id: "max_map_count",
                    text: "Enhance Gaming Memory Limits",
                    description: "Increases memory map counts for modern games compatibility.",
                    sysctl_key_name: "vm.max_map_count",
                    sysctl_key_value: "2147483642",
                    checked: true
                },
                {
                    id: "file_max",
                    text: "Increase Global File Handles",
                    description: "Allows the system to handle more simultaneous open files.",
                    sysctl_key_name: "fs.file-max",
                    sysctl_key_value: "2097152",
                    checked: true
                }
            ]
        },
        {
            title: "Kernel Hardening & Resources",
            type: "multiselect",
            items: [
                {
                    id: "max_user_watches",
                    text: "Increase Inotify Watches",
                    description: "Allows IDEs and file managers to monitor more files.",
                    sysctl_key_name: "fs.inotify.max_user_watches",
                    sysctl_key_value: "524288",
                    checked: true
                },
                {
                    id: "pid_max",
                    text: "Expand PID Limit",
                    description: "Useful for heavy multitasking and container workloads.",
                    sysctl_key_name: "kernel.pid_max",
                    sysctl_key_value: "4194304",
                    checked: false
                }
            ]
        },
        {
            title: "Network & Internet Speed",
            type: "multiselect",
            items: [
                {
                    id: "tcp_fastopen",
                    text: "Enable TCP Fast Open",
                    description: "Reduces latency when re-establishing connections to websites.",
                    sysctl_key_name: "net.ipv4.tcp_fastopen",
                    sysctl_key_value: "3",
                    checked: true
                },
                {
                    id: "tcp_sack",
                    text: "Optimize TCP SACK",
                    description: "Improves performance on high-speed connections.",
                    sysctl_key_name: "net.ipv4.tcp_sack",
                    sysctl_key_value: "1",
                    checked: true
                },
                {
                    id: "rmem_max",
                    text: "Optimize for Gigabit Internet",
                    description: "Increases buffer sizes and window scaling for high-speed connections.",
                    sysctl_key_name: "net.core.rmem_max",
                    sysctl_key_value: "16777216",
                    checked: false
                },
                {
                    id: "autoconf",
                    text: "IPv6 Privacy Extensions",
                    description: "Generates temporary addresses to improve privacy online.",
                    sysctl_key_name: "net.ipv6.conf.all.use_tempaddr",
                    sysctl_key_value: "2",
                    checked: true
                },
                {
                    id: "max_addresses",
                    text: "Optimized IPv6 Neighbor Table",
                    description: "Improves stability on networks with many IPv6 devices.",
                    sysctl_key_name: "net.ipv6.neigh.default.gc_thresh3",
                    sysctl_key_value: "4096",
                    checked: false
                }
            ]
        },
        {
            title: "System Responsiveness",
            type: "multiselect",
            items: [
                {
                    id: "swappiness",
                    text: "Prefer RAM over disk",
                    description: "Increases RAM use over disk, reducing stutter.",
                    sysctl_key_name: "vm.swappiness",
                    sysctl_key_value: "10",
                    checked: true
                },
                {
                    id: "vfs_cache_pressure",
                    text: "Optimize File Browsing Speed",
                    description: "Increases directory caching for faster file manager response.",
                    sysctl_key_name: "vm.vfs_cache_pressure",
                    sysctl_key_value: "50",
                    checked: true
                },
                {
                    id: "dirty_background_ratio",
                    text: "Background Write Threshold",
                    description: "Starts background disk writing sooner to prevent lag.",
                    sysctl_key_name: "vm.dirty_background_ratio",
                    sysctl_key_value: "5",
                    checked: true
                }
            ]
        }
    ]
}
