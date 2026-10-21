# Evidence: Parts 1–4 and the CS 554 Readiness Experiment

## Part 1 — Small Web Service and Docker Image

### 1.1 Service tests and environment-variable configuration — host

```text
yuxuan@yuxuan-Alienware-x15-R1:~/Desktop/cs454_midterm_Yuxuan$ node -v
v22.23.3
```

```text
yuxuan@yuxuan-Alienware-x15-R1:~/Desktop/cs454_midterm_Yuxuan$ npm -v
10.9.9
```

```text
yuxuan@yuxuan-Alienware-x15-R1:~/Desktop/cs454_midterm_Yuxuan$ npm test

> cs454-midterm-starter@1.0.0 test
> node --test test/service.test.js

{"method":"GET","path":"/","status":200}
{"method":"GET","path":"/health","status":200}
{"method":"GET","path":"/","status":200}
{"method":"GET","path":"/missing","status":404}
{"method":"GET","path":"/","status":200}
✔ configured responses, local counter, health, and fresh instance (39.330684ms)
ℹ tests 1
ℹ suites 0
ℹ pass 1
ℹ fail 0
ℹ cancelled 0
ℹ skipped 0
ℹ todo 0
ℹ duration_ms 113.161705
```

```text
yuxuan@yuxuan-Alienware-x15-R1:~/Desktop/cs454_midterm_Yuxuan$ npm start

> cs454-midterm-starter@1.0.0 start
> node src/server.js

Listening on port 8080
{"method":"GET","path":"/","status":200}
{"method":"GET","path":"/health","status":200}
{"method":"GET","path":"/","status":200}
{"method":"GET","path":"/","status":200}
{"method":"GET","path":"/health","status":200}
{"method":"GET","path":"/","status":200}
^CReceived SIGINT; stopping.

```

```text
yuxuan@yuxuan-Alienware-x15-R1:~/Desktop/cs454_midterm_Yuxuan$ PORT=8090 SERVICE_NAME=cs554-midterm MESSAGE="Hello from CS554" npm start

> cs454-midterm-starter@1.0.0 start
> node src/server.js

Listening on port 8090
{"method":"GET","path":"/","status":200}
{"method":"GET","path":"/health","status":200}
^CReceived SIGINT; stopping.

```

### 1.2 Dockerfile and image build — host

```text
yuxuan@yuxuan-Alienware-x15-R1:~/Desktop/cs454_midterm_Yuxuan$ cat Dockerfile
FROM node:22.23.3-bookworm-slim

WORKDIR /app

COPY --chown=node:node package.json ./
COPY --chown=node:node src/ ./src/

USER node

EXPOSE 8080

CMD ["node", "src/server.js"]
```

```text
yuxuan@yuxuan-Alienware-x15-R1:~/Desktop/cs454_midterm_Yuxuan$ sudo docker build -t cs554-midterm:v1 .
[sudo] password for yuxuan: 
[+] Building 3.9s (9/9) FINISHED                                                                                                                                                             docker:default
 => [internal] load build definition from Dockerfile                                                                                                                                                   0.0s
 => => transferring dockerfile: 215B                                                                                                                                                                   0.0s
 => [internal] load metadata for docker.io/library/node:22.23.3-bookworm-slim                                                                                                                          0.6s
 => [internal] load .dockerignore                                                                                                                                                                      0.0s
 => => transferring context: 137B                                                                                                                                                                      0.0s
 => [1/4] FROM docker.io/library/node:22.23.3-bookworm-slim@sha256:c3de60bf2f9dd0ac6370e6117950ff62d6e339527e7472301c9c78a017978392                                                                    3.2s
 => => resolve docker.io/library/node:22.23.3-bookworm-slim@sha256:c3de60bf2f9dd0ac6370e6117950ff62d6e339527e7472301c9c78a017978392                                                                    0.0s
 => => sha256:f0400f4b55b0ad346bf6167a1b64a258e4d73db608c457798ce35e4ffeebfaaf 3.31kB / 3.31kB                                                                                                         0.2s
 => => sha256:d22c69a95cf463f4cb74462bd2899597ce505d82bd4c01ceddf7845e12f13856 49.84MB / 49.84MB                                                                                                       2.1s
 => => sha256:c3de60bf2f9dd0ac6370e6117950ff62d6e339527e7472301c9c78a017978392 5.22kB / 5.22kB                                                                                                         0.0s
 => => sha256:efd0ab5780c2d9ab1f0f869571a00d5edb17793bff4cce4a2792e3eb0ffc7562 1.93kB / 1.93kB                                                                                                         0.0s
 => => sha256:d0a16be756b6ec6658aecb8b7bcf87fa6c7d0d7fcc6ca53ad14bb49a4c90bdd7 6.77kB / 6.77kB                                                                                                         0.0s
 => => sha256:7fd1ebe418b5079d4aa36f416af9b143d127bc75b0155d71cb5fd559b5e04d39 28.25MB / 28.25MB                                                                                                       0.9s
 => => sha256:2cfab517365cfc6b4bd1f8c4cb01754884ef75bc38758b3c41e291c696f019f5 1.71MB / 1.71MB                                                                                                         0.6s
 => => sha256:a8de9fa052209313d8e45435a8486e29b20eebaa820e2e7f63a7c3c94b4fa567 448B / 448B                                                                                                             0.7s
 => => extracting sha256:7fd1ebe418b5079d4aa36f416af9b143d127bc75b0155d71cb5fd559b5e04d39                                                                                                              0.7s
 => => extracting sha256:f0400f4b55b0ad346bf6167a1b64a258e4d73db608c457798ce35e4ffeebfaaf                                                                                                              0.0s
 => => extracting sha256:d22c69a95cf463f4cb74462bd2899597ce505d82bd4c01ceddf7845e12f13856                                                                                                              0.9s
 => => extracting sha256:2cfab517365cfc6b4bd1f8c4cb01754884ef75bc38758b3c41e291c696f019f5                                                                                                              0.0s
 => => extracting sha256:a8de9fa052209313d8e45435a8486e29b20eebaa820e2e7f63a7c3c94b4fa567                                                                                                              0.0s
 => [internal] load build context                                                                                                                                                                      0.0s
 => => transferring context: 2.10kB                                                                                                                                                                    0.0s
 => [2/4] WORKDIR /app                                                                                                                                                                                 0.1s
 => [3/4] COPY --chown=node:node package.json ./                                                                                                                                                       0.0s
 => [4/4] COPY --chown=node:node src/ ./src/                                                                                                                                                           0.0s
 => exporting to image                                                                                                                                                                                 0.0s
 => => exporting layers                                                                                                                                                                                0.0s
 => => writing image sha256:2eb6adeaa9ef93513f8b04e076fcc9bf598d9d4f885f7542b238256f980476a9                                                                                                           0.0s
 => => naming to docker.io/library/cs554-midterm:v1                                                                                                                                                    0.0s
```

