run "basic" {
  command = ["plan"]
}

run "outputs" {
  command = ["apply"]

  assert {
    condition     = can(regex("^vpc-", outputs.vpc_id.value))
    error_message = "The vpc_id output should start with 'vpc-'"
  }

  assert {
    condition     = contains(outputs.public_subnets.value[0], "subnet-")
    error_message = "The first public subnet output should contain 'subnet-'"
  }

  assert {
    condition     = contains(outputs.private_subnets.value[0], "subnet-")
    error_message = "The first private subnet output should contain 'subnet-'"
  }
}
