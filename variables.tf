# ------------------------------------------------------------
# ENVIRONMENT VARIABLES
# Define these secrets as environment variables.
# ------------------------------------------------------------

# AWS_ACCESS_KEY_ID
# AWS_SECRET_ACCESS_KEY

# ------------------------------------------------------------
# REQUIRED PARAMETERS
# These variables must be set when using this module.
# ------------------------------------------------------------

variable aws_access_key {
  description = "AWS access key"
  type        = string
  sensitive   = true
}

variable aws_secret_key {
  description = "AWS access key"
  type        = string
  sensitive   = true
}

variable "artifacts_dir" {
  description = "Directory name where artifacts should be stored"
  type        = string
  default     = "builds"
}

variable aws_region {}

variable s3_bucket_name {}

variable s3_bucket_key {}

# -------------------------------------------------------------
# OPTIONAL PARAMETERS
# These variables have defaults, but may be overridden.
# -------------------------------------------------------------

variable env {}

variable foo {}

variable "environment_variables" {
  description = "(Optional) A map of environment variables to pass to the Lambda function. AWS will automatically encrypt these with KMS if a key is provided and decrypt them when running the function."
  type        = map(string)
  default     = {}
}
