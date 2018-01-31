node {
    stage ('pull') {	
    checkout([$class: 'GitSCM', branches: [[name: '*/master']], doGenerateSubmoduleConfigurations: false, extensions: [[$class: 'RelativeTargetDirectory', relativeTargetDir: 'petclinic.git'], [$class: 'RelativeTargetDirectory', relativeTargetDir: 'ansible-aws-playbooks.git']], submoduleCfg: [], userRemoteConfigs: [[credentialsId: 'c7e60db1-4689-46b7-92dc-1cd7ffcc3f16', url: 'git@github.com:chaitu-papa/petclinic.git'], [credentialsId: 'c7e60db1-4689-46b7-92dc-1cd7ffcc3f16', url: 'git@github.com:chaitu-papa/ansible-aws-playbooks.git']]])
	}
	stage('compile-unit-test') {
      // Run the gradle build
      	if (isUnix()) {
		    sh 'chmod +x petclinic.git/gradlew'
        	sh 'cd petclinic.git;./gradlew clean build'
        	hygieiaBuildPublishStep buildStatus: 'InProgress'
      }
   }
   	stage('code-coverage') {
      // Run the gradle build
      	if (isUnix()) {   
            sh 'chmod +x petclinic.git/gradlew'   		
         	sh "cd petclinic.git;./gradlew jacocoTestReport"
      } 
   }
	stage('code-analysis') {
      // Run the gradle sonar
      	if (isUnix()) {
          withCredentials([string(credentialsId: 'sonar-token', variable: 'Sonar_token')]) {
		    sh 'chmod +x petclinic.git/gradlew'
        	sh "cd petclinic.git;./gradlew sonarqube -Dsonar.host.url=$env.SONAR_URL -Dsonar.login=$Sonar_token" }
        	hygieiaBuildPublishStep buildStatus: 'InProgress'
       } 
   }
   	stage('artifact-publish') {
      // Run the gradle upload
      	if (isUnix()) {
       		env.SNAPSHOT="SNAPSHOT"
        	env.BUILD_NUM="$env.BUILD_NUMBER"
			sh 'chmod +x petclinic.git/gradlew'
        	sh "cd petclinic.git;./gradlew upload --info"
        	hygieiaBuildPublishStep buildStatus: 'InProgress'
        	hygieiaArtifactPublishStep artifactDirectory: 'petclinic.git/build/libs/', artifactGroup: 'org.springframework.samples', artifactName: '*.war', artifactVersion: '1.0.$BUILD_NUMBER'
	      } 
   }
}


node('Linux') {
    
     stage('bake-image') {                 
      if (isUnix()) {
	     
         withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'AWS', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]) { 
			ansiblePlaybook credentialsId: '14bd8691-b88a-427a-8488-cf28846b9820', installation: 'ansible', extras: '--extra-vars="env_name=$env_name"  --extra-vars="app_name=$app_name"  --extra-vars="sg_group_id=$sg_group"  --extra-vars="vpc_subnet_id=$subnet"  --extra-vars="instance_type=t2.micro" --extra-vars="ami_id=$ami_id"', playbook: 'ansible-aws-playbooks.git/provision-aws.yml', sudoUser: null
			ansiblePlaybook credentialsId: '14bd8691-b88a-427a-8488-cf28846b9820', installation: 'ansible',extras: '--extra-vars="app_version=1.0-SNAPSHOT" --extra-vars="env_name=$env_name" --extra-vars="group_id=$group_id"  --extra-vars="app_name=$app_name"', playbook: 'app-deploy.yml', sudoUser: null
			ansiblePlaybook credentialsId: '14bd8691-b88a-427a-8488-cf28846b9820', installation: 'ansible',  extras: '--extra-vars="env_name=$env_name" --extra-vars="AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID" --extra-vars="AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY" --extra-vars="app_name=$app_name" --extra-vars="env_name=$env_name" --extra-vars="app_version=1.0.$BUILD_NUMBER" ', playbook: 'amicreate.yml', sudoUser: null
			hygieiaDeployPublishStep applicationName: "$app_name", artifactDirectory: 'petclinic.git/build/libs/', artifactGroup: 'org.springframework.samples', artifactName: '*.war', artifactVersion: '1.0.$BUILD_NUMBER', buildStatus: 'InProgress', environmentName: 'BAKE'        
		  } 
		}
    }
   stage('DEV-Environment') {      
       if (isUnix()) {
          withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'AWS', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]) { 
         // ansiblePlaybook credentialsId: '14bd8691-b88a-427a-8488-cf28846b9820', installation: 'ansible', extras: '--extra-vars="dns_name=$env_name" --extra-vars="alias_hosted_zone_id=$alias_hosted_zone_id" --extra-vars="min_instances=$min_instances" --extra-vars="max_instances=$max_instances" --extra-vars="cf_sg_group=$cf_sg_group" --extra-vars="AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID" --extra-vars="AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY" --extra-vars="app_name=$app_name" --extra-vars="env_name=$env_name" --extra-vars="cf_subnet=$cf_subnet"  --extra-vars="hosted_zone=$hosted_zone" --extra-vars="app_version=1.0.$BUILD_NUMBER" --extra-vars="InstanceType=$infra_type" --extra-vars="group_id=$group_id"', playbook: 'cf-aws.yml', sudoUser: null
          hygieiaDeployPublishStep applicationName: "$app_name", artifactDirectory: 'petclinic.git/build/libs/', artifactGroup: 'org.springframework.samples', artifactName: '*.war', artifactVersion: '1.0.$BUILD_NUMBER', buildStatus: 'InProgress', environmentName: 'DEV'     
		  }
       }
    }
}