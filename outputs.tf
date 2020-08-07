# TODO: Define the output variable for the lambda function.
output "udacity_lambda_func_name" {
  value = aws_lambda_function.udacity_lambda.function_name
}