### 1.3 Container status, HTTP responses, and logs — host

```text
yuxuan@yuxuan-Alienware-x15-R1:~/Desktop/cs454_midterm_Yuxuan$ sudo docker run -d \
  --name cs554-part1 \
  -p 127.0.0.1:8080:8080 \
  cs554-midterm:v1
889f45a443e446a0e1a9e6624142e315ca5fd412f474efcd2f97b60f28b5fd9c
```

```text
yuxuan@yuxuan-Alienware-x15-R1:~/Desktop/cs454_midterm_Yuxuan$ sudo docker ps --filter name=cs554-part1
CONTAINER ID   IMAGE              COMMAND                  CREATED          STATUS          PORTS                      NAMES
889f45a443e4   cs554-midterm:v1   "docker-entrypoint.s…"   11 seconds ago   Up 11 seconds   127.0.0.1:8080->8080/tcp   cs554-part1
```

```text
yuxuan@yuxuan-Alienware-x15-R1:~/Desktop/cs454_midterm_Yuxuan$ curl -i -w '\n' http://localhost:8080/
HTTP/1.1 200 OK
Content-Type: application/json
Date: Sun, 18 Oct 2026 22:01:15 GMT
Connection: keep-alive
Keep-Alive: timeout=5
Transfer-Encoding: chunked

{"service":"cs454-midterm","message":"Hello from the mini-project!","hostname":"889f45a443e4","requestCount":1}
```

```text
yuxuan@yuxuan-Alienware-x15-R1:~/Desktop/cs454_midterm_Yuxuan$ curl -i -w '\n' http://localhost:8080/health
HTTP/1.1 200 OK
Content-Type: application/json
Date: Sun, 18 Oct 2026 22:01:23 GMT
Connection: keep-alive
Keep-Alive: timeout=5
Transfer-Encoding: chunked

{"status":"ok"}
```

```text
yuxuan@yuxuan-Alienware-x15-R1:~/Desktop/cs454_midterm_Yuxuan$ sudo docker logs cs554-part1
Listening on port 8080
{"method":"GET","path":"/","status":200}
{"method":"GET","path":"/health","status":200}
```

## Part 2 — Docker Compose Inside the Linux VM

### 2.1 VM driver, creation, address, and Compose version

```text
yuxuan@yuxuan-Alienware-x15-R1:~/Desktop/cs454_midterm_Yuxuan$ multipass get local.driver
qemu
```

```text
yuxuan@yuxuan-Alienware-x15-R1:~/Desktop/cs454_midterm_Yuxuan$ multipass launch 24.04 \
  --name cs554-midterm \
  --cpus 4 \
  --memory 4G \
  --disk 30G
Launched: cs554-midterm
```

```text
yuxuan@yuxuan-Alienware-x15-R1:~/Desktop/cs454_midterm_Yuxuan$ multipass info cs554-midterm
Name:           cs554-midterm
State:          Running
Snapshots:      0
IPv4:           10.213.186.117
Release:        Ubuntu 24.04.5 LTS
Image hash:     04e8f2461a16 (Ubuntu 24.04 LTS)
CPU(s):         4
Load:           0.00 0.00 0.00
Disk usage:     1.9GiB out of 29.0GiB
Memory usage:   407.6MiB out of 3.8GiB
Mounts:         --
```

```text
ubuntu@cs554-midterm:~$ hostname
cs554-midterm
```

```text
ubuntu@cs554-midterm:~$ sudo docker compose version
Docker Compose version v5.6.0
```

### 2.2 Transfer and load the same application image

```text
yuxuan@yuxuan-Alienware-x15-R1:~/Desktop/cs454_midterm_Yuxuan$ sudo docker save cs554-midterm:v1 > ~/cs554-midterm-v1.tar
[sudo] password for yuxuan: 
```

```text
yuxuan@yuxuan-Alienware-x15-R1:~/Desktop/cs454_midterm_Yuxuan$ ls -lh ~/cs554-midterm-v1.tar
-rw-rw-r-- 1 yuxuan yuxuan 222M Oct 18 21:29 /home/yuxuan/cs554-midterm-v1.tar
```

```text
yuxuan@yuxuan-Alienware-x15-R1:~/Desktop/cs454_midterm_Yuxuan$ multipass transfer ~/cs554-midterm-v1.tar cs554-midterm:/home/ubuntu/cs554-midterm-v1.tar
```

```text
ubuntu@cs554-midterm:~$ ls -lh ~/cs554-midterm-v1.tar
-rw-rw-r-- 1 ubuntu ubuntu 222M Oct 18 21:32 /home/ubuntu/cs554-midterm-v1.tar
```

```text
ubuntu@cs554-midterm:~$ sudo docker load -i ~/cs554-midterm-v1.tar
Loaded image: cs554-midterm:v1
```

```text
ubuntu@cs554-midterm:~$ sudo docker image ls cs554-midterm:v1
                                                                                                                                                                                        i Info →   U  In Use
IMAGE              ID             DISK USAGE   CONTENT SIZE   EXTRA
cs554-midterm:v1   542310d2b52a        479MB          232MB        
```

### 2.3 Compose configuration, transfer, and validation

```text
yuxuan@yuxuan-Alienware-x15-R1:~/Desktop/cs454_midterm_Yuxuan$ cat > compose.yaml <<'EOF'
services:
  web:
    image: cs554-midterm:v1
    pull_policy: never
    environment:
      PORT: "8080"
      SERVICE_NAME: "cs554-midterm-compose"
      MESSAGE: "Hello from Docker Compose inside the VM!"
    ports:
      - "8080:8080"
EOF
```

```text
yuxuan@yuxuan-Alienware-x15-R1:~/Desktop/cs454_midterm_Yuxuan$ multipass transfer --parents compose.yaml cs554-midterm:/home/ubuntu/cs554-midterm/compose.yaml
```

```text
ubuntu@cs554-midterm:~$ cd ~/cs554-midterm
```

```text
ubuntu@cs554-midterm:~/cs554-midterm$ sudo docker compose config
name: cs554-midterm
services:
  web:
    environment:
      MESSAGE: Hello from Docker Compose inside the VM!
      PORT: "8080"
      SERVICE_NAME: cs554-midterm-compose
    image: cs554-midterm:v1
    networks:
      default: null
    pull_policy: never
    ports:
      - mode: ingress
        target: 8080
        published: "8080"
        protocol: tcp
networks:
  default:
    name: cs554-midterm_default
```

### 2.4 Compose startup, status, both HTTP endpoints, and logs — VM

