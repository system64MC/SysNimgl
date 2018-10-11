# Copyright 2018, NimGL contributors.

## STB Module | stb_image.h - Image loading/decoding library
## ====
## Thanks to Nothings for this awesome library. This are some bindings to
## directly interact with the library.
##
## You can always visit the original "doc" embeded in the header file to get
## a better idea `here <https://github.com/nothings/stb/blob/master/stb_image.h>`_.

# WIP

from os import splitPath

{.passC: "-DSTB_IMAGE_IMPLEMENTATION -I" & currentSourcePath().splitPath.head & "/private/stb",
  compile: "private/stb/stb_image.c"}
{.pragma: stb_image, cdecl, importc.}

type
  ImageData* = object
    width*: int32
    height*: int32
    channels*: int32
    data*: ptr char

proc stbi_load*(filename: cstring, width: ptr int32, height: ptr int32, channels: ptr int32, components: int32 = 0): ptr char {.stb_image, importc: "stbi_load".}
  ## returns a pointer to the image requested, nil if nothind found.
  ## width and height as you imagine are from the image
  ## channels, how many channels the image has
  ##    1  grey
  ##    2  grey, alpha
  ##    3  red, green, blue
  ##    4  red, green, blue, alpha
  ## components, define if you require some especific number of channels. If 0
  ## uses the number of channels the image has.

proc stbi_load*(filename: cstring, components: int32 = 0): ImageData =
  ## a utility to only give the filename and get a tupple with all the data
  ## more info in the original proc
  result.data = stbi_load(filename, result.width.addr, result.height.addr, result.channels.addr, components)

proc stbi_load_from_memory*(buffer: ptr char, len: int32, width: ptr int32, height: ptr int32, channels: ptr int32, components: int32 = 0): ptr char {.stb_image, importc: "stbi_load_from_memory".}
  ## returns a pointer to the image loaded from the buffer
  ## width and height as you imagine are from the image
  ## channels, how many channels the image has
  ##    1  grey
  ##    2  grey, alpha
  ##    3  red, green, blue
  ##    4  red, green, blue, alpha
  ## components, define if you require some especific number of channels. If 0
  ## uses the number of channels the image has.

proc stbi_load_from_memory*(buffer: ptr char, len: int32, components: int32 = 0): ImageData =
  ## a utility to only give the filename and get a tupple with all the data
  ## more info in the original proc
  result.data = stbi_load_from_memory(buffer, len, result.width.addr, result.height.addr, result.channels.addr, components)

proc stbi_image_free*(data: ptr char): void {.stb_image, importc: "stbi_image_free".}
  ## frees the data, loaded from stbi_load

proc stbi_set_flip_vertically_on_load*(state: bool): void {.stb_image, importc: "stbi_set_flip_vertically_on_load".}
  ## flip the image vertically, so the first pixel in the output array is the bottom left
