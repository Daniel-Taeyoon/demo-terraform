# ECR / ECS Example  
AWS ECS는 Cluster를 한개 생성하고 해당 클러스터 하위로 여러 애플리케이션을 배포 할 수 있다.  
ECS Service는 Task기반으로 동작하며, 코드로 동작하기 위해서는 아래 Goals 순서대로 생성하면 된다.
ECS

**Goals**  
- [ ] ECS Cluster
- [ ] ECS - Task Definitions
- [ ] ECS - Service
  - 위에서 생성한 Cluster, Task Definition을 활용해 Service를 생성한다.
  - ALB, Target Group, Security Group은 생성되어 있어야 Service를 추가할 수 있다.