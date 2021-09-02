# ExtendedPlayerModels
A Minecraft 1.17 Resource Pack (shader) which makes it possible to customize player models.
Works with multiplayer

![image](https://user-images.githubusercontent.com/70565775/131851851-0a27216d-7eca-48c3-aa64-cd16b85919a8.png)

## DOWNLOAD
https://github.com/OscarDahlqvist/ExtendedPlayerModels/archive/refs/heads/master.zip

## Submitting
I'd love to see more community feedpack & suggestions to this repo. You can either suggest features as "issue" or if you're a king you can also submit code sugestions.

My discord for Dms: Wilux#3918

## Editing
### Basic Editing
To edit your player model you must: 
- PX(0,0) = identifier pixel. Must be 0xFF0000FF (pure red, full opacity)
- PX(1,0)
  - R = api version, currently = 0
- PX(2,0) = extra perm

### Advanced Editing
ExtendedPlayerModels allows customization of each of the faces by setting specific color values in each face's corresponding pixel.
- Formula for finding which pixel to edit:
  `X = (ID-8)%8`, `Y = floor((ID-8)/8)`

![image](https://user-images.githubusercontent.com/70565775/131866612-79134dc2-6f23-42ef-87c4-96c31977d61d.png)<br/>*Image of face IDs.*

Im assuming you are familiar with color hex codes. The hex code is treated as a bitfield to set specific properties of the face transfomation.

RGB: `EDxxxxxx XYyyyyyy TT..cccc`
- `E:1` = Enable face modifiers. (Must be 1 if you want anything to happen)
- `D:1` = Disables the texture. (useful if you need space for something else)
- `x:6` = UV x offset. (offset from original UV location in pixels)
- `X:1` = Do mirror texture X. (NOT IMPLEMENTED)
- `Y:1` = Do mirror texture Y. (NOT IMPLEMENTED)
- `y:6` = UV y offest.
- `T:2` = Transform type.
  - `00`: Outer layer
  - `01`: Outer layer reversed
  - `10`: Inner layer reversed
  - `11`: Direct offset (EXPERIMENTAL, undocumented)
- `c:4` = Bitmask of which corners to fold. (Must be 2 bits set)


### TODO
Calculate lighting on models.
