for i in * ; do
  if [ -d "$i" ]; then
    echo "Copying src for $i..."
		cd $i
		./copy_src.sh
		echo "Building $i..."
		docker build --no-cache -t $i:latest . 
		cd ..
  fi
done
