provider "aws" {
  region = "us-east-1" # Change if needed
}

# Create a public hosted zone
resource "aws_route53_zone" "chatbotai_zone" {
  name = "delightdavid.online"   # domain name
  comment = "Hosted zone for chatbotai project"
}

# Output the name servers to update domain registrar
output "name_servers" {
  value = aws_route53_zone.chatbotai_zone.name_servers
}

resource "aws_route53_record" "root" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "delightdavid.online"
  type    = "A"

  alias {
    name                   = aws_lb.my_alb.dns_name
    zone_id                = aws_lb.my_alb.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "www"
  type    = "CNAME"
  ttl     = 300
  records = ["delightdavid.online"]
}
