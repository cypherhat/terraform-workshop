Managing DNS
============
This section is designed to showcase Terraform's ability to manage more than
compute resources. This section uses Route 53 to create a DNS record to easily
access our instances.

Record Creation
---------------
Now you can run `terraform plan 04-route53-record`. If Terraform prompts
for input, make sure you entered a default on line 6 for the subdomain. This
value must be unique to this training.

Assuming everything looks correct, you can run the apply by running
`terraform apply 04-route53-record`. This will create the subdomain and
point it at the IP of your load balancer on EC2. You will see this as an
output.

A note on Zones:
----------------
Terraform wants to *completely* manage the resources declared. If you want Terraform
to manage a Hosted Zone in Route53, you declare the zone with the `aws_route53_zone` tag.

```
resource "aws_route53_zone" "primary" {
  name = "yourdomain.tld"
}

resource "aws_route53_record" "web" {
   zone_id = "${aws_route53_zone.primary.zone_id}"
   name = "web.yourdomain.tld"
   type = "A"
   ttl = "30"
   records = ["${aws_instance.haproxy.public_ip}"]
}
```

This will create a new hosted zone with brand new name servers. It will also create an A record
for the subdomain that points to the HA Proxy instance. It will take 24-48 hours for
this to be useable.

Otherwise, if you just want to *immediately* add an A record, you just declare the
`aws_route53_record` resource and specify an existing zone_id. For example:

```
resource "aws_route53_record" "web" {
   zone_id = "ZZZZZZZZZZZZZZ"
   name = "web.yourdomain.tld"
   type = "A"
   ttl = "30"
   records = ["${aws_instance.haproxy.public_ip}"]
}

```
