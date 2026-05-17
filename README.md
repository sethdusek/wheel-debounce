# wheel-debounce

A Lua script for [libinput](https://gitlab.freedesktop.org/libinput/libinput) that debounces mouse scroll wheel input to prevent reverse-scrolling because of broken scroll wheel encoders.

I have a Lamzu Atlantis OG V2 4k. Unfortunately after 2 years of use the scroll wheel is nearly unusable; scrolling causes it to scroll in the opposite direction randomly. I don't have a soldering iron ready and so I can't really replace the encoder, so for now I made this script to fix it in software.

## Solution

This script will intercept libinput events, and ignore scroll events that are in the opposite direction of the last scroll event and happen between the debounce threshold (50ms seems to work well by default)

## Configuration

Edit the constants at the top of `wheel-debounce.lua`:

| Variable               | Default                     | Description                                                                                                          |
| ---------------------- | --------------------------- | -------------------------------------------------------------------------------------------------------------------- |
| `MOUSE_NAME`           | `"Compx LAMZU 4K Receiver"` | The evdev name of your mouse                                                                                         |
| `DEBOUNCE_TIME_MICROS` | `50000`                     | Debounce window in microseconds (50 ms). Increase this if you still get occasional scrolls in the opposite direction |

To find your mouse's evdev name:

```sh
libinput list-devices
```

## Installation

The best place to put wheel-debounce is in `/etc/libinput/plugins`, since most Wayland compositors should load from there.

To verify that you've correctly selected your mouse name and that the plugin is loaded:

```bash
$ journalctl --grep wheel-debounce

```

and you should see something like:

```
May 17 15:15:28 ryzen kwin_wayland[47397]: Libinput: Plugin:wheel-debounce.lua - wheel-debounce: Loaded for mouse Compx LAMZU 4K Receiver
```
