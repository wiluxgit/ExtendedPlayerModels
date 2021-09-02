# ExtendedPlayerModels
A Minecraft 1.17 shader which makes it possible to customize player models.
Works for everyone with the pack

![image](https://user-images.githubusercontent.com/70565775/131851851-0a27216d-7eca-48c3-aa64-cd16b85919a8.png)
### Basic Editing
TODO: tool to generate.

This section contains all useful examples for player models
- PX(0,0) = identifier pixel. Must be 0xFF0000FF (pure red, full opacity)
- PX(1,0)
  - R = api version, currently = 0
- PX(2,0) = extra perm

### Advanced Editing
Each face has an ID, see list in ...md 

The face data is position is located at:
`X = (ID-32)%8`, `Y = floor((ID-32)/8)`

Treat the RGBA value at this position 1 integer

DATA: `TTxxxxxx yyyyyymM bbbb____ ________`
- T:2 = type 
  - 00 => Outer Layer
  - 01 => Outer Layer reversed
  - 10 => Inner Layer reversed
  - 11 => Parallell
- x:6 = UV x offset (offset from original UV location in pixels)
- y:6 = UV y offest 
- m:1 = mirror texture X
- M:1 = mirror texture Y
- B:4 = Bitmask of which corners to fold
  - 00 => C0 & C1
  - 01 => C1 & C2
  - 10 => C2 & C3
  - 11 => C3 & C0


### TODO
Calculate lighting on models.
