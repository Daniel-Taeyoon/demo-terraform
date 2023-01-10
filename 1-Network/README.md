# Network Example
VPC, Subnet(Public, Private), Internet Gateway, Elastic IP, NAT 등을 하나씩 생성하면 많은 시간 소요가 걸린다.  
또한, 설정값을 잘못 셋팅 할 수도 있다.  
따라서 Network 셋팅 작업을 자동화 함으로써 Infra 관리를 효율화시키자. 

**Goals**  
- [x] Network망 구축 : VPC, Subnet(~~Public~~, ~~ECS~~, ~~DB~~)
- [x] Internet Gateway
- [x] Route Table(~~Public~~, ~~ECS~~, ~~DB~~)
- [x] Elastic IP
- [x] NAT(Public Subnet에 생성)