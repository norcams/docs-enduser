.. |date| date::

Terraform and NREC: Part VI - Handling the state files
======================================================

Last changed: |date|

.. contents::

.. _Terraform: https://www.terraform.io/

Handling the state file after creating resources is a known pain
point, but still crucial in the life cycle management of the
infrastructure. Using an object store as a terraform backend
can mitigate this. In this example vi will define the NREC object
store as an S3 compatible backend for the terraform state. For
this to work, you must export a couple of environment variables,
``AWS_ACCESS_KEY_ID`` and ``AWS_SECRET_ACCESS_KEY``. Create a
file called for example ``provider.tf``. The following
code is suitable for terraform versions greater than 1.6.3:

.. code-block:: console

  terraform {
    backend "s3" {
      endpoints                   = { s3 = "https://object.api.bgo.nrec.no:8080" }
      bucket                      = "bgo-nrec-terraformstate"
      use_path_style              = true
      key                         = "bgo.myinfra.tfstate.tf"
      region                      = "bgo"
      skip_credentials_validation = true
      skip_region_validation      = true
      skip_requesting_account_id  = true
      skip_s3_checksum            = true
    }
  }

Simply replace ``bgo`` with ``osl`` in order to choose another region.
When using this configuration, you need to create the bucket before
running terraform init, for example

  $ s3cmd mb s3://bgo-nrec-terraformstate

If you use a terraform version older than 1.6, use the following
example (version 1.6.0 to 1.6.3 will not work at all). The bucket will
be created by terraform:

.. code-block:: console

  terraform {
    backend "s3" {
      endpoint                    = "https://object.api.bgo.nrec.no:8080"
      bucket                      = "bgo-nrec-terraformstate"
      use_path_style              = true
      key                         = "bgo.myinfra.tfstate.tf"
      region                      = "bgo"
      skip_credentials_validation = true
      skip_region_validation      = true
    }
  }

When running terraform init the backend will be inititalized. After
applying an infrastructure with terraform the state file will be
stored in the NREC object storage.
