# One35 No System Buttons 
*DISCLAIMER: Produced heavily with the help of Claude to be "good enough" for me; I'm not a developer.  If you know a better way to do this and can make it better than an AI, please let me know so I can delete this and reference your project instead.  It would be my preference, but this is what I've got.*

##Background Information
The MagicX One35 runs its gamepad through a kernel input driver exposed at /sys/devices/platform/10010000.kp/. This driver has a writable node called keycodetype that controls how face button presses are translated before they reach Android's input system.

At the default value of 0, the driver gives the A button double duty: every press emits both BTN_GAMEPAD (the standard gamepad event) and KEY_SELECT simultaneously. Android maps KEY_SELECT to KEYCODE_DPAD_CENTER, which is the system navigation "confirm" key. Apps that handle both gamepad input and Android UI navigation — like Cannoli — receive two separate input events from a single button press, causing double-input bugs.

Writing 2 to keycodetype switches the driver to pure gamepad mode. Only BTN_GAMEPAD is emitted and the KEY_SELECT injection stops entirely. This sysfs node is world-writable, so no root is required to write to it:
~~~
echo 2 > /sys/devices/platform/10010000.kp/keycodetype
~~~
...but the value resets to 0 on every boot because it lives in kernel memory, not persistent storage.

This Magisk module solves the persistence problem. On every boot, Magisk executes service.sh in late_start service mode — after the kernel and filesystem are fully initialised. The script polls for the sysfs node to exist (waiting up to 30 seconds to handle any driver initialisation delay), then writes 2 to it. From that point until the next reboot, all face buttons deliver pure gamepad input with no Android system key injection.

The value 2 was discovered by reverse-engineering the Dawn launcher APK (magicx.touch.one), which writes to the same node before launching each app based on its "Input Enhancement" per-app setting. The three valid values map to Dawn's three options: 0 = A triggers Android select, 1 = A triggers select and B triggers Android back, 2 = no Android key injection.

## Installation
0. Install Magisk
1. Download repo as ZIP to your device
2. Install as Magisk Module

## Uninstallation
Remove the module from within Magisk
