Deploy Sample using Terraform
======================

.. toctree::
   :maxdepth: 3

Prerequisites
-------------

Unix environment
^^^^^^^^^^^^^^^^^^

Make sure you have a Unix-like environment (Linux or `WSL on Windows <https://learn.microsoft.com/en-us/windows/wsl>`_)
to run the Terraform commands.

Terraform
^^^^^^^^^

To install Terraform cli, see `Install Terraform <https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli>`_

For provider documentation, see `Open Telekom Cloud Provider <https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs>`_

Adapt environment variables used in provider.tf
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table:: Environment variables
    :widths: 20 20 25
    :header-rows: 1

    * - Environment variable name
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
      - Domain Name, eg. OTC-EU-DE-000000000010000XXXXX,
        see :api_usage:`Obtaining Required Information <guidelines/calling_apis/obtaining_required_information.html>`.

    * - TF_VAR_OTC_SDK_PROJECTID
      - <your_project_id>
      - Project Id, see :api_usage:`Obtaining Required Information <guidelines/calling_apis/obtaining_required_information.html>`.

    * - TF_VAR_OTC_SDK_PROJECTNAME
      - <your_project_name>
      - Project Name, eg. eu-de_MYPROJECT

    * - TF_VAR_OTC_SDK_REGION
      - <your_region_name>
      - Region Name, eg. "eu-de", for available regions,
        see: `Regions <https://docs.otc.t-systems.com/regions-and-endpoints/index.html#region>`_.

    * - AWS_ACCESS_KEY_ID
      - <your_access_key>
      - same as TF_VAR_OTC_SDK_AK

    * - AWS_SECRET_ACCESS_KEY
      - <your_secret_key>
      - same as TF_VAR_OTC_SDK_SK
    
    * - AWS_REQUEST_CHECKSUM_CALCULATION
      - "when_required"
      - see note below

    * - AWS_RESPONSE_CHECKSUM_VALIDATION
      - "when_required"
      - see note below

.. note::

  There is an issue (`see GitHub <https://github.com/hashicorp/terraform/issues/36704>`_ ,
  `Problem - Remote State OBS - Terraform >=v1.6 <https://community.open-telekom-cloud.com/community?id=community_question&sys_id=1207be61138086d0d15a246ea6744162>`_) 
  which causes the s3 backend to fail as it doesn't respect the `skip_s3_checksum`
  setting properly due to a newer AWX Go SDK in the TF code.
  
  As a workaround set these environment variables:

  .. code-block:: bash

    export AWS_REQUEST_CHECKSUM_CALCULATION="when_required"
    export AWS_RESPONSE_CHECKSUM_VALIDATION="when_required"


Create OBS Bucket for .tfstate files
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Terraform must store state about your managed infrastructure and configuration.

This state is used by Terraform to map real world resources to your
configuration, keep track of metadata, and to improve performance
for large infrastructures.

See: `Terraform state <https://developer.hashicorp.com/terraform/language/state>`_

Create OBS bucket for terraform state file either:

* using OpenTelekomCloud OBS console with bucket name as 
  defined in :github_repo_master:`provider.tf <terraform/provider.tf>`
  file for ``terraform.backend.s3.bucket``.

* using the OpenTelekomCloud CLI with command `s3cmd <https://github.com/opentelekomcloud/obs-s3/blob/master/s3cmd/README.md>`_
  (replace <bucket_name>):

  .. code-block:: bash

      s3cmd \
        --access_key=${AWS_ACCESS_KEY_ID} \
        --secret_key=${AWS_SECRET_ACCESS_KEY} \
        --no-ssl \
        mb s3://<bucket_name>

  .. note::

      In provider.tf, the bucket name is ``sample-tf-backend``


Adapt provider.tf file
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Check and adapt following values in
:github_repo_master:`provider.tf <terraform/provider.tf>`
(see comments there).

* terraform.backend.s3.endpoints
* terraform.backend.s3.bucket
* terraform.backend.s3.key
* terraform.backend.s3.region
* provider.opentelekomcloud.auth_url

Adapt variables.tf file
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Check and adapt values in
:github_repo_master:`variables.tf <terraform/variables.tf>`.

Adapt apigw.tf file
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Adapt :github_repo_master:`apigw.tf <terraform/apigw.tf>`
according to your needs (e.g. IP addresses).

Deploy
------

In folder :github_repo_master:`terraform <terraform>`
run following commands:

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

.. note::

    Deployment of resources may take several minutes.

Terraform apply script will output the URLs to test endpoints
(**APIGWGROUPID** and **REGION** will be replaced with real values):

.. code-block:: bash

    URL = "https://APIGWGROUPID.apic.REGION.otc.t-systems.com"
    URL_APIItems = "https://APIGWGROUPID.apic.REGION.otc.t-systems.com/api/v1/items/100?q=20"
    URL_Root = "https://APIGWGROUPID.apic.REGION.otc.t-systems.com/"
    URL_docs = "https://APIGWGROUPID.apic.REGION.otc.t-systems.com/docs"
    URL_openapi = "https://APIGWGROUPID.apic.REGION.otc.t-systems.com/openapi.json"
    URL_redocs = "https://APIGWGROUPID.apic.REGION.otc.t-systems.com/redoc"
