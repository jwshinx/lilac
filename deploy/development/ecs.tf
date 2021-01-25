########################################################
# colleges ecs cluster                                   #
########################################################
resource "aws_ecs_cluster" "colleges" {
  name = "${local.project}-${local.prefix}-colleges-cluster"

  tags = local.common_tags
}

data "template_file" "colleges_container_definitions" {
  template = file("./templates/ecs/colleges-container-definitions.json.tpl")

  vars = {
    app_image        = var.ecr_image_colleges
    log_group_name   = aws_cloudwatch_log_group.ecs_task_logs.name
    log_group_region = data.aws_region.current.name
    allowed_hosts    = aws_lb.colleges.dns_name
  }
}

resource "aws_ecs_task_definition" "colleges" {
  family                   = "${local.project}-${local.prefix}-colleges"
  container_definitions    = data.template_file.colleges_container_definitions.rendered
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.task_execution_role.arn # starting
  task_role_arn            = aws_iam_role.app_iam_role.arn        # runtime
  volume {
    name = "static"
  }

  tags = local.common_tags
}

resource "aws_ecs_service" "colleges" {
  name            = "${local.project}-${local.prefix}-colleges"
  cluster         = aws_ecs_cluster.colleges.name
  task_definition = aws_ecs_task_definition.colleges.family
  desired_count   = 2
  launch_type     = "FARGATE"

  network_configuration {
    subnets = [
      aws_subnet.private_a.id,
      aws_subnet.private_b.id,
    ]
    security_groups = [aws_security_group.ecs_service.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.colleges.arn
    container_name   = "colleges"
    container_port   = 8080
  }
}

resource "aws_cloudwatch_log_group" "ecs_task_logs" {
  name = "${local.project}-${local.prefix}-cluster-logs"

  tags = local.common_tags
}

########################################################################
resource "aws_iam_role" "task_execution_role" {
  name               = "${local.project}-${local.prefix}-task-exec-role"
  assume_role_policy = file("./templates/ecs/assume-role-policy.json")
}

resource "aws_iam_role_policy_attachment" "task_execution_role" {
  role       = aws_iam_role.task_execution_role.name
  policy_arn = aws_iam_policy.task_execution_role_policy.arn
}

resource "aws_iam_role" "app_iam_role" {
  # role necessary for runtime
  name               = "${local.project}-${local.prefix}-api-task"
  assume_role_policy = file("./templates/ecs/assume-role-policy.json")

  tags = local.common_tags
}

resource "aws_iam_policy" "task_execution_role_policy" {
  name        = "${local.prefix}-task-exec-role-policy"
  path        = "/"
  description = "Allow retrieving images and adding to logs"
  policy      = file("./templates/ecs/task-exec-role.json")
}
