# Use existing Target Group
data "aws_lb_target_group" "app_tg" {
  arn = "arn:aws:elasticloadbalancing:us-east-1:920216467853:targetgroup/my-tg/4cd39390526a12d0"
}

# Use existing Load Balancer
data "aws_lb" "my_alb" {
  arn = "arn:aws:elasticloadbalancing:us-east-1:920216467853:loadbalancer/app/my-alb/226be1c04b351be9"
}

# Use existing HTTPS Listener
data "aws_lb_listener" "https" {
  arn = "arn:aws:elasticloadbalancing:us-east-1:920216467853:listener/app/my-alb/226be1c04b351be9/ab0b4d2693ceec46"
}


data "aws_ecs_task_definition" "my_task" {
  task_definition = "social10-task:18"
}