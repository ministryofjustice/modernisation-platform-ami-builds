For shared components, see `../../../commonimages/components/`.
Those components are built by a separate pipeline and support versioning.

Components that are only ever used by a single image can be placed
here. Only the current version of component is kept, the previous
version is deleted when the terraform applies.
