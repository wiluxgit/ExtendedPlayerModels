
# ExtendedPlayerModels
A Minecraft 1.17 Resource Pack (shader) which makes it possible to customize player models.
Works with multiplayer

## 0. (BETA) MUST READ 
As long as this text is here: Do **not** share this resourcepack in a public forum.

![image](https://user-images.githubusercontent.com/70565775/131851851-0a27216d-7eca-48c3-aa64-cd16b85919a8.png)

## 1. DOWNLOAD [BETA]
https://github.com/OscarDahlqvist/ExtendedPlayerModels/archive/refs/heads/master.zip

Note: Lighting of the transformed faces is broken, this *should* be fixed soon.
## 2. Submitting
I'd love to see more community feedback & suggestions to this repo. You can either suggest features as "issue" or if you're a king you can also submit code suggestions.

My discord for Dms: Wilux#3918

## 3. Editing
### 3.0 What of the model can be edited?
First of all, polygons can NOT be added, only moved.
Additionally, due to quirks of the minecraft shader wrapper vertexes can only be moved along the facing (normal) of the face or they will end up distorted*.

The Currently implemented face transforms can be found in the following image.
![image](https://user-images.githubusercontent.com/70565775/131920039-caf49d61-8b6b-485f-bd98-40857809b0d6.png)<br/>*A head with it's secondary layer. The face at the bottom of the head (red) shows where it will end up after the transfomation*

Texture-wise you can freely decide which part (if any) of the skin file that a transformed face should use.

### 3.1 Basic Editing
To edit your player model you will need to set specific pixels to specific RGB values.
To get started you **MUST** to set the top left pixel to 0xFF0000 (pure red). Leave all other pixels in the top 8x8 square empty for now.

Until i finish a helper tool to generate the edited models look at examples in section 3.3 and/or go in depth in section 3.2

### 3.2 Advanced editing
To customize a specific face you need to find the face id of said face.
Face ids can be found in the following image
![image](https://user-images.githubusercontent.com/70565775/131866612-79134dc2-6f23-42ef-87c4-96c31977d61d.png)<br/>*Image of face IDs.*

To set the transform for said face you colorize its associated pixel.
- Formula for finding which pixel to edit:
  `X = ID%8`, `Y = floor((ID-8)/8)`

So the bottom face of the head would have ID=`39` and be located at `7,3`

I'm assuming you are familiar with color hex codes. The hex code is treated as a bitfield to set specific properties of the face transformation.

RGB: `#RRGGBB` = `ETTTcccc LLxxxxxx XYyyyyyy`
- `E:1` = Enable face modifiers. (Must be 1 if you want anything to happen)
- `T:3` = Transform type. (see image in section 3.0)
  - `000`: None
  - `001`: Outer
  - `010`: Outer reversed
  - `011`: Inner reversed
  - `100`: Manual **(NOT IMPLEMENTED)** (Indirect, see section 3.2.1)
- `c:4` = Bitmask of which corners to fold. *(must be 2 bits (or 0))*
- `L:2` = Scaling Direction. *(the direction in the UV map from the fixed edge to the center of the face)*
	- `00`: X+ 
	- `01`: X-
	- `10`: Y+ 
	- `11`: Y-
- `x:6` = UV x offset. *(offset from original UV location in pixels)*
- `X:1` = flip X **(NOT IMPLEMENTED)**
- `Y:1` = flip Y **(NOT IMPLEMENTED)**
- `y:6` = UV y offset.

### 3.2.1 Indirect Transforms
Indirect transforms require additional data and will use the 6 least significant bits of alpha value of the pixel and as a reference to a EXT data pixel. What this pixel's value is used for depends on the transform.
alpha = `--aaaAAA` 
 - `a:3`: x position in EXT section
 - `A:3`: y position in EXT section
 
The secondary data pixel is denoted `EXD`.  Several faces can share the same EXT data pixel,

 - **Manual** `(T=100)`
   Allows you to set pixel displacement for the transform by hand.
   - offsets corners **not** selected by the corner bitmask `c` by `EXD.r/32-16` pixels
   - offsets corners selected by the corner bitmask `c` by `EXD.g/32-16` pixels



### 3.3 Examples
 ![image](https://user-images.githubusercontent.com/70565775/131921159-a5d28fa3-698a-4f93-a9a8-a57f078c20f1.png)
![thaumux_fire](https://user-images.githubusercontent.com/70565775/131922242-60d9a760-ff7c-490e-9a9d-b5e47ae4a005.png)
Separate UV "Ears" attached to front of inner skin `PIXEL(7,3) = #BCC800 = 10111100 11001000 00000000`
