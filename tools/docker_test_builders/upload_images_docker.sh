aws ecr get-login-password --region $2 | docker login --username AWS --password-stdin $1.dkr.ecr.$2.amazonaws.com

for i in * ; do
  if [ -d "$i" ]; then
		echo Tagging image $i... 
		docker tag $i:latest $1.dkr.ecr.$2.amazonaws.com/$i:latest
		echo Pushing image $i... 
		docker push $1.dkr.ecr.$2.amazonaws.com/$i:latest
  fi
done
