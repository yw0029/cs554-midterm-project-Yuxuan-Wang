## CS 554 Midterm Mini-Project

Part 1: service, tests, Dockerfile, runnable application image
Part 2: VM/Compose deployment, VM and host access, logs, restart experiment
Part 3: Kubernetes Deployment and Service, two replicas, Pod replacement 
Part 4: Service-selector failure and recovery
CS 554 extension: resource requests/limits and readiness experiment 
Part 5: OpenStack deployment analysis

## Repository files

| File Path | Purpose |
| --- | --- |
| `src/server.js`              | HTTP application                                                        |
| `test/service.test.js`       | Supplied application test                                               |
| `package.json`               | Application start/test commands                                         |
| `Dockerfile`                 | Builds the application image                                            |
| `.dockerignore`              | Excludes unrelated files from the image build context                   |
| `compose.yaml`               | VM/Compose deployment configuration                                     |
| `k8s/deployment.yaml`        | Two application replicas, environment, resources, readiness             |
| `k8s/service.yaml`           | ClusterIP Service selecting the application Pods                        |
| `evidence/`                  | Saved terminal output and screenshots                                   |

The host project directory in the recorded run was `/home/yuxuan/Desktop/cs454_midterm_Yuxuan`. Inside the VM, the deployment directory was `/home/ubuntu/cs554-midterm`.

## Prerequisites and tested versions

The commands below are used in an Ubuntu 22.04 x86-64 host and an Ubuntu 24.04 x86-64 VM(Multipass).

Host: Node.js 22.23.3; npm 10.9.9 
Host: Docker Engine 29.8.0
VM: Multipass 1.16.4; QEMU driver
VM OS: Ubuntu 24.04 LTS 
VM Docker Engine: 29.9.1
VM Docker Compose: v5.6.0
VM resources: 4 virtual CPUs, 4 GB memory, 30 GB virtual disk

Manual setup: install Docker Engine on the host using the official Ubuntu instructions. Install Node.js/npm if running the application and its tests directly on the host. 
VM installation commands are included below. Run Multipass commands as the ordinary host user; Docker commands use `sudo` in this environment.

The following commands will setup from a fresh environment.

## Application behavior and configuration

| Endpoint      | Behavior                                                                          |
| --- | --- |
| `GET /`       | Returns JSON with `service`, `message`, `hostname`, and `requestCount`            |
| `GET /health` | Returns HTTP 200 with `{"status":"ok"}` while the application is serving requests |

| Environment variable | Default                        | Purpose                       |
| --- | --- | --- |
| `PORT`               | `8080`                         | Application listening port    |
| `SERVICE_NAME`       | `cs454-midterm`                | Service name returned in JSON |
| `MESSAGE`            | `Hello from the mini-project!` | Message returned in JSON      |

The counter belongs to one application process and increments on successful `GET /` requests. Health checks do not increment it. Each application process has its own counter. 
A restart resets the in-memory counter to zero, and its first subsequent `GET /` returns `1`.

## Part 1: Small web service(test and build on the host)

From the project root(`/home/yuxuan/Desktop/cs454_midterm_Yuxuan` in my computer): `npm test`
The recorded test result was one passed test and zero failures.

To run without a container: `npm start`
This occupies the terminal. Use another host terminal for requests:
`curl -i -w '\n' http://localhost:8080/`,
`curl -i -w '\n' http://localhost:8080/health`,
then stop the foreground application with Ctrl+C when finished.

An environment-variable configuration was also exercised: `PORT=8090 SERVICE_NAME=cs554-midterm MESSAGE="Hello from CS554" npm start`


Next, build the image using the project Dockerfile: `sudo docker build -t cs554-midterm:v1 .`
The Dockerfile uses `node:22.23.3-bookworm-slim`, copies the application into `/app`, runs as the `node` user, and starts `node src/server.js`.

For a first standalone container test on the host:
```bash
sudo docker run -d \
  --name cs554-part1 \
  -p 127.0.0.1:8080:8080 \
  cs554-midterm:v1
sudo docker ps --filter name=cs554-part1
curl -i -w '\n' http://localhost:8080/
curl -i -w '\n' http://localhost:8080/health
sudo docker logs cs554-part1
```
Both endpoints returned HTTP 200 in the recorded run.

