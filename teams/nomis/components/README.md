Currently, components are build by the imagebuilder module at the same
time as the pipeline.

Therefore, a component can only be built by a single pipeline.  This
is why the components are placed in sub-directories, with the same name
as the associated image.

If components are intended to be shared across multiple images, then
this folder probably should contain some terraform to build those
shared components and the imagebuilder updated appropriately.
