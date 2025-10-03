variable "aws_region" {
  description = "AWS region to deploy to"
  type        = string
  default     = "us-east-1"
}

variable "db_identifier" {
  description = "Identifier for the RDS instance"
  type        = string
  default     = "my-mysql-db"
}

variable "db_engine" {
  description = "RDS engine"
  type        = string
  default     = "mysql"
}

variable "db_engine_version" {
  description = "MySQL engine version"
  type        = string
  default     = "8.0"
}

variable "instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "allocated_storage" {
  description = "Storage size (GB)"
  type        = number
  default     = 20
}

variable "db_username" {
  description = "Master DB username"
  type        = string
  default     = "admin"
}



#Use an existing Secrets Manager secret containing the password.d
variable "db_password_secret_arn" {
  description = "ARN or name of an existing Secrets Manager secret containing the DB password."
  type        = string
  default     = "arn:aws:secretsmanager:us-east-1:920216467853:secret:Chatbot-secret-1MeQPi"
}

variable "vpc_id" {
  description = "VPC id where the DB subnets exist"
  type        = string
  default     = "vpc-0d5e70a92a6125cb1"
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs (for DB subnet group) - must be in the same region"
  type        = list(string)
  default     = []
}

variable "allowed_cidr" {
  description = "CIDR that will be allowed to access the DB port. For production, restrict this or prefer security-group-based access."
  type        = string
  default     = "10.0.0.0/16"
  
}

variable "backup_retention_days" {
  description = "Backup retention days"
  type        = number
  default     = 7
}

variable "multi_az" {
  description = "Whether to create a multi-AZ instance"
  type        = bool
  default     = false
}

variable "publicly_accessible" {
  description = "Whether the DB should have a public IP (not recommended)"
  type        = bool
  default     = false
}

variable "skip_final_snapshot" {
  description = "Whether to skip final snapshot on destroy"
  type        = bool
  default     = true
}
