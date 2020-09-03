pipeline {
    agent any
    parameters {
        string(name: 'Project', defaultValue: 'MediaWiki', description: 'Deploy project using Terraform')
        choice(name: 'Environment', choices: ['QA', 'Staging'], description: 'Select Workspace Environment')
        booleanParam (name : 'RUN_PLAN_ONLY', defaultValue: true, description: 'Check Use to Run Terraform Plan Only. Uncheck to Run Apply/Destroy')
        choice(name: 'TERRAFORM_ACTION', choices: ['apply' , 'destroy'],  description: 'Do You Want to Apply or Destroy?')
        string(name: 'Branch', defaultValue: 'master', description: 'Enter Branch Name to Run')
    }
    stages {
        stage('CleanWorkspace'){
           steps {
              cleanWs()
              sh 'whoami'
           }
        }
        stage('Terraform Code Pull'){
           steps {
              git branch: '${Branch}', credentialsId: 'GIT_USER_PASSWORD', url: 'https://github.com/praveen-edulakanti/mediawiki.git'
           }
        }
        stage('Terraform Initialize'){
           steps {
              sh 'terraform init -var-file="./env/${Project}-${Environment}.tfvars"'
           }
        }
        stage('Select Workspace'){ 
           steps {
              sh 'terraform workspace new ${Project}-${Environment} || terraform workspace select ${Project}-${Environment}'
            }   
                
        }    
        stage('Terraform Plan'){
            environment {
             username = sh(script: 'echo $TF_VAR_username', , returnStdout: true).trim()
             password = sh(script: 'echo $TF_VAR_password', , returnStdout: true).trim()
            }
           steps {
              sh 'TF_VAR_username=${username} TF_VAR_password=${password}  terraform plan -var-file="./env/${Project}-${Environment}.tfvars" -out=${Project}-${Environment}tfplanout'
               }
        }
        stage('Terraform Apply') {
            when {
                expression { params.TERRAFORM_ACTION == 'apply' && params.RUN_PLAN_ONLY == false}
            }
            steps {
              sh 'terraform apply -auto-approve "${Project}-${Environment}"tfplanout'
            }    
        }
        stage('Terraform Destroy') {
            when {
                expression { params.TERRAFORM_ACTION == 'destroy' && params.RUN_PLAN_ONLY == false}
            }
            steps {
              sh 'terraform destroy -auto-approve -var-file="./env/${Project}-${Environment}.tfvars"'
            }    
        }
    }
}
