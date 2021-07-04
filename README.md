# terraform

1. change stage value in backend/local.tfvars e.g. qat, prod,
or developer name. Also add your AWS user access_key & secret_key
2. install terraform & run 'cd backend'
3. run 'terraform init'
4. run 'terraform plan -var-file='local.tfvars'. If it's ok,
5. run 'terraform apply -var-file='local.tfvars' to deploy

run 'terraform destroy -var-file='local.tfvars' to destroy all resources



