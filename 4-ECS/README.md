# ECR / ECS Example  
AWS ECS 인프라는 "Cluster -> Task -> Service" 순서로 이뤄져야 한다.
Cluster를 생성하고 해당 클러스터 하위로 여러 Service(애플애플리케이션)을 배포 할 수 있다.  
ECS Service는 Task기반으로 동작하며, 코드로 동작하기 위해서는 아래 Goals 순서대로 생성하면 된다.  
<br></br>
AWS ECS Cluster 생성 시 Networking을 구축해야 되지만, Terraform으로 구축 시 해당 내용이 빠져있다.  
Service 생성 시 VPC, Subnet을 지정해주는 것 같은데 해당 내용은 실습해보면서 알아간다.   
<br></br>

# 각 Service 생성별 필수 정보  
Task  
- Step 1) Configure task definition and containers
  - "Task definition family", "Container" 정보를 작성한다.
  - Container 정보는 ECR ImageURI, Name, Container port 정보를 작성한다.
- Step 2) Configure environment, storage, monitoring, and tags
  - "Environment", "Storage" 정보 등을 작성한다.
  - Environment는 App environment(ex. AWS Fargate, EC2), OS, CPU(ex. 1vCPU), Memory(ex. 3GB)를 작성한다.  

Service
- Step 1) Task 연결

**Goals**  
- [x] ECS Cluster
- [x] ECS - Task Definitions
- [ ] ECS - Service
  - 위에서 생성한 Cluster, Task Definition을 활용해 Service를 생성한다.
  - ALB, Target Group, Security Group이 생성되어 있어야 Service를 추가 할 수 있다.  

**_참고_**  
ECS Service "network_configuration" : https://www.architect.io/blog/2021-03-30/create-and-manage-an-aws-ecs-cluster-with-terraform/