node {
    stage('pull-source') { 
        checkout([$class: 'GitSCM', branches: [[name: "*/master"]], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[credentialsId: 'c7e60db1-4689-46b7-92dc-1cd7ffcc3f16', url: 'git@github.com:chaitu-papa/petclinic.git']]])
   }
   stage('compile-unit-test') {
      // Run the gradle build
      if (isUnix()) {
        
         sh 'chmod +x gradlew'
         sh "./gradlew clean build"
		 
      } else {
         bat(/"gradlew.bat" clean build/)
      }
   }
   stage('code-coverage') {
      // Run the gradle build
      if (isUnix()) {
         sh 'chmod +x gradlew'
         sh "./gradlew jacocoTestReport"
      } else {
         bat(/"gradlew.bat" jacocoTestReport/)
      }
   }
    stage('code-analysis') {
      // Run the gradle sonar
      if (isUnix()) {
          withCredentials([string(credentialsId: 'sonar-token', variable: 'Sonar_token')]) {
        sh "./gradlew sonarqube -Dsonar.host.url=$env.SONAR_URL -Dsonar.login=$Sonar_token" }
       } else { 
         bat(/"gradlew.bat" clean build jacocoTestReport/)
      }
   }
    stage('artifact-publish') {
      // Run the gradle upload
      if (isUnix()) {
        env.SNAPSHOT="SNAPSHOT"
        env.BUILD_NUM="$env.BUILD_NUMBER"
        sh 'chmod +x gradlew'
        sh "./gradlew upload --info"
		 hygieiaBuildPublishStep buildStatus: 'InProgress'
         hygieiaArtifactPublishStep artifactDirectory: '/build/libs/', artifactGroup: "$group_id", artifactName: '*.war', artifactVersion: ''
      } else {
         bat(/"gradlew.bat" upload/)
      }
   }
}
node('Linux') {
    
     stage('bake-image') {
                 
      if (isUnix()) {
          withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'AWS', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]) { 
          checkout([$class: 'GitSCM', branches: [[name: "*/master"]], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[credentialsId: 'c7e60db1-4689-46b7-92dc-1cd7ffcc3f16', url: 'git@github.com:chaitu-papa/ansible-aws-playbooks.git']]])
		  ansiblePlaybook credentialsId: '14bd8691-b88a-427a-8488-cf28846b9820', installation: 'ansible', extras: '--extra-vars="env_name=$env_name"  --extra-vars="app_name=$app_name"  --extra-vars="sg_group_id=$sg_group"  --extra-vars="vpc_subnet_id=$subnet"  --extra-vars="instance_type=t2.micro" --extra-vars="ami_id=$ami_id"', playbook: 'provision-aws.yml', sudoUser: null
          ansiblePlaybook credentialsId: '14bd8691-b88a-427a-8488-cf28846b9820', installation: 'ansible',extras: '--extra-vars="app_version=1.0-SNAPSHOT" --extra-vars="env_name=$env_name" --extra-vars="group_id=$group_id"  --extra-vars="app_name=$app_name"', playbook: 'app-deploy.yml', sudoUser: null
          ansiblePlaybook credentialsId: '14bd8691-b88a-427a-8488-cf28846b9820', installation: 'ansible',  extras: '--extra-vars="env_name=$env_name" --extra-vars="AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID" --extra-vars="AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY" --extra-vars="app_name=$app_name" --extra-vars="env_name=$env_name" --extra-vars="app_version=1.0.$BUILD_NUMBER" ', playbook: 'amicreate.yml', sudoUser: null
          hygieiaBuildPublishStep buildStatus: 'InProgress'
		  hygieiaDeployPublishStep applicationName: "$app_name", artifactDirectory: '/build/libs/', artifactGroup: "$group_id", artifactName: '*.war', artifactVersion: '', buildStatus: 'InProgress', environmentName: "BAKE"
		  }} else {
        
         bat(/"gradlew.bat" deploy/)
      }
   
   }
   stage('DEV-Environment') {
      
       if (isUnix()) {
         withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'AWS', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]) { 
    
           checkout([$class: 'GitSCM', branches: [[name: "*/master"]], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[credentialsId: 'c7e60db1-4689-46b7-92dc-1cd7ffcc3f16', url: 'git@github.com:chaitu-papa/ansible-aws-playbooks']]])
           ansiblePlaybook credentialsId: '14bd8691-b88a-427a-8488-cf28846b9820', installation: 'ansible', extras: '--extra-vars="dns_name=$env_name" --extra-vars="alias_hosted_zone_id=$alias_hosted_zone_id" --extra-vars="min_instances=$min_instances" --extra-vars="max_instances=$max_instances" --extra-vars="cf_sg_group=$cf_sg_group" --extra-vars="AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID" --extra-vars="AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY" --extra-vars="app_name=$app_name" --extra-vars="env_name=$env_name" --extra-vars="cf_subnet=$cf_subnet"  --extra-vars="hosted_zone=$hosted_zone" --extra-vars="app_version=1.0.$BUILD_NUMBER" --extra-vars="InstanceType=$infra_type" --extra-vars="group_id=$group_id"', playbook: 'cf-aws.yml', sudoUser: null
           hygieiaBuildPublishStep buildStatus: 'InProgress'
		   hygieiaDeployPublishStep applicationName: "$app_name", artifactDirectory: '/build/libs/', artifactGroup: "$group_id", artifactName: '*.war', artifactVersion: '', buildStatus: 'InProgress', environmentName: "$env_name"
		   }} else {
        
         bat(/"gradlew.bat" deploy/)
      }
   
   }
}

