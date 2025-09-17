# FunctionGraph example fg-http-python-fastapi

Sample on how to create FunctionGraph HTTP function using python and [FastAPI framework](https://fastapi.tiangolo.com)

## Prerequisites

### Python 3.10 installed

See [python.org](https://www.python.org/downloads/) on how to install python.

### Python venv

Create and activate a python virtual environment like:

```bash
# Create python env
python3 -m venv .venv

# activate venv
source .venv/bin/activate

# install requirements
pip install -r requirements.txt

```

## Test locally

```bash
# change folder
cd src

# start program
python3 app.py
```

Open browser with http://localhost:8000/

Further endpoints:

http://localhost:8000/openapi.json

http://localhost:8000/docs

http://localhost:8000/redoc

http://localhost:8000/api/items/100?q=100

## Deploy to OpenTelekomCloud using Terraform

### Prerequisites

#### Install terraform

To install Terraform cli, see [Install Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

#### Adapt environment variables used in provider.tf

| Env variable               | Description
| -------------------------- | -------------------
| TF_VAR_OTC_SDK_AK          | Personal access key
| TF_VAR_OTC_SDK_SK          | Personal secret key
| TF_VAR_OTC_SDK_DOMAIN_NAME | Domain Name, eg. OTC-EU-DE-000000000010000XXXXX
| TF_VAR_OTC_SDK_PROJECTID   | Project Id
| TF_VAR_OTC_SDK_PROJECTNAME | Project Name, eg. eu-de_MYPROJECT
| AWS_ACCESS_KEY_ID          | same as TF_VAR_OTC_SDK_AK
| AWS_SECRET_ACCESS_KEY      | same as TF_VAR_OTC_SDK_SK

#### Create OBS Bucket for .tfstate files

Terraform must store state about your managed infrastructure and configuration.
This state is used by Terraform to map real world resources to your configuration,
keep track of metadata, and to improve performance for large infrastructures.

See:[Terraform state](https://developer.hashicorp.com/terraform/language/state)

Create OBS bucket for terraform state file either:
* using OpenTelekomCloud OBS console with bucket name as defined in ``provider.tf`` file for ``bucket``.

* using the OpenTelekomCloud CLI with command [s3cmd](https://github.com/opentelekomcloud/obs-s3/blob/master/s3cmd/README.md)
```bash
    s3cmd \
      --access_key=${AWS_ACCESS_KEY_ID} \
      --secret_key=${AWS_SECRET_ACCESS_KEY} \
      --no-ssl \
      mb s3://<bucket_name>
```


#### Adapt provider.tf file

Check and adapt following values in [provider.tf](./terraform/provider.tf) (see comments there).

```
backend.s3.endpoints
backend.s3.bucket
backend.s3.key
backend.s3.region
```

#### Adapt apigw.tf file

Adapt apigw.tf according to your needs (e.g. IP addresses).

### Deploy
In folder ``terraform``

```bash
# initialize provider
terraform init

# plan changes
terraform plan

# apply changes
terraform apply

# destroy all deployed resources on OpenTelekomCloud
terraform destroy
```

Terraform apply script will output the URL of the api gateway like:

```terraform
URL = "https://e5beede1b02a41d3b1e7060974ed6a62.apic.eu-de.otc.t-systems.com/"
```

Test deployed endpoints
=======================

```
https://e5beede1b02a41d3b1e7060974ed6a62.apic.eu-de.otc.t-systems.com/

https://e5beede1b02a41d3b1e7060974ed6a62.apic.eu-de.otc.t-systems.com/openapi.json

https://e5beede1b02a41d3b1e7060974ed6a62.apic.eu-de.otc.t-systems.com/docs

https://e5beede1b02a41d3b1e7060974ed6a62.apic.eu-de.otc.t-systems.com/redoc

https://e5beede1b02a41d3b1e7060974ed6a62.apic.eu-de.otc.t-systems.com/api/items/100?q=100
```
