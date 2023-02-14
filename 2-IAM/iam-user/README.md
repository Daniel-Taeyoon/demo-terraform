# IAM Example  
AWS 계정 생성 및 전파 시 작업이 반복된다. 
단순 반복 작업을 개선하고, 커뮤니케이션 효율화를 위해 Terraform으로 User 생성 후 계정 소유자에게 전달한다.

**Goals**  
- [x] IAM User 자동 생성  
- [x] User 초기 로그인 시 ChangePassword 설정
- [ ] User 정보 이메일 전송

**참고**  
- Github terraform-aws-iam : https://github.com/terraform-aws-modules/terraform-aws-iam/tree/v5.9.2