```text
ubuntu@cs554-midterm:~/cs554-midterm$ sudo docker compose up -d
[+] up 2/2
 ✔ Network cs554-midterm_default Created                                                                                                                                                                0.0s
 ✔ Container cs554-midterm-web-1 Started                                                                                                                                                                0.2s
```

```text
ubuntu@cs554-midterm:~/cs554-midterm$ sudo docker compose ps
NAME                  IMAGE              COMMAND                  SERVICE   CREATED         STATUS         PORTS
cs554-midterm-web-1   cs554-midterm:v1   "docker-entrypoint.s…"   web       7 seconds ago   Up 7 seconds   0.0.0.0:8080->8080/tcp, [::]:8080->8080/tcp
```

```text
ubuntu@cs554-midterm:~/cs554-midterm$ curl -i -w '\n' http://localhost:8080/
HTTP/1.1 200 OK
Content-Type: application/json
Date: Mon, 19 Oct 2026 02:52:56 GMT
Connection: keep-alive
Keep-Alive: timeout=5
Transfer-Encoding: chunked

{"service":"cs554-midterm-compose","message":"Hello from Docker Compose inside the VM!","hostname":"95b02f2d2fe6","requestCount":1}
```

```text
ubuntu@cs554-midterm:~/cs554-midterm$ curl -i -w '\n' http://localhost:8080/health
HTTP/1.1 200 OK
Content-Type: application/json
Date: Mon, 19 Oct 2026 02:53:17 GMT
Connection: keep-alive
Keep-Alive: timeout=5
Transfer-Encoding: chunked

{"status":"ok"}
```

```text
ubuntu@cs554-midterm:~/cs554-midterm$ sudo docker compose logs --no-color web
web-1  | Listening on port 8080
web-1  | {"method":"GET","path":"/","status":200}
web-1  | {"method":"GET","path":"/health","status":200}
```

### 2.5 Host-to-VM HTTP request and network route

```text
yuxuan@yuxuan-Alienware-x15-R1:~/Desktop/cs454_midterm_Yuxuan$ multipass info cs554-midterm
Name:           cs554-midterm
State:          Running
Snapshots:      0
IPv4:           10.213.186.117
                172.17.0.1
                172.18.0.1
Release:        Ubuntu 24.04.5 LTS
Image hash:     04e8f2461a16 (Ubuntu 24.04 LTS)
CPU(s):         4
Load:           0.00 0.00 0.00
Disk usage:     3.0GiB out of 29.0GiB
Memory usage:   509.9MiB out of 3.8GiB
Mounts:         --
```

```text
yuxuan@yuxuan-Alienware-x15-R1:~/Desktop/cs454_midterm_Yuxuan$ curl -i -w '\n' http://10.213.186.117:8080/
HTTP/1.1 200 OK
Content-Type: application/json
Date: Mon, 19 Oct 2026 03:00:05 GMT
Connection: keep-alive
Keep-Alive: timeout=5
Transfer-Encoding: chunked

{"service":"cs554-midterm-compose","message":"Hello from Docker Compose inside the VM!","hostname":"95b02f2d2fe6","requestCount":2}
```

```text
yuxuan@yuxuan-Alienware-x15-R1:~/Desktop/cs454_midterm_Yuxuan$ ip route get 10.213.186.117
10.213.186.117 dev mpqemubr0 src 10.213.186.1 uid 1000 
    cache 
```

### 2.6 Restart and process-local request count — VM

```text
ubuntu@cs554-midterm:~/cs554-midterm$ curl -i -w '\n' http://localhost:8080/
HTTP/1.1 200 OK
Content-Type: application/json
Date: Mon, 19 Oct 2026 03:08:18 GMT
Connection: keep-alive
Keep-Alive: timeout=5
Transfer-Encoding: chunked

{"service":"cs554-midterm-compose","message":"Hello from Docker Compose inside the VM!","hostname":"95b02f2d2fe6","requestCount":3}
```

```text
ubuntu@cs554-midterm:~/cs554-midterm$ sudo docker compose restart web
[+] restart 0/1
 ⠹ Container cs554-midterm-web-1 Restarting                                                                                                                                                             0.2s
```

```text
ubuntu@cs554-midterm:~/cs554-midterm$ curl -i -w '\n' http://localhost:8080/
HTTP/1.1 200 OK
Content-Type: application/json
Date: Mon, 19 Oct 2026 03:09:22 GMT
Connection: keep-alive
Keep-Alive: timeout=5
Transfer-Encoding: chunked

{"service":"cs554-midterm-compose","message":"Hello from Docker Compose inside the VM!","hostname":"95b02f2d2fe6","requestCount":1}
```

## Part 3 — Kubernetes Deployment on the Host

### 3.1 Tool versions, cluster creation, node readiness, and image import

```text
yuxuan@yuxuan-Alienware-x15-R1:~/Desktop/cs454_midterm_Yuxuan$ sudo k3d version
[sudo] password for yuxuan: 
k3d version v5.9.0
k3s version v1.35.5-k3s1 (default)
```

```text
yuxuan@yuxuan-Alienware-x15-R1:~/Desktop/cs454_midterm_Yuxuan$ kubectl version --client
Client Version: v1.35.5
Kustomize Version: v5.7.1
```

```text
yuxuan@yuxuan-Alienware-x15-R1:~/Desktop/cs454_midterm_Yuxuan$ sudo k3d cluster create cs554-midterm --servers 1 --agents 0
[sudo] password for yuxuan: 
INFO[0000] Prep: Network                                
INFO[0000] Created network 'k3d-cs554-midterm'          
INFO[0000] Created image volume k3d-cs554-midterm-images 
INFO[0000] Starting new tools node...                   
INFO[0000] Pulling image 'ghcr.io/k3d-io/k3d-tools:5.9.0' 
INFO[0001] Creating node 'k3d-cs554-midterm-server-0'   
INFO[0001] Starting node 'k3d-cs554-midterm-tools'      
INFO[0001] Pulling image 'docker.io/rancher/k3s:v1.35.5-k3s1' 
INFO[0004] Creating LoadBalancer 'k3d-cs554-midterm-serverlb' 
INFO[0005] Pulling image 'ghcr.io/k3d-io/k3d-proxy:5.9.0' 
INFO[0006] Using the k3d-tools node to gather environment information 
INFO[0007] HostIP: using network gateway 172.18.0.1 address 
INFO[0007] Starting cluster 'cs554-midterm'             
INFO[0007] Starting servers...                          
INFO[0007] Starting node 'k3d-cs554-midterm-server-0'   
INFO[0012] All agents already running.                  
INFO[0012] Starting helpers...                          
INFO[0012] Starting node 'k3d-cs554-midterm-serverlb'   
INFO[0018] Injecting records for hostAliases (incl. host.k3d.internal) and for 2 network members into CoreDNS configmap... 
INFO[0020] Cluster 'cs554-midterm' created successfully! 
INFO[0020] You can now use it like this:                
kubectl cluster-info
```

