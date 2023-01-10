# ECR / ECS Example  
AWS ECS는 Cluster를 한개 생성하고 해당 클러스터 하위로 여러 애플리케이션을 배포 할 수 있다.  
ECR의 경우 애플리케이션별로 Repository를 생성해줘야 한다.  

**Goals**  
- [ ] ECR 생성
- [ ] ECS Cluster
- [ ] ECS - Task Definitions
- [ ] ECS - Service
  - 위에서 생성한 Cluster, Task Definition을 활용해 Service를 생성한다.