#!/bin/bash

# Load environment variables from .env file
if [[ -f .env ]]; then
  echo "Loading environment variables from .env file"
  source .env
fi

# Function to check if a variable is set
is_variable_set() {
  [[ -n "${!1}" ]]
}

# Function to get the value of a variable
get_variable_value() {
  local variable_name=$1
  local env_variable_name="ERGX_TF_CONFIG_${variable_name^^}"
  local default_value=$2

  if is_variable_set "$variable_name"; then
    echo "${!variable_name}"
  elif is_variable_set "$env_variable_name"; then
    echo "${!env_variable_name}"
  else
    echo "$default_value"
  fi
}

# Get the values of env and region
env=$(get_variable_value "env" "prod")
region=$(get_variable_value "region" "weu")

# Get the action
action=$1

# Construct the tfvar file path
tfvar_file="./.tfvars/${env}.tfvars"

# Construct the plan file path
plan_folder="./.plans"
plan_filename="${env}_${region}.tfplan"
plan_file="${plan_folder}/${plan_filename}"

# Create the plan folder if it doesn't exist
if [[ ! -d "$plan_folder" ]]; then
  mkdir -p "$plan_folder"
fi

# Perform the action
case $action in
  "init")
    backend_file="./.backend/${env}.azurerm.tfbackend"
    terraform init -backend-config="$backend_file" -reconfigure
    ;;
  "lint")
    terraform fmt -recursive -check=true
    terraform validate
    tflint
    ;;
  "validate")
    terraform fmt -recursive -check=true
    terraform validate
    ;;
  "plan")
    terraform plan -var-file="./.tfvars/consts.tfvars" -var-file="$tfvar_file" -out="$plan_file"
    ;;
  "apply")
    if [[ -f "$plan_file" ]]; then
      terraform apply "$plan_file" || {
        echo "Plan file is stale. Running 'plan' action again."
        terraform plan -var-file="./.tfvars/consts.tfvars" -var-file="$tfvar_file" -out="$plan_file"
        terraform apply "$plan_file"
      }
    else
      echo "Plan file not found. Please run 'plan' action first."
    fi
    ;;
  "destroy")
    terraform destroy -var-file="$tfvar_file"
    ;;
  *)
    echo "Invalid action. Please specify init, lint, validate, plan, apply, or destroy."
    ;;
esac
