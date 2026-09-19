resource "aws_mq_broker" "flociMQ" {
  broker_name = "flociAwsMq"

  engine_type        = "RABBITMQ"
  engine_version     = "5.17.6"
  host_instance_type = "mq.t2.micro"
  tags               = {}

  user {
    username = "flociUser"
    password = "flociPwd123456"
  }
}

resource "aws_elasticcache_replication_group" "flociElasticCache" {
  replication_group_id = "flociElasticCache"
  description          = "Floci Elastic Cache Replication Group"
  engine               = "valkey"
  parameter_group_name = "default.valkey8.cluster.on"
}