```text
yuxuan@yuxuan-Alienware-x15-R1:~/Desktop/cs454_midterm_Yuxuan$ sudo kubectl get nodes -o wide
NAME                         STATUS   ROLES           AGE   VERSION        INTERNAL-IP   EXTERNAL-IP   OS-IMAGE           KERNEL-VERSION      CONTAINER-RUNTIME
k3d-cs554-midterm-server-0   Ready    control-plane   14s   v1.35.5+k3s1   172.18.0.2    <none>        K3s v1.35.5+k3s1   6.8.0-138-generic   containerd://2.2.3-k3s1
```

```text
yuxuan@yuxuan-Alienware-x15-R1:~/Desktop/cs454_midterm_Yuxuan$ sudo k3d image import cs554-midterm:v1 -c cs554-midterm
[sudo] password for yuxuan: 
INFO[0000] Importing image(s) into cluster 'cs554-midterm' 
INFO[0000] Starting new tools node...                   
INFO[0000] Starting node 'k3d-cs554-midterm-tools'      
INFO[0000] Saving 1 image(s) from runtime...            
INFO[0002] Importing images into nodes...               
INFO[0002] Importing images from tarball '/k3d/images/k3d-cs554-midterm-images-20261019184131.tar' into node 'k3d-cs554-midterm-server-0'... 
INFO[0004] Removing the tarball(s) from image volume... 
INFO[0005] Removing k3d-tools node...                   
INFO[0005] Successfully imported image(s)               
INFO[0005] Successfully imported 1 image(s) into 1 cluster(s) 
```

### 3.2 Deployment configuration and two ready replicas

```text
yuxuan@yuxuan-Alienware-x15-R1:~/Desktop/cs454_midterm_Yuxuan$ mkdir -p k8s
```

```text
yuxuan@yuxuan-Alienware-x15-R1:~/Desktop/cs454_midterm_Yuxuan$ cat > k8s/deployment.yaml <<'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: cs554-web
spec:
  replicas: 2
  selector:
    matchLabels:
      app: cs554-web
  template:
    metadata:
      labels:
        app: cs554-web
    spec:
      containers:
        - name: web
          image: cs554-midterm:v1
          imagePullPolicy: Never
          ports:
            - containerPort: 8080
          env:
            - name: PORT
              value: "8080"
            - name: SERVICE_NAME
              value: "cs554-midterm-kubernetes"
            - name: MESSAGE
              value: "Hello from Kubernetes!"
          resources:
            requests:
              cpu: "100m"
              memory: "64Mi"
            limits:
              cpu: "500m"
              memory: "128Mi"
          readinessProbe:
            httpGet:
              path: /health
              port: 8080
            initialDelaySeconds: 2
            periodSeconds: 5
            timeoutSeconds: 2
EOF
```

```text
yuxuan@yuxuan-Alienware-x15-R1:~/Desktop/cs454_midterm_Yuxuan$ sudo kubectl apply -f k8s/deployment.yaml
deployment.apps/cs554-web created
```

```text
yuxuan@yuxuan-Alienware-x15-R1:~/Desktop/cs454_midterm_Yuxuan$ sudo kubectl rollout status deployment/cs554-web --timeout=120s
deployment "cs554-web" successfully rolled out
```

```text
yuxuan@yuxuan-Alienware-x15-R1:~/Desktop/cs454_midterm_Yuxuan$ sudo kubectl get deployment cs554-web
NAME        READY   UP-TO-DATE   AVAILABLE   AGE
cs554-web   2/2     2            2           56s
```

```text
yuxuan@yuxuan-Alienware-x15-R1:~/Desktop/cs454_midterm_Yuxuan$ sudo kubectl get pods -l app=cs554-web -o wide
NAME                         READY   STATUS    RESTARTS   AGE   IP           NODE                         NOMINATED NODE   READINESS GATES
cs554-web-5d45fb7bb6-jnnff   1/1     Running   0          65s   10.42.0.10   k3d-cs554-midterm-server-0   <none>           <none>
cs554-web-5d45fb7bb6-qpb6g   1/1     Running   0          65s   10.42.0.9    k3d-cs554-midterm-server-0   <none>           <none>
```

### 3.3 Service and selected Pod endpoints

```text
yuxuan@yuxuan-Alienware-x15-R1:~/Desktop/cs454_midterm_Yuxuan$ sudo kubectl apply -f k8s/service.yaml
[sudo] password for yuxuan: 
service/cs554-web created
```

```text
yuxuan@yuxuan-Alienware-x15-R1:~/Desktop/cs454_midterm_Yuxuan$ sudo kubectl get service cs554-web
NAME        TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)    AGE
cs554-web   ClusterIP   10.43.80.179   <none>        8080/TCP   38s
```

```text
yuxuan@yuxuan-Alienware-x15-R1:~/Desktop/cs454_midterm_Yuxuan$ sudo kubectl get endpointslices -l kubernetes.io/service-name=cs554-web -o wide
NAME              ADDRESSTYPE   PORTS   ENDPOINTS              AGE
cs554-web-wx8bq   IPv4          8080    10.42.0.9,10.42.0.10   63s
```

### 3.4 Local access using Service port forwarding
Directory window:
```text
yuxuan@yuxuan-Alienware-x15-R1:~/Desktop/cs454_midterm_Yuxuan$ sudo kubectl port-forward service/cs554-web 8081:8080
[sudo] password for yuxuan: 
Forwarding from 127.0.0.1:8081 -> 8080
Forwarding from [::1]:8081 -> 8080
Handling connection for 8081
Handling connection for 8081
Handling connection for 8081
Handling connection for 8081
Handling connection for 8081

```

Another new terminal window: (record in screenshot part3_another_terminal.png)
```text
yuxuan@yuxuan-Alienware-x15-R1:~$ curl -i http://127.0.0.1:8081/
HTTP/1.1 200 OK
Content-Type: application/json
Date: Tue, 20 Oct 2026 00:45:30 GMT
Connection: keep-alive
Keep-Alive: timeout=5
Transfer-Encoding: chunked

yuxuan@yuxuan-Alienware-x15-R1:~$ curl -sS -w '\nHTTP %{http_code}, bytes %{size_download}\n' http://127.0.0.1:8081/
{"service":"cs554-midterm-kubernetes","message":"Hello from Kubernetes!","hostname":"cs554-web-5d45fb7bb6-jnnff","requestCount":2}
HTTP 200, bytes 130
yuxuan@yuxuan-Alienware-x15-R1:~$ curl -sS -w '\nHTTP %{http_code}, bytes %{size_download}\n' http://127.0.0.1:8081/health
{"status":"ok"}
HTTP 200, bytes 15
yuxuan@yuxuan-Alienware-x15-R1:~$ curl -i -w '\n' http://localhost:8081/
HTTP/1.1 200 OK
Content-Type: application/json
Date: Tue, 20 Oct 2026 01:09:27 GMT
Connection: keep-alive
Keep-Alive: timeout=5
Transfer-Encoding: chunked

{"service":"cs554-midterm-kubernetes","message":"Hello from Kubernetes!","hostname":"cs554-web-5d45fb7bb6-jnnff","requestCount":3}
yuxuan@yuxuan-Alienware-x15-R1:~$ curl -i -w '\n' http://localhost:8081/health
HTTP/1.1 200 OK
Content-Type: application/json
Date: Tue, 20 Oct 2026 01:11:40 GMT
Connection: keep-alive
Keep-Alive: timeout=5
Transfer-Encoding: chunked

{"status":"ok"}
```

