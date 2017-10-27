module "public_label" {
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.2.2"
  namespace  = "${var.namespace}"
  name       = "${var.availability_zone}"
  attributes = ["public"]
  stage      = "${var.stage}"
  delimiter  = "${var.delimiter}"
  tags       = "${var.tags}"
}

resource "aws_subnet" "public" {
  count             = "${var.type == "public" ? length(var.names) : 0}"
  vpc_id            = "${var.vpc_id}"
  availability_zone = "${var.availability_zone}"
  cidr_block        = "${cidrsubnet(var.cidr_block, ceil(log(var.max_subnets, 2)), count.index)}"

  tags = {
    "Name"      = "${module.public_label.id}${var.delimiter}${element(var.names, count.index)}"
    "Stage"     = "${module.public_label.stage}"
    "Namespace" = "${module.public_label.namespace}"
  }
}

resource "aws_route_table" "public" {
  count  = "${var.type == "public" ? length(var.names) : 0}"
  vpc_id = "${var.vpc_id}"

  tags = {
    "Name"      = "${module.public_label.id}${var.delimiter}${element(var.names, count.index)}"
    "Stage"     = "${module.public_label.stage}"
    "Namespace" = "${module.public_label.namespace}"
  }
}

resource "aws_route" "public" {
  count                  = "${var.type == "public" ? length(var.names) : 0}"
  route_table_id         = "${element(aws_route_table.public.*.id, count.index)}"
  gateway_id             = "${var.igw_id}"
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "public" {
  count          = "${var.type == "public" ? length(var.names) : 0}"
  subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.public.*.id, count.index)}"
}

resource "aws_network_acl" "public" {
  count      = "${var.type == "public" && signum(length(var.private_network_acl_id)) == 0 ? 1 : 0}"
  vpc_id     = "${data.aws_vpc.default.id}"
  subnet_ids = ["${aws_subnet.public.*.id}"]
  egress     = "${var.public_network_acl_egress}"
  ingress    = "${var.public_network_acl_ingress}"
  tags       = "${module.public_label.tags}"
}

resource "aws_eip" "default" {
  count = "${var.type == "public" ? 1 : 0}"
  vpc   = true

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_nat_gateway" "default" {
  count         = "${var.type == "public" ? 1 : 0}"
  allocation_id = "${join("", aws_eip.default.*.id)}"
  subnet_id     = "${element(aws_subnet.public.*.id, 0)}"

  lifecycle {
    create_before_destroy = true
  }
}
