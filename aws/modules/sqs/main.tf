# ------
# SQS
# ------
resource "aws_sqs_queue" "sqs_queue_sample_01" {
  name                        = "${var.system}-${var.env}-sqs-sample-01.fifo"
  fifo_queue                  = true
  content_based_deduplication = true
  max_message_size            = 262144       # 256KiB
  message_retention_seconds   = 60 * 60 * 24 # 1days
  receive_wait_time_seconds   = 10
  visibility_timeout_seconds  = 600 # 10min(要確認)

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.sqs_queue_sample_01_deadletter.arn
    maxReceiveCount     = 2
  })
}

resource "aws_sqs_queue" "sqs_queue_sample_01_deadletter" {
  name                        = "${var.system}-${var.env}-sqs-sample-01-deadletter.fifo"
  fifo_queue                  = true
  content_based_deduplication = true
  max_message_size            = 262144           # 256KiB
  message_retention_seconds   = 60 * 60 * 24 * 7 # 7days
  receive_wait_time_seconds   = 10
  visibility_timeout_seconds  = 600 # 10min(要確認)
}
