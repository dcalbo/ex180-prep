#!/bin.bash
# Create pod with containers web and mysql

echo -n ". Creating pod webservice: "
podman pod create --name webservice \
  --publish 30306:3306/TCP \
  --publish 30080:30080/TCP \
  --publish 30000:8080/TCP 

sudo rm -rf work-msql

if [ ! -d "work-mysql" ]; then
  echo -n ". Creating database volume: "
  mkdir -p work-mysql/init work-mysql/data
  cp db.sql work-mysql/init
  podman unshare chown -R 27:27 work-mysql
else
  sudo rm -fr work-mysql/init
fi
echo "OK"

echo -n ". Launching database: "
podman run -d \
  --pod webservice \
  --name mysql \
  -e MYSQL_DATABASE=items \
  -e MYSQL_USER=user1 \
  -e MYSQL_PASSWORD=mypa55 \
  -e MYSQL_ROOT_PASSWORD=r00tpa55 \
  -v $PWD/work-mysql/data:/var/lib/mysql/data:Z \
  -v $PWD/work-mysql/init:/var/lib/mysql/init:Z \
  registry.redhat.io/rhel8/mysql-80:1 &>/dev/null
echo "OK"

echo -n ". Importing database: "
until podman exec -it mysql bash -c "mysql -u root -e 'show databases;'" &>/dev/null; do
  sleep 2
done

podman exec mysql bash \
  -c "cat /var/lib/mysql/init/db.sql | mysql -u root items"
echo "OK"

echo -n ". Launching To Do application: "
podman run -d \
  --pod webservice \
  --name todoapi \
  -e MYSQL_DATABASE=items \
  -e MYSQL_USER=user1 \
  -e MYSQL_PASSWORD=mypa55 \
  -e MYSQL_SERVICE_HOST="workstation.lab.example.com" \
  -e MYSQL_SERVICE_PORT=30306 \
  do180/todonodejs &>/dev/null

podman run -d \
  --pod webservice \
  --name todo_frontend \
  do180/todo_frontend &>/dev/null
echo "OK"