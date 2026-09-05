resource "aws_mq_broker" "flociMQ" {
  broker_name = "flociAwsMq"

  engine_type        = "RabbitMQ"
  engine_version     = "5.17.6"
  host_instance_type = "mq.t2.micro"

  user {
    username = "flociUser"
    password = "flociPwd123456"
  }
}