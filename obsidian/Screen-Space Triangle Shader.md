[This article](https://mattdesl.svbtle.com/drawing-lines-is-hard) will be of use.

You can pass the relevant information to Godot vertex shaders through the use of CUSTOM0 and CUSTOM1. You just need to figure out how to set it.

Hopefully you can use xyz on CUSTOM0 and CUSTOM1 to store previous and next and w to store +- thickness.

Make a Godot import tool that sets CUSTOM0 and CUSTOM1 with no Blender info.

---

- [x] Converter
The purpose is to convert every line into a set of four points connected like |X|, to allow one to be pushed outward and one inward.

---

- [x] Miter shader
Remake the shader using miter joints for nice, continuous joints.

---

- [ ] Luz joints
Make the joints nicer adding an extra vertex for pointiness

---

- [ ] Turn converter into import magic
Ideally the conversion process should be handled at import, not at runtime

---