## Part 2: Docker Compose inside a Linux VM

On the host, install Multipass if needed:
```bash
sudo snap install multipass
multipass version
multipass get local.driver
```

The recorded driver was `qemu`. Create the VM:
```bash
multipass launch 24.04 \
  --name cs554-midterm \
  --cpus 4 \
  --memory 4G \
  --disk 30G
multipass info cs554-midterm
multipass shell cs554-midterm
```
After these commands, it will enter `ubuntu@cs554-midterm`.

## Install Docker Engine and Compose inside the VM

Run the following at the `ubuntu@cs554-midterm` prompt. The repository settings below match this Ubuntu 24.04 / amd64 VM.

```bash
sudo apt update
sudo apt install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: noble
Components: stable
Architectures: amd64
Signed-By: /etc/apt/keyrings/docker.asc
EOF
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo docker version
sudo docker compose version
sudo docker run --rm hello-world
```
The checks returned Docker Client and Server information, a Compose version, and `Hello from Docker!`.

## Make the built image and Compose file available to the VM

Return to the host terminal: using `exit`

From the host project root, save and transfer the already-built image and the project Compose configuration:
```bash
sudo docker save cs554-midterm:v1 > ~/cs554-midterm-v1.tar
multipass transfer ~/cs554-midterm-v1.tar cs554-midterm:/home/ubuntu/cs554-midterm-v1.tar
multipass transfer --parents compose.yaml cs554-midterm:/home/ubuntu/cs554-midterm/compose.yaml
multipass shell cs554-midterm
```
`--parents` creates the destination directory inside the VM. The `.tar` file is used locally to transfer the built image; it is excluded from the submitted project.

Inside the VM, load the image:
```bash
sudo docker load -i ~/cs554-midterm-v1.tar
sudo docker image ls cs554-midterm:v1
```
The recorded load returned `Loaded image: cs554-midterm:v1`. The application is not rebuilt inside the VM.

## Start and observe Compose inside the VM

The submitted `compose.yaml` defines service `web`, uses `cs554-midterm:v1` with `pull_policy: never`, sets the three application environment variables, and publishes `8080:8080`.
```bash
cd ~/cs554-midterm
sudo docker compose config
sudo docker compose up -d
sudo docker compose ps
curl -i -w '\n' http://localhost:8080/
curl -i -w '\n' http://localhost:8080/health
sudo docker compose logs --no-color web
```
Results: service container `cs554-midterm-web-1` is `Up`; both requests return HTTP 200; `/` returns service `cs554-midterm-compose` and message `Hello from Docker Compose inside the VM!`.

## Access the VM service from the host

Return to the host:
```bash
exit
multipass info cs554-midterm
curl -i -w '\n' http://10.213.186.117:8080/
```
Use `multipass info` to get the VM's current primary IPv4 address. `10.213.186.117` was the VM address in this run. Use the VM's current primary IPv4 address from `multipass info` if it differs. Host access uses that VM address.

## Restart experiment

Enter the VM from the host:
```bash
multipass shell cs554-midterm
```

Then run inside the VM:
```bash
cd ~/cs554-midterm
curl -i -w '\n' http://localhost:8080/
sudo docker compose restart web
curl -i -w '\n' http://localhost:8080/
```
The observed count changed from `3` before the restart to `1` on the first request afterward. Remember using `exit` to return to the host after finish part2.

## Part 3: Kubernetes deployment

The cluster runs in Docker containers on my Ubuntu host. It has one K3s server node, which also runs the application Pods.

| Tool and version          |
| --- |
| k3d v5.9.0                |
| K3s server v1.35.5+k3s1   |
| kubectl v1.35.5           |

Install k3d and kubectl on the host if needed. The recorded installation commands were:
```bash
curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
curl -fL https://dl.k8s.io/release/v1.35.5/bin/linux/amd64/kubectl -o /tmp/kubectl
sudo install -o root -g root -m 0755 /tmp/kubectl /usr/local/bin/kubectl
sudo k3d version
kubectl version --client
```
The tools are installed in `/usr/local/bin`. 

