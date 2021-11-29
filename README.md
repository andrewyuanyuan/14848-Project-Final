# 14848-project

* The deployment files (including deploying images and creating services files) and the Dockerfiles are included in [deployment-files-and-dockerfiles](https://github.com/andrewyuanyuan/14848-project/tree/main/deployment-files-and-dockerfiles) folder.
* All the source code I wrote are inside the [source-code](https://github.com/andrewyuanyuan/14848-project/tree/main/source-code) folder (including source code for `sonar-scanner`and my `terminal-application`

## Reference

* Hadoop

  The base image I adopted for `Hadoop` are [bde2020/hadoop-datanode](https://hub.docker.com/r/bde2020/hadoop-datanode) and [bde2020/hadoop-namenode](https://hub.docker.com/r/bde2020/hadoop-namenode)

* Spark

  The base image I adopted for `Spark` is  [bitnami/spark](bitnami/spark)

* Sonarqube and Sonar scanner

  The base image I adopted for `Sonarqube and Sonar scanner` is  [sonarqube](https://hub.docker.com/_/sonarqube)

* Jupyter notebook

  The base image I adopted for `Jupyter notebook` is [jupyter/base-notebook](https://hub.docker.com/r/jupyter/base-notebook)

## Docker Images used

* Hadoop: [anyuanyu/hadoop-datanode](https://hub.docker.com/repository/docker/anyuanyu/hadoop-datanode) and [anyuanyu/hadoop-namenode](https://hub.docker.com/r/anyuanyu/hadoop-namenode)

* Spark: [bitnami/spark](bitnami/spark)

* Sonarqube and Sonar scanner: [anyuanyu/sonarqubescanner](https://hub.docker.com/r/anyuanyu/sonarqubescanner) (source code under [source-code](https://github.com/andrewyuanyuan/14848-project/tree/main/source-code) folder)

* Jupyter notebook: [jupyter/base-notebook](https://hub.docker.com/r/jupyter/base-notebook)

* Terminal application: [anyuanyu/project-terminal-application](anyuanyu/project-terminal-application) (source code under [source-code](https://github.com/andrewyuanyuan/14848-project/tree/main/source-code) folder)

## Steps to get application work

### Configure, build and upload my Docker images

For **Jupyter notebook** and **Spark**, we can just pull their official images in GCP from docker hub.

For **Hadoop**, I included all the environment variables in my Dockerfiles to make it runnable on GCP. You can see more details in the Dockerfile in [deployment-files-and-dockerfiles](https://github.com/andrewyuanyuan/14848-project/tree/main/deployment-files-and-dockerfiles) folder.

For **SonarQube**, in order to run it in GCP, I built it upon the source code of this [project](https://hub.docker.com/_/sonarqube), customize my Dockerfile and build my own image.

For **terminal application**, I used React to build it frontend interface.

You can see all the Dockerfiles and source codes in my repository.

### Create my own GKE Kubernetes cluster

In this step, I simply used the Kubernetes cluster I created at the beginning of this semester as the following picture shows.

![1](https://github.com/andrewyuanyuan/14848-project/blob/main/screenshots/1.png?raw=true)

It is also very simple if you want to create your own cluster following the steps below:

1. Go to the Kubernetes Engine in GKE and click on create
2. Configure your clusters

### Push my docker images to Container Registry

I used the following docker images in this step, you can check each of them by clicking on the link in the `Docker Images used` section.

```
anyuanyu/hadoop-datanode
anyuanyu/hadoop-namenode
anyuanyu/sonarqubescanner
anyuanyu/project-terminal-application
jupyter/base-notebook
bitnami/spark
```

The process of deploying is quite similar by using the following commands.

```bash
docker pull anyuanyu/[image name]

docker tag anyuanyu/[image name] gcr.io/[project name]/anyuanyu/[image name]

docker push gcr.io/[project name]/anyuanyu/[image name]
```

After running these commands, you can see all the images in your `Container Registry`, as the pictures shown below.

![2](https://github.com/andrewyuanyuan/14848-project/blob/main/screenshots/2.png?raw=true)

![3](https://github.com/andrewyuanyuan/14848-project/blob/main/screenshots/3.png?raw=true)

### Deploying my docker images to GKE Kubernetes Cluster

We have two ways to finish this deployment, one is using the GUI provided by Google Cloud Platform and the other is using the `deployment.yaml` file. I tried both of them in this project.

#### Path 1: Deploying by GUI

This path is quite straightforward.

1. Enter the image details page in `Container Registry`, click `deploy`

   ![4](https://github.com/andrewyuanyuan/14848-project/blob/main/screenshots/4.png?raw=true)

2. Configure your image. In my case, I only need to change the application name.

   ![5](https://github.com/andrewyuanyuan/14848-project/blob/main/screenshots/5.png?raw=true)

3. By this way, you can see your images transferred to the `Workloads` in `Kubernetes Engine`. **Here is all the images I deployed on Kubernetes Engine.**

   ![6](https://github.com/andrewyuanyuan/14848-project/blob/main/screenshots/6.png?raw=true)

#### Path 2: Using deployment.yaml to deploy

This path needs some work to write the `deployment.yaml` file, but next time you want to deploy an image, you can just reuse that file. The command is:

```bash
kubectl apply -f [image name]-deployment.yaml
```

You can see all my deployment files in [deployment-files-and-dockerfiles](https://github.com/andrewyuanyuan/14848-project/tree/main/deployment-files-and-dockerfiles) folder.

### Expose containers as Services

This step can also be done in two paths.

#### Path 1: Exposing using the GUI

Click the individual workload in `Workloads` page, if an image has not been exposed yet, there will be an option at the top of the page. If you choose to `Expose`, GKE would ask you to configure its `Port`, `Target Port`, `Protocal` and `Service type`. 

Here I choose to **expose four worker images (Hadoop, Spark, Jupyter notebook and Sonarqube) as `NodePort`** so that they always has the same IP address with different ports. 

**As for the terminal application, I choose to expose it as work balancer.**

**Here is all the services I created, and you can see their port configuration in the screenshot below.**

![7](https://github.com/andrewyuanyuan/14848-project/blob/main/screenshots/7.png?raw=true)

Besides, After creating these services, we also need to set the firewall rules in the cloud shell or `firewall` of GKE for each service. We can obtain node ports by clicking the service name. For example, for our `jupyter-notebook-service`, the port is `30963`.

![8](https://github.com/andrewyuanyuan/14848-project/blob/main/screenshots/8.png?raw=true)

Then we use the command below to set up firewall rules for this service.

```bash
gcloud compute firewall-rules create jupyter-notebook-service --allow tcp: 3-30963
```

After these step, we can use `kubectl get nodes -o wide` to get our service IP, where we can see all the available node and their IPs. Then, by enter `NodeIP:NodePort` in your browser, you can access the service. E.g. In my case, the service address for Jupyter-notebook-service is `http://34.135.237.146:30963/`

![9](https://github.com/andrewyuanyuan/14848-project/blob/main/screenshots/9.png?raw=true)

#### Path 2: Using service.yaml to expose

Similar to deploying images, we can use the command below after we configure the `service.yaml` files for each images.

```
kubectl apply -f [image name]-service.yaml
```

You can see all my service-creating files in [deployment-files-and-dockerfiles](https://github.com/andrewyuanyuan/14848-project/tree/main/deployment-files-and-dockerfiles) folder.

## Application Demo

After all the steps above, we now have five services and we can run them now. 

#### Terminal application

My external IP address for my terminal application is `34.135.79.151:80`

![10](https://github.com/andrewyuanyuan/14848-project/blob/main/screenshots/10.png?raw=true)

![11](https://github.com/andrewyuanyuan/14848-project/blob/main/screenshots/11.png?raw=true)

You can click the items in the toolbox to access them.

#### Jupyter Notebook

The IP address for my Jupyter Notebook is `http://34.135.237.146:30963/`

![12](https://github.com/andrewyuanyuan/14848-project/blob/main/screenshots/12.png?raw=true)

#### Spark

The IP address for my Spark service is `http://34.135.237.146:31749/`

![13](https://github.com/andrewyuanyuan/14848-project/blob/main/screenshots/13.png?raw=true)

#### Hadoop

The IP address for my Spark service is `http://34.135.237.146:30070/`, which has two namenodes

![14](https://github.com/andrewyuanyuan/14848-project/blob/main/screenshots/14.png?raw=true)

![15](https://github.com/andrewyuanyuan/14848-project/blob/main/screenshots/15.png?raw=true)

#### SonarQube

The IP address for my Spark service is `http://34.135.237.146:30299/`

![16](https://github.com/andrewyuanyuan/14848-project/blob/main/screenshots/16.png?raw=true)

