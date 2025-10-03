provider "aws" {
  region = "us-east-1"
}

# =============================
# ECS Cluster
# =============================
resource "aws_ecs_cluster" "my_cluster" {
  name = "chatbot-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

# =============================
# CloudWatch Log Group
# =============================
resource "aws_cloudwatch_log_group" "ecs_logs" {
  name              = "/ecs/myapp"
  retention_in_days = 7
}

# =============================
# ECS Security Group
# =============================

# =============================
# ECS Service
# =============================

resource "aws_ecs_task_definition" "my_task" {
  family                   = "social10-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"

  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn      = aws_iam_role.ecs_task_role.arn

  container_definitions = file("ecs-task.json") # keep your JSON for containers
}




resource "aws_ecs_service" "my_service" {
  name            = "chatbot-service"
  cluster         = aws_ecs_cluster.my_cluster.id
  task_definition = aws_ecs_task_definition.my_task.arn
  desired_count   = 2
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = ["subnet-0d0b3ffe4af8d0e44", "subnet-02b9cd0cb2af7942b"]
    security_groups  = [aws_security_group.my_sg.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = data.aws_lb_target_group.app_tg.arn
    container_name   = "Chatbot-AI" # Must match container name in task definition
    container_port   = 80
  }
}