### Create the cluster and import the image

Run on the host from the project root, with the Part 1 image already built. Create the cluster once; reuse it if it already exists.
```bash
sudo k3d cluster create cs554-midterm --servers 1 --agents 0
sudo kubectl get nodes -o wide
sudo k3d image import cs554-midterm:v1 -c cs554-midterm
```

The host Docker store and the node's containerd image store are separate. Import makes the same `cs554-midterm:v1` image available inside the node.

### Deploy and inspect

`k8s/deployment.yaml` specifies two replicas, image `cs554-midterm:v1`, `imagePullPolicy: Never`, port `8080`, and the application environment variables. `SERVICE_NAME` is `cs554-midterm-kubernetes`; `MESSAGE` is `Hello from Kubernetes!`.

The final configuration also contains these per-container values:
| Setting  |  CPU   | Memory  |
| --- | --- | --- |
| requests | `100m` | `64Mi`  |
| limits   | `500m` | `128Mi` |

Its normal readiness probe uses `httpGet` on `/health`, port `8080`, with initial delay 2 seconds, period 5 seconds, and timeout 2 seconds. No liveness probe was added.

`k8s/service.yaml` defines the ClusterIP Service `cs554-web`, selector `app: cs554-web`, and `port: 8080` / `targetPort: 8080`.
Then, do the deployment:
```bash
sudo kubectl apply -f k8s/deployment.yaml
sudo kubectl apply -f k8s/service.yaml
sudo kubectl rollout status deployment/cs554-web --timeout=120s
sudo kubectl get deployment cs554-web
sudo kubectl get pods -l app=cs554-web -o wide
sudo kubectl get service cs554-web
sudo kubectl get endpointslices -l kubernetes.io/service-name=cs554-web -o wide
```
Expected results: Deployment `READY 2/2`; two Pods `1/1 Running`; Service port `8080/TCP`; two Pod addresses in the EndpointSlice. Assigned Pod names and IP addresses vary between runs.

### Access both endpoints

Keep this command running in one host terminal:
```bash
sudo kubectl port-forward service/cs554-web 8081:8080
```

In a second host terminal:
```bash
curl -i -w '\n' http://localhost:8081/
curl -i -w '\n' http://localhost:8081/health
```

Both endpoints returned HTTP 200. `/` returned the configured service/message, a Pod hostname, and the process-local count. `/health` returned `{"status":"ok"}`.

Here `8081` is the host listening port. Stop forwarding with Ctrl+C when finished.

### Delete one Pod and observe replacement

In the above second host terminal:
```bash
sudo kubectl get pods -l app=cs554-web -o wide
```
You will get list of two pods, then select one of them, copy the NAME.
```bash
sudo kubectl delete pod NAME
# I used `sudo kubectl delete pod cs554-web-5d45fb7bb6-qpb6g` in my laptop.
```

Then using the following commands to check the replacement.
```bash
sudo kubectl get pods -l app=cs554-web -o wide -w
sudo kubectl get deployment cs554-web
```

In the recorded run, `qpb6g` was deleted, `7j9cb` appeared, and `jnnff` remained. Deployment status returned to `2/2`. The replacement was already Ready by the next query.

## CS 554: reproduce the readiness experiment

Run these steps on the host from the project root, using the same terminal throughout so the shell variables remain set.

### Prepare the probe switch

Back up the normal manifest before editing:

```bash
cp k8s/deployment.yaml /tmp/cs554-deployment-before-readiness.yaml
```

In `k8s/deployment.yaml`, replace only the `readinessProbe` block with the following. Keep it aligned with `resources`:

