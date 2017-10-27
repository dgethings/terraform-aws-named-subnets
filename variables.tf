variable "namespace" {
  description = "Namespace (e.g. `cp` or `cloudposse`)"
  type        = "string"
}

variable "stage" {
  description = "Stage (e.g. `prod`, `dev`, `staging`)"
  type        = "string"
}

variable "delimiter" {
  type        = "string"
  default     = "-"
  description = "Delimiter to be used between `name`, `namespace`, `stage`, etc."
}

variable "attributes" {
  type        = "list"
  default     = []
  description = "Additional attributes (e.g. `policy` or `role`)"
}

variable "tags" {
  type        = "map"
  default     = {}
  description = "Additional tags (e.g. map(`BusinessUnit`,`XYZ`)"
}

variable "names" {
  type        = "list"
  description = "List of subnets names (e.g. `['apples', 'oranges', 'grapes']`)"
}

variable "max_subnets" {
  default = "16"
  description = "A maximum number of subnets which can be created. This variable is being used for CIDR blocks calculation. Default to length of `names` argument"
}

variable "type" {
  default     = "private"
  description = "The type of subnets (e.g. `private`, or `public`)"
}

variable "availability_zone" {
  description = "Availability Zone"
}

variable "vpc_id" {
  description = "ID of VPC"
}

variable "cidr_block" {
  description = "The base CIDR block which will be divided into subnet CIDR blocks (e.g. `10.0.0.0/16`)"
}

variable "igw_id" {
  description = "The Internet Gateway ID which will be used as a default route in public route tables (e.g. `igw-9c26a123`). Conflicts with `ngw_id`"
  default     = ""
}

variable "ngw_id" {
  description = "The NAT Gateway ID which will be used as a default route in private route tables (e.g. `igw-9c26a123`). Conflicts with `igw_id`"
  default     = ""
}

variable "public_network_acl_id" {
  description = "Network ACL ID that will be added to the subnets. If empty, a new ACL will be created "
  default     = ""
}

variable "private_network_acl_id" {
  description = "Network ACL ID that will be added to the subnets. If empty, a new ACL will be created "
  default     = ""
}

variable "public_network_acl_egress" {
  description = "Egress network ACL rules"
  type        = "list"

  default = [
    {
      rule_no    = 100
      action     = "allow"
      cidr_block = "0.0.0.0/0"
      from_port  = 0
      to_port    = 0
      protocol   = "-1"
    },
  ]
}

variable "public_network_acl_ingress" {
  description = "Egress network ACL rules"
  type        = "list"

  default = [
    {
      rule_no    = 100
      action     = "allow"
      cidr_block = "0.0.0.0/0"
      from_port  = 0
      to_port    = 0
      protocol   = "-1"
    },
  ]
}

variable "private_network_acl_egress" {
  description = "Egress network ACL rules"
  type        = "list"

  default = [
    {
      rule_no    = 100
      action     = "allow"
      cidr_block = "0.0.0.0/0"
      from_port  = 0
      to_port    = 0
      protocol   = "-1"
    },
  ]
}

variable "private_network_acl_ingress" {
  description = "Egress network ACL rules"
  type        = "list"

  default = [
    {
      rule_no    = 100
      action     = "allow"
      cidr_block = "0.0.0.0/0"
      from_port  = 0
      to_port    = 0
      protocol   = "-1"
    },
  ]
}
