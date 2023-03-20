[This article](https://mattdesl.svbtle.com/drawing-lines-is-hard) will be of use.

You can pass the relevant information to Godot vertex shaders through the use of CUSTOM0 and CUSTOM1. You just need to figure out how to set it.

Maybe?
1. Hijack ModEngi's tool to remove references to PewPew (and to figure out how it works)
2. Write a Godot thingy that actually sets CUSTOM0 since it seems hard to set otherwise.

Hopefully you can use xyz on CUSTOM0 and CUSTOM1 to store previous and next and w to store +- thickness.

SCRAP CUSTOM.

#### Option 1: Scrap Custom:
1. Make a Blender export tool that hijacks color and uv+uv2. That should give enough space to store.

#### Option 2:
2. Make a Godot import or runtime tool that sets CUSTOM0 with no Blender info.

---

- [x] Add Godot import magic!
The purpose is to convert every line into a set of four points connected like |X|, to allow one to be pushed outward and one inward.

---

- [x] Miter shader
Remake the shader using miter joints for nice, continuous joints.