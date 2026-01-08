# ☸️ Oficina Mecânica - Infraestrutura Kubernetes

## 📋 Sobre o Projeto
Este repositório é o coração da infraestrutura de computação. Ele contém o código **Terraform** para provisionar o Cluster **AWS EKS (Elastic Kubernetes Service)** e toda a rede de suporte necessária (VPC).

É aqui que definimos onde a aplicação Backend irá rodar, garantindo alta disponibilidade e escalabilidade.

## 🚀 Recursos Provisionados
* **VPC (Virtual Private Cloud):**
    * Subnets Públicas (para Load Balancer e NAT Gateway).
    * Subnets Privadas (para os Nodes do EKS e Banco de Dados).
    * Internet Gateway & Route Tables.
* **EKS Cluster:** O Control Plane do Kubernetes.
* **EKS Node Groups:** Máquinas EC2 (Workers) que executam os Pods da aplicação.
* **IAM Roles:** Permissões de segurança para o cluster interagir com outros serviços AWS.

## ⚙️ Como Executar (Terraform)

### Pré-requisitos
* Terraform instalado.
* AWS CLI configurado.
* `kubectl` instalado (para testar a conexão após a criação).

### Passo a Passo
1.  **Inicializar:**
    ```bash
    terraform init
    ```

2.  **Validar e Planejar:**
    ```bash
    terraform validate
    terraform plan -out=tfplan
    ```

3.  **Provisionar:**
    ```bash
    terraform apply tfplan
    ```

4.  **Configurar acesso ao Cluster (Local):**
    Após a criação, configure seu `kubectl` para acessar o novo cluster:
    ```bash
    aws eks --region us-east-1 update-kubeconfig --name oficina-cluster
    ```

## ☁️ Integração Contínua
Este repositório possui validação automática via **GitHub Actions** (`terraform validate`) em Pull Requests para garantir a integridade do código antes do merge.
