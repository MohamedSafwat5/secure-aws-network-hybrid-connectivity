# secure-aws-network-hybrid-connectivity

Designed and implemented a secure AWS network architecture with hybrid connectivity, including VPC, subnets, routing, security controls, and connectivity between AWS and an on-premises network.


# Network Architecture

## 1. Overview

The project uses a custom AWS VPC architecture designed to separate public-facing resources, application servers, and database resources.

The infrastructure is managed using Terraform.

## 2. VPC Configuration

| Property           | Value                  |
| ------------------ | ---------------------- |
| VPC Name           | secure-network-vpc     |
| CIDR Block         | 10.0.0.0/16            |
| AWS Region         | us-east-1              |
| Availability Zones | us-east-1a, us-east-1b |
| DNS Support        | Enabled                |
| DNS Hostnames      | Enabled                |

## 3. Subnet Architecture

The VPC contains six subnets distributed across two Availability Zones.

| Subnet          | CIDR Block   | Availability Zone | Tier        |
| --------------- | ------------ | ----------------- | ----------- |
| Public Subnet A | 10.0.1.0/24  | us-east-1a        | Public      |
| Public Subnet B | 10.0.2.0/24  | us-east-1b        | Public      |
| App Subnet A    | 10.0.11.0/24 | us-east-1a        | Application |
| App Subnet B    | 10.0.12.0/24 | us-east-1b        | Application |
| DB Subnet A     | 10.0.21.0/24 | us-east-1a        | Database    |
| DB Subnet B     | 10.0.22.0/24 | us-east-1b        | Database    |

## 4. Routing Architecture

Three dedicated route tables are configured:

- **Public Route Table:** Associated with both public subnets. Routes internet-bound traffic through the Internet Gateway.
- **Private App Route Table:** Associated with both application subnets. Currently contains only the local VPC route.
- **Private DB Route Table:** Associated with both database subnets. Currently contains only the local VPC route.

An Internet Gateway is attached to the VPC.

NAT Gateway has not been deployed yet.

## 5. Security Groups

Three Security Groups have been configured.

| Security Group          | Inbound Rule | Source             |
| ----------------------- | ------------ | ------------------ |
| ALB Security Group      | TCP 80       | 0.0.0.0/0          |
| App Security Group      | TCP 80       | ALB Security Group |
| Database Security Group | TCP 5432     | App Security Group |

The database rule currently assumes PostgreSQL as the database engine.

## 6. Terraform Outputs

The following outputs are available for other project components:

- `vpc_id`
- `public_subnet_ids`
- `app_subnet_ids`
- `db_subnet_ids`
- `alb_security_group_id`
- `app_security_group_id`
- `database_security_group_id`

These outputs allow other team members to reference existing infrastructure without manually entering resource IDs.

## 7. Terraform Files

| File               | Responsibility                                   |
| ------------------ | ------------------------------------------------ |
| backend.tf         | Terraform backend and AWS provider configuration |
| network.tf         | VPC, subnets, Internet Gateway and route tables  |
| security-groups.tf | Network security rules                           |
| outputs.tf         | Infrastructure outputs                           |

## 8. Infrastructure Validation

The infrastructure was validated using:

- `terraform fmt`
- `terraform validate`
- `terraform plan`
- `terraform apply`

The latest Terraform plan confirmed:

`No changes. Your infrastructure matches the configuration.`
