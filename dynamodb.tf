resource "aws_dynamodb_table" "terraform_locks" {
  name         = "eliot-terraform-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name = "terraform-locks-${var.account_name}"
  }
}

resource "aws_dynamodb_table" "efrei" {
  name         = "table_efrei"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "chanteur"
  range_key    = "chanson"

  attribute {
    name = "chanteur"
    type = "S"
  }

  attribute {
    name = "chanson"
    type = "S"
  }

  point_in_time_recovery {
    enabled = true
  }

  tags = {
    Name = "table_efrei-${var.account_name}"
  }
}

resource "aws_dynamodb_table_item" "item1" {
  table_name = aws_dynamodb_table.efrei.name
  hash_key   = aws_dynamodb_table.efrei.hash_key
  range_key  = aws_dynamodb_table.efrei.range_key

  item = jsonencode({
    chanteur = { S = "Youssou Ndour" }
    chanson  = { S = "wiri wiri" }
  })
}

resource "aws_dynamodb_table_item" "item2" {
  table_name = aws_dynamodb_table.efrei.name
  hash_key   = aws_dynamodb_table.efrei.hash_key
  range_key  = aws_dynamodb_table.efrei.range_key

  item = jsonencode({
    chanteur = { S = "Stromae" }
    chanson  = { S = "Papaoutai" }
  })
}

resource "aws_dynamodb_table_item" "item3" {
  table_name = aws_dynamodb_table.efrei.name
  hash_key   = aws_dynamodb_table.efrei.hash_key
  range_key  = aws_dynamodb_table.efrei.range_key

  item = jsonencode({
    chanteur = { S = "Angele" }
    chanson  = { S = "Balance ton quoi" }
  })
}

resource "aws_dynamodb_table_item" "item4" {
  table_name = aws_dynamodb_table.efrei.name
  hash_key   = aws_dynamodb_table.efrei.hash_key
  range_key  = aws_dynamodb_table.efrei.range_key

  item = jsonencode({
    chanteur = { S = "Aya Nakamura" }
    chanson  = { S = "Djadja" }
  })
}
