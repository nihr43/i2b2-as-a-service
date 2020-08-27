.PHONY: plan force-apply

terraform:
	wget -O- https://releases.hashicorp.com/terraform/0.12.24/terraform_0.12.24_linux_amd64.zip | unzip - &&\
	chmod +x ./terraform &&\
	./terraform -version

.terraform:
	./terraform init

plan:
	./terraform plan

force-apply:
	./terraform apply --auto-approve
