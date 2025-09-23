##########################################################
# install dependencies
##########################################################
resource "null_resource" "requirements_changes" {
  triggers = {
    index = filesha256("${path.root}/../requirements.txt")
    folder_not_exists = !provider::local::direxists("${path.root}/../target/zip_content")
  }

  provisioner "local-exec" {
    command = <<EOT
      rm -rf ${path.root}/../target/zip_content
      mkdir -p ${path.root}/../target/zip_content/dependencies
      python3 -m pip install -r ${path.root}/../requirements.txt -t ${path.root}/../target/zip_content/dependencies
    EOT
  }
}

##########################################################
# copy source files
##########################################################
resource "null_resource" "source_files" {

  depends_on = [ null_resource.requirements_changes ]

  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command = <<EOT
      # copy all files from src folder except __pycache__
      rsync -av --exclude='__pycache__' ${path.root}/../src ${path.root}/../target/zip_content/.
      # copy bootstrap file to root of zip
      cp ${path.root}/../src/bootstrap ${path.root}/../target/zip_content/bootstrap
      # remove bootstrap file from src folder
      rm -f ${path.root}/../target/zip_content/src/bootstrap
      # add build info file
      echo "Build-Date: $(date --utc +%Y-%m-%dT%H:%M:%S.%3NZ)" > ${path.root}/../target/zip_content/buildinfo.txt
    EOT
  }
}

##########################################################
# create zip file
##########################################################
data "archive_file" "function_zip" {
  depends_on = [ null_resource.source_files ]
  type = "zip"

  source_dir  = "${path.root}/../target/zip_content"
  output_path = format("${path.root}/../target/%s", var.zip_file_name)

  excludes = [
    "**/__pycache__/**"
  ]

}
