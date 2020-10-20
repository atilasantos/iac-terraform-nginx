resource "aws_ecs_cluster" "nginx-cluster" {
  name = "nginx-cluster"
}

resource "aws_ecs_service" "nginx-service" {
  name            = "nginx-service"
  cluster         = "${aws_ecs_cluster.nginx-cluster.id}"
  task_definition = "${aws_ecs_task_definition.nginx-task.arn}"
  desired_count   = 1
  iam_role        = "${aws_iam_role.nginx-iam_role.arn}"
  launch_type = "EC2"
  

  ordered_placement_strategy {
    type  = "binpack"
    field = "cpu"
  }

  network_configuration {
    subnets = ["${var.subnet_cidr}"]
    security_groups = ["${aws_security_group.nginx-security-group.id}"]
  
  }

#   load_balancer {
#     target_group_arn = aws_lb_target_group.foo.arn
#     container_name   = "mongo"
#     container_port   = 80
#   }

#   placement_constraints {
#     type       = "memberOf"
#     expression = "attribute:ecs.availability-zone in [us-west-2a, us-west-2b]"
#   }
}

resource "aws_ecs_task_definition" "nginx-task" {
  family                = "nginx-task"
  container_definitions = file("task-definitions/service.json")

  volume {
    name      = "service-storage"
    host_path = "/ecs/service-storage"
  }

  placement_constraints {
    type       = "memberOf"
    expression = "attribute:ecs.availability-zone in [us-west-2a, us-west-2b]"
  }
}