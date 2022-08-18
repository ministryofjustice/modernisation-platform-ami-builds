This role can be used to restore an Oracle database from an RMAN backup located in an s3 bucket.

As the intention of this role is to be used as part of a Packer AMI build, the restored database is not started and Oracle HAS is deconfigured as a final step.
