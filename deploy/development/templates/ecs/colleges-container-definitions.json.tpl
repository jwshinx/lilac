[
  {
    "name": "colleges",
    "image": "${app_image}",
    "essential": true,
    "portMappings": [
      {
        "containerPort": 8080,
        "hostPort": 8080
      }
    ],
    "memoryReservation": 512,
    "environment": [
      {"name": "APP_HOST", "value": "127.0.0.1"},
      {"name": "APP_PORT", "value": "80"},
      {"name": "LISTEN_PORT", "value": "80"}
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "${log_group_name}",
        "awslogs-region": "${log_group_region}",
        "awslogs-stream-prefix": "colleges"
      }
    },
    "mountPoints": [
      {
        "readOnly": true,
        "containerPath": "/vol/static",
        "sourceVolume": "static"
      }
    ]
  }
]