### 3.5 Pod deletion, replacement, and return to two ready replicas

Another new terminal window: (record in screenshot part3_another_terminal.png)
```text
yuxuan@yuxuan-Alienware-x15-R1:~$ sudo kubectl get pods -l app=cs554-web -o wide
[sudo] password for yuxuan: 
NAME                         READY   STATUS    RESTARTS   AGE   IP           NODE                         NOMINATED NODE   READINESS GATES
cs554-web-5d45fb7bb6-jnnff   1/1     Running   0          84m   10.42.0.10   k3d-cs554-midterm-server-0   <none>           <none>
cs554-web-5d45fb7bb6-qpb6g   1/1     Running   0          84m   10.42.0.9    k3d-cs554-midterm-server-0   <none>           <none>
```

```text
yuxuan@yuxuan-Alienware-x15-R1:~$ sudo kubectl delete pod cs554-web-5d45fb7bb6-qpb6g
pod "cs554-web-5d45fb7bb6-qpb6g" deleted from default namespace
```

```text
yuxuan@yuxuan-Alienware-x15-R1:~$ sudo kubectl get pods -l app=cs554-web -o wide
NAME                         READY   STATUS    RESTARTS   AGE   IP           NODE                         NOMINATED NODE   READINESS GATES
cs554-web-5d45fb7bb6-7j9cb   1/1     Running   0          3s    10.42.0.11   k3d-cs554-midterm-server-0   <none>           <none>
cs554-web-5d45fb7bb6-jnnff   1/1     Running   0          87m   10.42.0.10   k3d-cs554-midterm-server-0   <none>           <none>
```

```text
yuxuan@yuxuan-Alienware-x15-R1:~$ sudo kubectl get deployment cs554-web
NAME        READY   UP-TO-DATE   AVAILABLE   AGE
cs554-web   2/2     2            2           88m
```

Directory window:
```text
yuxuan@yuxuan-Alienware-x15-R1:~/Desktop/cs454_midterm_Yuxuan$ sudo kubectl get pods -l app=cs554-web -o wide
[sudo] password for yuxuan: 
NAME                         READY   STATUS    RESTARTS   AGE    IP           NODE                         NOMINATED NODE   READINESS GATES
cs554-web-5d45fb7bb6-7j9cb   1/1     Running   0          39m    10.42.0.11   k3d-cs554-midterm-server-0   <none>           <none>
cs554-web-5d45fb7bb6-jnnff   1/1     Running   0          126m   10.42.0.10   k3d-cs554-midterm-server-0   <none>           <none>
```

## CS 554 Addition — Readiness Experiment

### Back up the original configuration and prepare the temporary probe

```text
yuxuan@yuxuan-Alienware-x15-R1:~/Desktop/cs454_midterm_Yuxuan$ cp k8s/deployment.yaml /tmp/cs554-deployment-before-readiness.yaml
```

```text
yuxuan@yuxuan-Alienware-x15-R1:~/Desktop/cs454_midterm_Yuxuan$ cat k8s/deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: cs554-web
spec:
  replicas: 2
  selector:
    matchLabels:
      app: cs554-web
  template:
    metadata:
      labels:
        app: cs554-web
    spec:
      containers:
        - name: web
          image: cs554-midterm:v1
          imagePullPolicy: Never
          ports:
            - containerPort: 8080
          env:
            - name: PORT
              value: "8080"
            - name: SERVICE_NAME
              value: "cs554-midterm-kubernetes"
            - name: MESSAGE
              value: "Hello from Kubernetes!"
          resources:
            requests:
              cpu: "100m"
              memory: "64Mi"
            limits:
              cpu: "500m"
              memory: "128Mi"
          readinessProbe:
            httpGet:
              path: /health
              port: 8080
            initialDelaySeconds: 2
            periodSeconds: 5
            timeoutSeconds: 2
```

**Comment** The configuration printed above is the original HTTP `/health` probe. Before the following apply, it was temporarily replaced with:
```
          readinessProbe:
            exec:
              command:
                - node
                - -e
                - |
                  const path = require('node:fs').existsSync('/tmp/not-ready') ? '/not-ready' : '/health';
                  const req = require('node:http').get('http://127.0.0.1:8080' + path, res => {
                    process.exit(res.statusCode === 200 ? 0 : 1);
                  });
                  req.on('error', () => process.exit(1));
                  req.setTimeout(1000, () => process.exit(1));
            initialDelaySeconds: 2
            periodSeconds: 5
            timeoutSeconds: 2
```

```text
yuxuan@yuxuan-Alienware-x15-R1:~/Desktop/cs454_midterm_Yuxuan$ sudo kubectl apply -f k8s/deployment.yaml
deployment.apps/cs554-web configured
```

```text
yuxuan@yuxuan-Alienware-x15-R1:~/Desktop/cs454_midterm_Yuxuan$ sudo kubectl rollout status deployment/cs554-web --timeout=120s
deployment "cs554-web" successfully rolled out
```

### Baseline — both Pods Ready and both endpoints eligible

```text
yuxuan@yuxuan-Alienware-x15-R1:~/Desktop/cs454_midterm_Yuxuan$ sudo kubectl get pods -l app=cs554-web -o wide
NAME                         READY   STATUS    RESTARTS   AGE   IP           NODE                         NOMINATED NODE   READINESS GATES
cs554-web-584d6dbd57-g89vp   1/1     Running   0          30s   10.42.0.13   k3d-cs554-midterm-server-0   <none>           <none>
cs554-web-584d6dbd57-hbg68   1/1     Running   0          32s   10.42.0.12   k3d-cs554-midterm-server-0   <none>           <none>
```

