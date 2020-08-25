pipeline {
    agent any
    parameters {
        string(name: 'Project', defaultValue: 'MediaWiki', description: 'Deploy project using Terraform')
        choice(name: 'Environment', choices: ['QA', 'Staging'], description: 'Select Workspace Environment')
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
           steps {
              sh 'terraform plan -var-file="./env/${Project}-${Environment}.tfvars" -out=${Project}-${Environment}tfplanout'
               }
        }
        stage('Terraform Apply') { 
            steps {
             sh 'terraform apply -auto-approve "${Project}-${Environment}"tfplanout'
            }    
        }
    }    
}
