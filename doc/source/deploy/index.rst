Deploy using Terraform
======================

.. toctree::
   :maxdepth: 3

Prerequisites
-------------

Install terraform
^^^^^^^^^^^^^^^^^^^^^^^^

To install Terraform cli, see `Install Terraform <(https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli>`_

Adapt environment variables used in provider.tf
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table:: Environment variables
    :widths: 20 20 25
    :header-rows: 1

    * - Name
      - Value
      - Remark

    * - TF_VAR_OTC_SDK_AK
      - <your_access_key>
      - see: :api_usage:`Generating an AK and SK<guidelines/calling_apis/ak_sk_authentication/generating_an_ak_and_sk.html>` in API usage guide.

    * - TF_VAR_OTC_SDK_SK
      - <your_secret_key>
      - see: :api_usage:`Generating an AK and SK<guidelines/calling_apis/ak_sk_authentication/generating_an_ak_and_sk.html>` in API usage guide.

    * - TF_VAR_OTC_SDK_DOMAIN_NAME
      - <your_domain_name>
      - Domain Name, eg. OTC-EU-DE-000000000010000XXXXX

    * - TF_VAR_OTC_SDK_PROJECTID
      - <your_project_id>
      - Project Id

    * - TF_VAR_OTC_SDK_PROJECTNAME
      - <your_project_name>
      - Project Name, eg. eu-de_MYPROJECT

    * - TF_VAR_OTC_SDK_REGION
      - <your_region_name>
      - Region Name, eg. "eu-de", for available regions, see:
        `Regions <https://docs.otc.t-systems.com/regions-and-endpoints/index.html#region>`_. 

    * - AWS_ACCESS_KEY_ID
      - <your_access_key>
      - same as TF_VAR_OTC_SDK_AK

    * - AWS_SECRET_ACCESS_KEY
      - <your_secret_key>
      - same as TF_VAR_OTC_SDK_SK


Create OBS Bucket for .tfstate files
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Terraform must store state about your managed infrastructure and configuration.

This state is used by Terraform to map real world resources to your configuration,
keep track of metadata, and to improve performance for large infrastructures.

See: `Terraform state <https://developer.hashicorp.com/terraform/language/state>`_

Create OBS bucket for terraform state file either:

* using OpenTelekomCloud OBS console with bucket name as defined in ``provider.tf`` file for ``bucket``.

* using the OpenTelekomCloud CLI with command [s3cmd](https://github.com/opentelekomcloud/obs-s3/blob/master/s3cmd/README.md)

  .. code-block:: bash
  
      s3cmd \
        --access_key=${AWS_ACCESS_KEY_ID} \
        --secret_key=${AWS_SECRET_ACCESS_KEY} \
        --no-ssl \
        mb s3://<bucket_name>


Adapt provider.tf file
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Check and adapt following values in [provider.tf](./terraform/provider.tf) (see comments there).

* backend.s3.endpoints
* backend.s3.bucket
* backend.s3.key
* backend.s3.region


Adapt apigw.tf file
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Adapt apigw.tf according to your needs (e.g. IP addresses).

Deploy
------

In folder ``terraform``

.. code-block:: bash

  # change folder
  cd terraform

  # initialize provider
  terraform init

  # plan changes
  terraform plan

  # apply changes
  terraform apply

  # destroy all deployed resources on OpenTelekomCloud
  terraform destroy


Terraform apply script will output the URLs to test endpoints
(APIGWGROUPID and REGION will be replaced with real values):

.. code-block:: bash

   URL_Root = "https://APIGWGROUPID.apic.REGION.otc.t-systems.com/"

   URL_APIItems = "https://APIGWGROUPID.apic.REGION.otc.t-systems.com/api/items/100?q=100"

   URL_docs = "https://APIGWGROUPID.apic.REGION.otc.t-systems.com/docs"

   URL_redocs = "https://APIGWGROUPID.apic.REGION.otc.t-systems.com/redoc"

   URL_openapi = "https://APIGWGROUPID.apic.REGION.otc.t-systems.com/openapi.json"


