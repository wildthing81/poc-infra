[
    {
        "name": "${name}-container",
        "image": "${app_image}:latest",
        "cpu": ${fargate_cpu},
        "memory": ${fargate_memory},
        "networkMode": "awsvpc",
        "logConfiguration": {
            "logDriver": "awslogs",
            "options": {
            "awslogs-group": "/fargate/${environment}-${name}",
            "awslogs-region": "${aws_region}",
            "awslogs-stream-prefix": "ecs"
            }
        },
        "portMappings": [
            {
            "containerPort": ${app_port},
            "hostPort": ${app_port}
            }
        ]
    }
]
