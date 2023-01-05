# IAM Example  
AWS 계정 생성 및 전파 시 작업이 반복된다. 단순 반복 작업을 개선하고, 커뮤니케이션 효율화를 위해 Terraform으로 User 생성하고 해당 담당자에게 전파한다.  

**Goals**  
- [x] IAM User 자동 생성  
- [x] User 초기 로그인 시 ChangePassword 설정
- [ ] User 정보 Group에 자동 Mapping
- [ ] User 정보 이메일 전송

**Prerequisites**  
Local에서 "Keybase 설치" 필요. why? 사용자의 민감정보(ex. profile_password, aws_secret_access_key 등)를 암호화해서 송수신.  
1. Homebrew 활용한 Keybase 설치  
   ```
    brew install keybase
   ```
   
2. keybase 계정 생성(https://keybase.io/)
3. Local PC Keybase 환경 셋팅
    ```
    brew install keybase
    ```
    - Keybase 사이트에서 생성한 User 정보를 입력한다.

### Decrypt Password  
output “keybase_password_decrypt_command” 출력값을 복호화 한다.  

**참고**  
- Github terraform-aws-iam : https://github.com/terraform-aws-modules/terraform-aws-iam/tree/v5.9.2