variable "project_id" {
  type = string
}

variable "region" {
  type = string
}

variable "vpc_list" {
  type = list(string)
}

variable "webapp_ip_cidr_range" {
  type = string
}

variable "db_ip_cidr_range" {
  type = string
}

variable "custom_route_dest_range" {
  type = string
}

variable "vpc_auto_create_subnetworks" {
  type = bool
}

variable "vpc_routing_mode" {
  type = string
}

variable "vpc_delete_default_routes_on_create" {
  type = bool
}

variable "vpc_description" {
  type = string
}

variable "custom_route_next_hop_gateway" {
  type = string
}
