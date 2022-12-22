# Virtual Reality VM

This is a guide on how to build a Windows 10 VR VM on Libvirt.

## Enable IOMMU and VT-x

Make sure IOMMU and Virtualization extensions are enabled in your BIOS.

## Download the Virtio Windows Drivers ISO

Windows doesn't have the KVM device drivers on the install disk so we have to supply them - you can download the needed ISO here: https://github.com/virtio-win/virtio-win-pkg-scripts/blob/master/README.md

## Download the Windows 10 ISO

Obviously you'll need the Windows 10 install ISO as well.  You can use the Media Creation Tool to create an ISO: https://www.microsoft.com/en-us/software-download/windows10

## Finding PCIe Devices being passed through

Assuming you need to pass a GPU to this VM, you'll need to find out its PCI address - I'm using an RX 580 so I can do something like this:

```bash
$ sudo lspci | grep -i 'rx'
21:00.0 VGA compatible controller: Advanced Micro Devices, Inc. [AMD/ATI] Ellesmere [Radeon RX 470/480/570/570X/580/580X/590] (rev e7)
21:00.1 Audio device: Advanced Micro Devices, Inc. [AMD/ATI] Ellesmere HDMI Audio [Radeon RX 470/480 / 570/580/590]
```

The `21:00.0` and `21:00.1` is what is needed.