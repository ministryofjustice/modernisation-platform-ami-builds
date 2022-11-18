locals {
  component_template_args = {
    ami                = join("_", [var.ami_name_prefix, var.ami_base_name])
    version            = var.configuration_version
    branch             = var.BRANCH_NAME == "" ? "main" : var.BRANCH_NAME
    python_version     = "3.6.3"
    # libpcap-devel is not available in the default yum repos for RHEL 6.10 although it may be available in the EPEL repo.  We don't need it for our purposes so we'll skip it.
    component_pkgs_ver = "0.0.1"
    install_yum_pkgs   = "wget curl unzip git nc ca-certificates gcc screen zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel gdbm-devel db4-devel xz-devel expat-devel musl-devel libffi-devel xz"
  }
}
