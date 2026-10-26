<div align="center">
  <img src="./Blast-Radus%20Zero.jpeg" alt="Blast-Radius Zero Security Runestone" width="420" />
</div>
# Blast-Radius Zero: Secure Cloud Database Architecture

**Architect & Engineer:** Felicia (Fee) Lebeck (`Snoflake39`)  
**Discipline:** Cloud Infrastructure Security & Database Architecture  
**Core Stack:** AWS (VPC, RDS, KMS, Secrets Manager), Terraform, Debian Linux

## The Engineering Philosophy

Modern cloud security cannot rely on perimeter defense alone. "Blast-Radius Zero" is an Infrastructure-as-Code (IaC) deployment engineered under the assumption of breach. By decoupling identity from static credentials, enforcing cryptographic secrecy at rest with a Customer Managed Key (CMK), and isolating the database within an internet-void subnet, the data tier remains unreachable even if an edge asset is compromised.

## Architecture Flowchart

```mermaid
flowchart TD
    subgraph VPC ["AWS VPC (10.0.0.0/16) — Blast-Radius Zero"]
        direction TB
        Pub["Public Ingress Subnet\n(10.0.1.0/24)"]
        Comp["Private Compute Subnet\n(10.0.10.0/24)\nSecurity Group: compute-tier-sg"]
        
        subgraph Isolated ["Internet-Void Database Tier (Zero IGW / NAT Route)"]
            DB1[("MySQL RDS Primary\n(10.0.20.0/24)")]
            DB2[("MySQL RDS Standby\n(10.0.21.0/24)")]
        end

        Pub -->|Application Traffic| Comp
        Comp -->|"TCP 3306 ONLY\n(Chained SG ID)"| Isolated
    end

    KMS["AWS KMS\nCustomer Managed Key (CMK)\n(Annual Auto-Rotation)"]
    SM["AWS Secrets Manager\n(30-Day Automated Rotation)"]

    KMS -.->|"Encrypts Storage & Snapshots"| Isolated
    SM -.->|"Rotates Master Credentials"| Isolated

    style VPC fill:#0d1117,stroke:#00F0FF,stroke-width:2px,color:#fff
    style Isolated fill:#1a0b2e,stroke:#FF007F,stroke-width:2px,color:#fff
    style Comp fill:#161b22,stroke:#A020F0,stroke-width:2px,color:#fff
    style Pub fill:#161b22,stroke:#00F0FF,stroke-width:1px,color:#fff
    style KMS fill:#0d1117,stroke:#39FF14,stroke-width:2px,color:#fff
    style SM fill:#0d1117,stroke:#FF007F,stroke-width:2px,color:#fff
```

## Modular Architecture

* `versions.tf` — Enforces Terraform `>= 1.5.0` and locks the `hashicorp/aws` `~> 5.0` provider.
* `vpc.tf` — Provisions a three-tier VPC (`10.0.0.0/16`) with Public, Private Compute, and Isolated Database subnets (`10.0.20.0/24`, `10.0.21.0/24`) with zero routes to the Internet Gateway or NAT Gateway.
* `security.tf` — Implements Security Group chaining so TCP port `3306` only accepts traffic originating from the Compute Tier Security Group ID.
* `database.tf` — Deploys an encrypted MySQL RDS instance backed by a rotating AWS KMS Customer Managed Key and automated 30-day credential rotation via AWS Secrets Manager.

## Validation

Run `terraform init` and `terraform validate` to verify syntax and module integrity.