```text
yuxuan@yuxuan-Alienware-x15-R1:~/Desktop/cs454_midterm_Yuxuan$ sudo kubectl get endpointslices -l kubernetes.io/service-name=cs554-web -o yaml
apiVersion: v1
items:
- addressType: IPv4
  apiVersion: discovery.k8s.io/v1
  endpoints:
  - addresses:
    - 10.42.0.12
    conditions:
      ready: true
      serving: true
      terminating: false
    nodeName: k3d-cs554-midterm-server-0
    targetRef:
      kind: Pod
      name: cs554-web-584d6dbd57-hbg68
      namespace: default
      uid: 2c749d03-2792-49ac-a7cf-e8476ffaa2e8
  - addresses:
    - 10.42.0.13
    conditions:
      ready: true
      serving: true
      terminating: false
    nodeName: k3d-cs554-midterm-server-0
    targetRef:
      kind: Pod
      name: cs554-web-584d6dbd57-g89vp
      namespace: default
      uid: 914e34e8-915a-4be9-a25c-8983afb7603a
  kind: EndpointSlice
  metadata:
    annotations:
      endpoints.kubernetes.io/last-change-trigger-time: "2026-10-20T02:07:56Z"
    creationTimestamp: "2026-10-20T00:12:55Z"
    generateName: cs554-web-
    generation: 13
    labels:
      endpointslice.kubernetes.io/managed-by: endpointslice-controller.k8s.io
      kubernetes.io/service-name: cs554-web
    name: cs554-web-wx8bq
    namespace: default
    ownerReferences:
    - apiVersion: v1
      blockOwnerDeletion: true
      controller: true
      kind: Service
      name: cs554-web
      uid: 4efc5156-3f23-40d0-80c5-36b6964d3eaa
    resourceVersion: "4401"
    uid: 8c799b60-a0da-4b74-be8d-c63975208567
  ports:
  - name: ""
    port: 8080
    protocol: TCP
kind: List
metadata:
  resourceVersion: ""
```

### Failure — one Pod Running but NotReady, application still responding, Service access successful

```text
yuxuan@yuxuan-Alienware-x15-R1:~/Desktop/cs454_midterm_Yuxuan$ sudo kubectl exec cs554-web-584d6dbd57-hbg68 -- touch /tmp/not-ready
```

```text
yuxuan@yuxuan-Alienware-x15-R1:~/Desktop/cs454_midterm_Yuxuan$ sudo kubectl wait --for=condition=Ready=false pod/cs554-web-584d6dbd57-hbg68 --timeout=60s
pod/cs554-web-584d6dbd57-hbg68 condition met
```

```text
yuxuan@yuxuan-Alienware-x15-R1:~/Desktop/cs454_midterm_Yuxuan$ sudo kubectl get pods -l app=cs554-web -o wide
NAME                         READY   STATUS    RESTARTS   AGE     IP           NODE                         NOMINATED NODE   READINESS GATES
cs554-web-584d6dbd57-g89vp   1/1     Running   0          6m46s   10.42.0.13   k3d-cs554-midterm-server-0   <none>           <none>
cs554-web-584d6dbd57-hbg68   0/1     Running   0          6m48s   10.42.0.12   k3d-cs554-midterm-server-0   <none>           <none>
```

```text
yuxuan@yuxuan-Alienware-x15-R1:~/Desktop/cs454_midterm_Yuxuan$ sudo kubectl get endpointslices -l kubernetes.io/service-name=cs554-web -o yaml
apiVersion: v1
items:
- addressType: IPv4
  apiVersion: discovery.k8s.io/v1
  endpoints:
  - addresses:
    - 10.42.0.12
    conditions:
      ready: false
      serving: false
      terminating: false
    nodeName: k3d-cs554-midterm-server-0
    targetRef:
      kind: Pod
      name: cs554-web-584d6dbd57-hbg68
      namespace: default
      uid: 2c749d03-2792-49ac-a7cf-e8476ffaa2e8
  - addresses:
    - 10.42.0.13
    conditions:
      ready: true
      serving: true
      terminating: false
    nodeName: k3d-cs554-midterm-server-0
    targetRef:
      kind: Pod
      name: cs554-web-584d6dbd57-g89vp
      namespace: default
      uid: 914e34e8-915a-4be9-a25c-8983afb7603a
  kind: EndpointSlice
  metadata:
    annotations:
      endpoints.kubernetes.io/last-change-trigger-time: "2026-10-20T02:13:34Z"
    creationTimestamp: "2026-10-20T00:12:55Z"
    generateName: cs554-web-
    generation: 14
    labels:
      endpointslice.kubernetes.io/managed-by: endpointslice-controller.k8s.io
      kubernetes.io/service-name: cs554-web
    name: cs554-web-wx8bq
    namespace: default
    ownerReferences:
    - apiVersion: v1
      blockOwnerDeletion: true
      controller: true
      kind: Service
      name: cs554-web
      uid: 4efc5156-3f23-40d0-80c5-36b6964d3eaa
    resourceVersion: "4513"
    uid: 8c799b60-a0da-4b74-be8d-c63975208567
  ports:
  - name: ""
    port: 8080
    protocol: TCP
kind: List
metadata:
  resourceVersion: ""
```

```text
yuxuan@yuxuan-Alienware-x15-R1:~/Desktop/cs454_midterm_Yuxuan$ sudo kubectl exec cs554-web-584d6dbd57-hbg68 -- node -e 'fetch("http://127.0.0.1:8080/health", {signal: AbortSignal.timeout(5000)}).then(async r => { console.log("HTTP", r.status); console.log(await r.text()); }).catch(e => { console.error(e.message); process.exit(1); });'
HTTP 200
{"status":"ok"}
```

```text
yuxuan@yuxuan-Alienware-x15-R1:~/Desktop/cs454_midterm_Yuxuan$ sudo kubectl exec cs554-web-584d6dbd57-g89vp -- node -e 'fetch("http://cs554-web:8080/", {signal: AbortSignal.timeout(5000)}).then(async r => { console.log("HTTP", r.status); console.log(await r.text()); }).catch(e => { console.error(e.message); process.exit(1); });'
HTTP 200
{"service":"cs554-midterm-kubernetes","message":"Hello from Kubernetes!","hostname":"cs554-web-584d6dbd57-g89vp","requestCount":1}
```

### Recovery — the same Pods Ready again and both endpoints eligible

```text
yuxuan@yuxuan-Alienware-x15-R1:~/Desktop/cs454_midterm_Yuxuan$ sudo kubectl exec cs554-web-584d6dbd57-hbg68 -- rm /tmp/not-ready
```

```text
yuxuan@yuxuan-Alienware-x15-R1:~/Desktop/cs454_midterm_Yuxuan$ sudo kubectl wait --for=condition=Ready pod/cs554-web-584d6dbd57-hbg68 --timeout=60s
pod/cs554-web-584d6dbd57-hbg68 condition met
```

