For shared components, see `../../../commonimages/components/`.
Those components are built by a separate pipeline and support versioning.

Components that are only ever used by a single image can be placed
here. Since they are only used by one image, the version number is kept
in sync with that image, and previous versions of the component
are deleted when the terraform applies.