```yaml
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

This is a temporary per-Pod probe-path switch. With no `/tmp/not-ready` file, each probe still requests `/health`. The file belongs to the individual Pod's container filesystem. The manifest backup is a different file in the host's `/tmp` directory.

Apply this healthy preparation configuration and wait for rollout:

```bash
sudo kubectl apply -f k8s/deployment.yaml
sudo kubectl rollout status deployment/cs554-web --timeout=120s
sudo kubectl get pods -l app=cs554-web -o wide
```

This preparation replaces the old Pods. Begin the experiment only after the two new Pods are Ready. Both remain healthy until the switch file is created in one selected Pod.

### Baseline: two Ready Pods and two ready backends

```bash
sudo kubectl get pods -l app=cs554-web -o wide
sudo kubectl get endpointslices -l kubernetes.io/service-name=cs554-web -o yaml
```

Save the output: both Pods must be `1/1 Running`, and both EndpointSlice entries must have `ready: true`. Keep the selected Pod names for the failure and recovery checks.

### Failure: one running Pod becomes NotReady

```bash
sudo kubectl exec SELECT_NAME -- touch /tmp/not-ready 
# I used `sudo kubectl exec cs554-web-584d6dbd57-hbg68 -- touch /tmp/not-ready` in my laptop.
sudo kubectl wait --for=condition=Ready=false pod/SELECT_NAME --timeout=60s 
# I used `sudo kubectl wait --for=condition=Ready=false pod/cs554-web-584d6dbd57-hbg68 --timeout=60s` in my laptop.
sudo kubectl get pods -l app=cs554-web -o wide
sudo kubectl get endpointslices -l kubernetes.io/service-name=cs554-web -o yaml
```

The switch makes only the selected Pod's probe request the non-serving `/not-ready` path. Expected: that same Pod becomes `0/1 Running`, its restart count stays unchanged, and its EndpointSlice entry changes to `ready: false`. The other Pod remains Ready. 
The non-ready IP can remain listed in the EndpointSlice; check its condition.

Verify application response and Service access with Node.js, which is already in the image:

```bash
sudo kubectl exec SELECT_NAME -- node -e 'fetch("http://127.0.0.1:8080/health", {signal: AbortSignal.timeout(5000)}).then(async r => { console.log("HTTP", r.status); console.log(await r.text()); }).catch(e => { console.error(e.message); process.exit(1); });'
# The SELECT_NAME I used `cs554-web-584d6dbd57-hbg68` in my laptop.
sudo kubectl exec ANOTHER_NAME -- node -e 'fetch("http://cs554-web:8080/", {signal: AbortSignal.timeout(5000)}).then(async r => { console.log("HTTP", r.status); console.log(await r.text()); }).catch(e => { console.error(e.message); process.exit(1); });'
# The ANOTHER_NAME I used `cs554-web-584d6dbd57-g89vp` in my laptop.
```
The first request is local to the NotReady Pod and verifies that its application still responds to `/health`. The second is an in-cluster request to the Service DNS name; it goes through the Service's ready backends. In the recorded run, both returned HTTP 200 and the Service response named the other, Ready Pod. This traffic check does not use port forwarding.

### Recovery and restoration

```bash
sudo kubectl exec SELECT_NAME -- rm /tmp/not-ready
# I used `sudo kubectl exec cs554-web-584d6dbd57-hbg68 -- rm /tmp/not-ready` in my laptop.
sudo kubectl wait --for=condition=Ready pod/SELECT_NAME --timeout=60s 
# I used `sudo kubectl wait --for=condition=Ready pod/cs554-web-584d6dbd57-hbg68 --timeout=60s` in my laptop.
sudo kubectl get pods -l app=cs554-web -o wide
sudo kubectl get endpointslices -l kubernetes.io/service-name=cs554-web -o yaml
```
Both original experiment Pods must return to `1/1 Running`, with unchanged names/IPs and restart counts, and both EndpointSlice entries must return to `ready: true`.

Then restore the original HTTP readiness probe:
```bash
cp /tmp/cs554-deployment-before-readiness.yaml k8s/deployment.yaml
sudo kubectl apply -f k8s/deployment.yaml
sudo kubectl rollout status deployment/cs554-web --timeout=120s
sudo kubectl get pods -l app=cs554-web -o wide
```
Restoring the template causes another rollout; this is separate from the same-Pod recovery observed above. 

## Part 4: Controlled troubleshooting

Run this after the Part 3. 

### 1. Record the working baseline

Check the Deployment, Pod status and labels, Service configuration, and backend addresses:

```bash
sudo kubectl get deployment cs554-web
sudo kubectl get pods -l app=cs554-web -o wide --show-labels
sudo kubectl get service cs554-web -o yaml
sudo kubectl get endpointslices -l kubernetes.io/service-name=cs554-web -o wide
```
Confirm that both replicas are Ready, the Service selector matches `app=cs554-web`, and both Pod addresses are listed.

Select a current application Pod as the HTTP client. Copy its name.
```bash
sudo kubectl exec NAME -- node -e 'fetch("http://cs554-web:8080/", {signal: AbortSignal.timeout(5000)}).then(async r => { console.log("HTTP", r.status); console.log(await r.text()); }).catch(e => { console.error(e.name + ": " + e.message); process.exit(1); });'
```
Record the successful HTTP 200 response and JSON body.

### 2. Introduce the failure

Change the live Service selector to a value that does not match the application Pods:
```bash
sudo kubectl patch service cs554-web --type merge -p '{"spec":{"selector":{"app":"cs554-web-wrong"}}}'
```

Wait a few seconds for the endpoints to update, then send the same request again:
```bash
sudo kubectl exec NAME -- node -e 'fetch("http://cs554-web:8080/", {signal: AbortSignal.timeout(5000)}).then(async r => { console.log("HTTP", r.status); console.log(await r.text()); }).catch(e => { console.error(e.name + ": " + e.message); process.exit(1); });'
```
Record the client failure. In the recorded run, it returned `TypeError: fetch failed` and `command terminated with exit code 1`.

### 3. Diagnose the failure

```bash
sudo kubectl get pods -l app=cs554-web --show-labels
sudo kubectl get service cs554-web -o yaml
sudo kubectl get endpointslices -l kubernetes.io/service-name=cs554-web -o wide
```
In the recorded run, both Pods remained `1/1 Running`, with label `app=cs554-web` and no increase in restart counts. The Service's `spec.selector` was `app: cs554-web-wrong`, and `ENDPOINTS` showed `<unset>`. The selector mismatch left the Service without matching backends.

### 4. Restore the selector and verify recovery

Restore the selector so it matches the application labels again:
```bash
sudo kubectl patch service cs554-web --type merge -p '{"spec":{"selector":{"app":"cs554-web"}}}'
```

After a few seconds, check that both backend addresses have returned:
```bash
sudo kubectl get endpointslices -l kubernetes.io/service-name=cs554-web -o wide
```

Then repeat the request through the Service:
```bash
sudo kubectl exec NAME -- node -e 'fetch("http://cs554-web:8080/", {signal: AbortSignal.timeout(5000)}).then(async r => { console.log("HTTP", r.status); console.log(await r.text()); }).catch(e => { console.error(e.name + ": " + e.message); process.exit(1); });'
```
In the recorded run, both backend addresses (`10.42.0.19` and `10.42.0.20`) returned, and the client again received HTTP 200 and JSON. This restores the temporary Service change.

## Evidence to include

Keep terminal output or screenshots in `evidence/`. Output_part1_2.log is the output for part1 and 2. Output_part3.log is the output for part3. Output_part4.log is the output for part4.
`evidence/EVIDENCE_PARTS.md` contains selected commands and their complete original outputs from Parts 1 to 4 and the CS 554 readiness experiment. The selected commands and outputs are unchanged. Headings and comments are added for easier review.
And the folder includes some screenshots for my test.

## Cleanup for completed experiments

Inside the VM, stop and remove the Compose containers and project network:
```bash
cd ~/cs554-midterm
sudo docker compose down
exit
```

On the host, stop the VM when finished:
```bash
multipass stop cs554-midterm
```

If the standalone Part 1 host test container is still present, stop and remove it on the host:
```bash
sudo docker stop cs554-part1
sudo docker rm cs554-part1
```

After completing the Kubernetes experiments, delete this project's cluster from the host:
```bash
sudo k3d cluster delete cs554-midterm
```
This removes the cluster and its Kubernetes workloads.