```text
yuxuan@yuxuan-Alienware-x15-R1:~/Desktop/cs454_midterm_Yuxuan$ sudo kubectl get pods -l app=cs554-web -o wide
NAME                         READY   STATUS    RESTARTS   AGE   IP           NODE                         NOMINATED NODE   READINESS GATES
cs554-web-584d6dbd57-g89vp   1/1     Running   0          23m   10.42.0.13   k3d-cs554-midterm-server-0   <none>           <none>
cs554-web-584d6dbd57-hbg68   1/1     Running   0          23m   10.42.0.12   k3d-cs554-midterm-server-0   <none>           <none>
```

```text
yuxuan@yuxuan-Alienware-x15-R1:~/Desktop/cs454_midterm_Yuxuan$ sudo kubectl get endpointslices -l kubernetes.io/service-name=cs554-web -o yaml
apiVersion: v1
items:
- addressType: IPv4
  apiVersion: discovery.k8s.io/v1
  endpoints:
  - addresses:
    - 10.42.0.12
    conditions:
      ready: true
      serving: true
      terminating: false
    nodeName: k3d-cs554-midterm-server-0
    targetRef:
      kind: Pod
      name: cs554-web-584d6dbd57-hbg68
      namespace: default
      uid: 2c749d03-2792-49ac-a7cf-e8476ffaa2e8
  - addresses:
    - 10.42.0.13
    conditions:
      ready: true
      serving: true
      terminating: false
    nodeName: k3d-cs554-midterm-server-0
    targetRef:
      kind: Pod
      name: cs554-web-584d6dbd57-g89vp
      namespace: default
      uid: 914e34e8-915a-4be9-a25c-8983afb7603a
  kind: EndpointSlice
  metadata:
    annotations:
      endpoints.kubernetes.io/last-change-trigger-time: "2026-10-20T02:31:26Z"
    creationTimestamp: "2026-10-20T00:12:55Z"
    generateName: cs554-web-
    generation: 15
    labels:
      endpointslice.kubernetes.io/managed-by: endpointslice-controller.k8s.io
      kubernetes.io/service-name: cs554-web
    name: cs554-web-wx8bq
    namespace: default
    ownerReferences:
    - apiVersion: v1
      blockOwnerDeletion: true
      controller: true
      kind: Service
      name: cs554-web
      uid: 4efc5156-3f23-40d0-80c5-36b6964d3eaa
    resourceVersion: "4874"
    uid: 8c799b60-a0da-4b74-be8d-c63975208567
  ports:
  - name: ""
    port: 8080
    protocol: TCP
kind: List
metadata:
  resourceVersion: ""
```

### Restore the original HTTP readiness probe and verify rollout

```text
yuxuan@yuxuan-Alienware-x15-R1:~/Desktop/cs454_midterm_Yuxuan$ cp /tmp/cs554-deployment-before-readiness.yaml k8s/deployment.yaml
```

```text
yuxuan@yuxuan-Alienware-x15-R1:~/Desktop/cs454_midterm_Yuxuan$ sudo kubectl apply -f k8s/deployment.yaml
deployment.apps/cs554-web configured
```

```text
yuxuan@yuxuan-Alienware-x15-R1:~/Desktop/cs454_midterm_Yuxuan$ sudo kubectl rollout status deployment/cs554-web --timeout=120s
Waiting for deployment "cs554-web" rollout to finish: 1 old replicas are pending termination...
deployment "cs554-web" successfully rolled out
```

```text
yuxuan@yuxuan-Alienware-x15-R1:~/Desktop/cs454_midterm_Yuxuan$ sudo kubectl get pods -l app=cs554-web -o wide
NAME                         READY   STATUS    RESTARTS   AGE   IP           NODE                         NOMINATED NODE   READINESS GATES
cs554-web-5d45fb7bb6-9hqzr   1/1     Running   0          26s   10.42.0.15   k3d-cs554-midterm-server-0   <none>           <none>
cs554-web-5d45fb7bb6-hhmg5   1/1     Running   0          29s   10.42.0.14   k3d-cs554-midterm-server-0   <none>           <none>

```

## Part 4 — Controlled Troubleshooting

### 4.1 Cluster status before the experiment — host

```text
yuxuan@yuxuan-Alienware-x15-R1:~/Desktop/cs454_midterm_Yuxuan$ sudo docker ps
[sudo] password for yuxuan: 
CONTAINER ID   IMAGE                            COMMAND                  CREATED        STATUS             PORTS                             NAMES
6351da92b006   ghcr.io/k3d-io/k3d-proxy:5.9.0   "/bin/sh -c nginx-pr…"   26 hours ago   Up About an hour   80/tcp, 0.0.0.0:44713->6443/tcp   k3d-cs554-midterm-serverlb
ce2b149d1b19   rancher/k3s:v1.35.5-k3s1         "/bin/k3d-entrypoint…"   26 hours ago   Up About an hour                                     k3d-cs554-midterm-server-0
```

```text
yuxuan@yuxuan-Alienware-x15-R1:~/Desktop/cs454_midterm_Yuxuan$ sudo k3d cluster list
NAME            SERVERS   AGENTS   LOADBALANCER
cs554-midterm   1/1       0/0      true
```

```text
yuxuan@yuxuan-Alienware-x15-R1:~/Desktop/cs454_midterm_Yuxuan$ sudo kubectl get pods -l app=cs554-web -o wide
NAME                         READY   STATUS    RESTARTS      AGE   IP           NODE                         NOMINATED NODE   READINESS GATES
cs554-web-5d45fb7bb6-9hqzr   1/1     Running   1 (71m ago)   22h   10.42.0.20   k3d-cs554-midterm-server-0   <none>           <none>
cs554-web-5d45fb7bb6-hhmg5   1/1     Running   1 (71m ago)   22h   10.42.0.19   k3d-cs554-midterm-server-0   <none>           <none>
```

### 4.2 Working baseline — host

```text
yuxuan@yuxuan-Alienware-x15-R1:~/Desktop/cs454_midterm_Yuxuan$ sudo kubectl get deployment cs554-web
[sudo] password for yuxuan: 
NAME        READY   UP-TO-DATE   AVAILABLE   AGE
cs554-web   2/2     2            2           25h
```

```text
yuxuan@yuxuan-Alienware-x15-R1:~/Desktop/cs454_midterm_Yuxuan$ sudo kubectl get pods -l app=cs554-web --show-labels
NAME                         READY   STATUS    RESTARTS       AGE   LABELS
cs554-web-5d45fb7bb6-9hqzr   1/1     Running   1 (108m ago)   22h   app=cs554-web,pod-template-hash=5d45fb7bb6
cs554-web-5d45fb7bb6-hhmg5   1/1     Running   1 (108m ago)   22h   app=cs554-web,pod-template-hash=5d45fb7bb6
```

