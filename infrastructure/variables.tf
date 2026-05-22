variable "aws_region" {
  description = "AWS region where the infrastructure will be deployed"
  default     = "eu-central-1"
  type        = string
}

variable "azs" {
  description = "List of availability zones"
  default     = ["eu-central-1a", "eu-central-1b"]
  type        = list(string)
}

variable "backend_port" {
  description = "Port for the backend service"
  default     = 3001
  type        = number
}

variable "mongo_org_id" {
  description = "MongoDB Atlas organization ID"
  type        = string
  sensitive   = true
}

variable "mongo_private_key" {
  description = "MongoDB Atlas private key"
  type        = string
  sensitive   = true
}

variable "mongo_public_key" {
  description = "MongoDB Atlas public key"
  type        = string
}

variable "mongo_db_name" {
  description = "Name of the MongoDB database"
  default     = "appdb"
  type        = string
}

variable "mongo_username" {
  description = "Name of the MongoDB database"
  default     = "admin"
  type        = string
}

variable "mongo_password" {
  description = "Password for the MongoDB database"
  type        = string
  sensitive   = true
}

variable "frontend_bucket" {
  description = "Name of the S3 bucket for frontend hosting"
  default     = "frontend-bucket"
  type        = string
}

variable "node_env" {
  description = "Node environment (e.g., development, production)"
  default     = "production"
  type        = string
}

variable "secret_jwt_key" {
  description = "Secret key for application"
  type        = string
  sensitive   = true
}