```text
yuxuan@yuxuan-Alienware-x15-R1:~/Desktop/cs454_midterm_Yuxuan$ sudo kubectl get service cs554-web -o yaml
apiVersion: v1
kind: Service
metadata:
  annotations:
    kubectl.kubernetes.io/last-applied-configuration: |
      {"apiVersion":"v1","kind":"Service","metadata":{"annotations":{},"name":"cs554-web","namespace":"default"},"spec":{"ports":[{"port":8080,"targetPort":8080}],"selector":{"app":"cs554-web"},"type":"ClusterIP"}}
  creationTimestamp: "2026-10-20T00:12:55Z"
  name: cs554-web
  namespace: default
  resourceVersion: "2196"
  uid: 4efc5156-3f23-40d0-80c5-36b6964d3eaa
spec:
  clusterIP: 10.43.80.179
  clusterIPs:
  - 10.43.80.179
  internalTrafficPolicy: Cluster
  ipFamilies:
  - IPv4
  ipFamilyPolicy: SingleStack
  ports:
  - port: 8080
    protocol: TCP
    targetPort: 8080
  selector:
    app: cs554-web
  sessionAffinity: None
  type: ClusterIP
status:
  loadBalancer: {}
```

```text
yuxuan@yuxuan-Alienware-x15-R1:~/Desktop/cs454_midterm_Yuxuan$ sudo kubectl get endpointslices -l kubernetes.io/service-name=cs554-web -o wide
NAME              ADDRESSTYPE   PORTS   ENDPOINTS               AGE
cs554-web-wx8bq   IPv4          8080    10.42.0.20,10.42.0.19   25h
```

```text
yuxuan@yuxuan-Alienware-x15-R1:~/Desktop/cs454_midterm_Yuxuan$ sudo kubectl exec cs554-web-5d45fb7bb6-9hqzr -- node -e 'fetch("http://cs554-web:8080/", {signal: AbortSignal.timeout(5000)}).then(async r => { console.log("HTTP", r.status); console.log(await r.text()); }).catch(e => { console.error(e.name + ": " + e.message); process.exit(1); });'
[sudo] password for yuxuan: 
HTTP 200
{"service":"cs554-midterm-kubernetes","message":"Hello from Kubernetes!","hostname":"cs554-web-5d45fb7bb6-hhmg5","requestCount":1}
```

### 4.3 Introduce the selector mismatch and observe the client failure — host

```text
yuxuan@yuxuan-Alienware-x15-R1:~/Desktop/cs454_midterm_Yuxuan$ sudo kubectl patch service cs554-web --type merge -p '{"spec":{"selector":{"app":"cs554-web-wrong"}}}'
[sudo] password for yuxuan: 
service/cs554-web patched
```

```text
yuxuan@yuxuan-Alienware-x15-R1:~/Desktop/cs454_midterm_Yuxuan$ sudo kubectl exec cs554-web-5d45fb7bb6-9hqzr -- node -e 'fetch("http://cs554-web:8080/", {signal: AbortSignal.timeout(5000)}).then(async r => { console.log("HTTP", r.status); console.log(await r.text()); }).catch(e => { console.error(e.name + ": " + e.message); process.exit(1); });'
TypeError: fetch failed
command terminated with exit code 1
```

### 4.4 Diagnose the failure — host

```text
yuxuan@yuxuan-Alienware-x15-R1:~/Desktop/cs454_midterm_Yuxuan$ sudo kubectl get pods -l app=cs554-web --show-labels
[sudo] password for yuxuan: 
NAME                         READY   STATUS    RESTARTS        AGE   LABELS
cs554-web-5d45fb7bb6-9hqzr   1/1     Running   1 (3h24m ago)   24h   app=cs554-web,pod-template-hash=5d45fb7bb6
cs554-web-5d45fb7bb6-hhmg5   1/1     Running   1 (3h24m ago)   24h   app=cs554-web,pod-template-hash=5d45fb7bb6
```

```text
yuxuan@yuxuan-Alienware-x15-R1:~/Desktop/cs454_midterm_Yuxuan$ sudo kubectl get service cs554-web -o yaml
apiVersion: v1
kind: Service
metadata:
  annotations:
    kubectl.kubernetes.io/last-applied-configuration: |
      {"apiVersion":"v1","kind":"Service","metadata":{"annotations":{},"name":"cs554-web","namespace":"default"},"spec":{"ports":[{"port":8080,"targetPort":8080}],"selector":{"app":"cs554-web"},"type":"ClusterIP"}}
  creationTimestamp: "2026-10-20T00:12:55Z"
  name: cs554-web
  namespace: default
  resourceVersion: "12589"
  uid: 4efc5156-3f23-40d0-80c5-36b6964d3eaa
spec:
  clusterIP: 10.43.80.179
  clusterIPs:
  - 10.43.80.179
  internalTrafficPolicy: Cluster
  ipFamilies:
  - IPv4
  ipFamilyPolicy: SingleStack
  ports:
  - port: 8080
    protocol: TCP
    targetPort: 8080
  selector:
    app: cs554-web-wrong
  sessionAffinity: None
  type: ClusterIP
status:
  loadBalancer: {}
```

```text
yuxuan@yuxuan-Alienware-x15-R1:~/Desktop/cs454_midterm_Yuxuan$ sudo kubectl get endpointslices -l kubernetes.io/service-name=cs554-web -o wide
NAME              ADDRESSTYPE   PORTS     ENDPOINTS   AGE
cs554-web-wx8bq   IPv4          <unset>   <unset>     26h
```

### 4.5 Restore the selector and verify recovery — host

```text
yuxuan@yuxuan-Alienware-x15-R1:~/Desktop/cs454_midterm_Yuxuan$ sudo kubectl patch service cs554-web --type merge -p '{"spec":{"selector":{"app":"cs554-web"}}}'
service/cs554-web patched
```

```text
yuxuan@yuxuan-Alienware-x15-R1:~/Desktop/cs454_midterm_Yuxuan$ sudo kubectl get endpointslices -l kubernetes.io/service-name=cs554-web -o wide
NAME              ADDRESSTYPE   PORTS   ENDPOINTS               AGE
cs554-web-wx8bq   IPv4          8080    10.42.0.19,10.42.0.20   26h
```

```text
yuxuan@yuxuan-Alienware-x15-R1:~/Desktop/cs454_midterm_Yuxuan$ sudo kubectl exec cs554-web-5d45fb7bb6-9hqzr -- node -e 'fetch("http://cs554-web:8080/", {signal: AbortSignal.timeout(5000)}).then(async r => { console.log("HTTP", r.status); console.log(await r.text()); }).catch(e => { console.error(e.name + ": " + e.message); process.exit(1); });'
HTTP 200
{"service":"cs554-midterm-kubernetes","message":"Hello from Kubernetes!","hostname":"cs554-web-5d45fb7bb6-hhmg5","requestCount":2}

```

