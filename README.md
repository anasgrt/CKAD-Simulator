# CKAD Simulator Practice - killer.sh Style

Complete practice environment for 25 CKAD exam questions based on the killer.sh CKAD Simulator.

**Source:** killer.sh CKAD Simulator  
**Kubernetes Version:** 1.31+  
**Total Questions:** 22 Main + 3 Preview = 25

## Prerequisites

* Access to a Kubernetes cluster (k3s, kind, minikube, or any dev cluster)
* `kubectl` configured and working
* `helm` for Question 4 (Helm management)
* `podman` or `docker` for Question 11 (container image)
* Metrics server for monitoring questions (optional)

## Quick Start

```bash
cd ckad-simulator

# List all available questions
./scripts/run-question.sh list

# Start a question (sets up environment + shows question)
./scripts/run-question.sh Question-01-Namespaces

# Verify your answer
./scripts/run-question.sh Question-01-Namespaces verify

# View solution if stuck
./scripts/run-question.sh Question-01-Namespaces solution

# Reset/cleanup
./scripts/run-question.sh Question-01-Namespaces reset
```

## Questions Overview

| # | Question | Domain | Weight |
|---|----------|--------|--------|
| 1 | Namespaces | Application Environment | ~2% |
| 2 | Pods | Application Design and Build | ~4% |
| 3 | Job | Application Design and Build | ~5% |
| 4 | Helm Management | Application Deployment | ~5% |
| 5 | ServiceAccount, Secret | Application Environment | ~4% |
| 6 | ReadinessProbe | Application Design and Build | ~4% |
| 7 | Pods, Namespaces | Application Design and Build | ~4% |
| 8 | Deployment, Rollouts | Application Deployment | ~6% |
| 9 | Pod -> Deployment | Application Deployment | ~6% |
| 10 | Service, Logs | Services & Networking | ~6% |
| 11 | Working with Containers | Application Design and Build | ~5% |
| 12 | Storage, PV, PVC | Application Environment | ~7% |
| 13 | StorageClass, PVC | Application Environment | ~5% |
| 14 | Secret, Secret-Volume, Secret-Env | Application Environment | ~7% |
| 15 | ConfigMap, ConfigMap-Volume | Application Environment | ~5% |
| 16 | Logging Sidecar | Application Observability | ~6% |
| 17 | InitContainer | Application Design and Build | ~5% |
| 18 | Service Misconfiguration | Services & Networking | ~5% |
| 19 | ClusterIP -> NodePort | Services & Networking | ~4% |
| 20 | NetworkPolicy | Services & Networking | ~7% |
| 21 | Requests and Limits, ServiceAccount | Application Environment | ~5% |
| 22 | Labels, Annotations | Application Environment | ~4% |
| P1 | Liveness Probe | Application Observability | ~5% |
| P2 | Deployment and Service | Application Deployment | ~6% |
| P3 | Debugging Service | Application Observability | ~7% |

## Workflow

1. **Setup**: `./scripts/run-question.sh Question-XX` - Creates resources and shows question
2. **Solve**: Use kubectl to complete the task
3. **Verify**: `./scripts/run-question.sh Question-XX verify` - Check your answer
4. **Solution**: `./scripts/run-question.sh Question-XX solution` - View solution if stuck
5. **Reset**: `./scripts/run-question.sh Question-XX reset` - Clean up before next attempt

## Directory Structure

```
ckad-simulator/
├── scripts/
│   └── run-question.sh          # Main runner script
├── Question-01-Namespaces/
│   ├── setup.sh                 # Environment setup
│   ├── question.txt             # Question text
│   ├── verify.sh                # Answer verification
│   ├── solution.sh              # Solution with explanations
│   └── reset.sh                 # Cleanup script
├── Question-02-Pods/
│   └── ...
├── ...
├── Preview-1-Liveness-Probe/
│   └── ...
├── Preview-2-Deployment-Service/
│   └── ...
├── Preview-3-Debugging-Service/
│   └── ...
└── README.md
```

## CKAD Exam Domains Coverage

| Domain | Weight | Questions |
|--------|--------|-----------|
| Application Design and Build | 20% | Q2, Q3, Q6, Q7, Q11, Q17 |
| Application Deployment | 20% | Q4, Q8, Q9, P2 |
| Application Observability and Maintenance | 15% | Q16, P1, P3 |
| Application Environment, Configuration and Security | 25% | Q1, Q5, Q12, Q13, Q14, Q15, Q21, Q22 |
| Services & Networking | 20% | Q10, Q18, Q19, Q20 |

## Exam Tips

1. **Always switch context first** before answering any question
2. **Use imperative commands** when possible to save time
3. **Use K8s documentation** - know search keywords
4. **Verify your work** - always check pods are running
5. **Practice Linux commands** - sort, awk, grep, head are essential
6. **Know kubectl shortcuts** - use aliases and auto-completion

## Commands Cheat Sheet

```bash
# Context
kubectl config use-context <context>

# Create resources imperatively
kubectl create secret generic <n> --from-literal=key=value
kubectl create configmap <n> --from-file=<file>
kubectl create ns <namespace>
kubectl run <pod> --image=<image> --port=<port>
kubectl create deployment <n> --image=<image> --replicas=N

# Expose resources
kubectl expose pod <pod> --port=<port> --target-port=<port> --name=<svc>
kubectl expose deployment <deploy> --type=NodePort --port=<port>

# Edit & Update
kubectl edit deployment <n> -n <ns>
kubectl set image deployment/<n> <container>=<image>
kubectl scale deployment <n> --replicas=N
kubectl patch <resource> <name> -p '<json>'

# Rollouts
kubectl rollout status deployment/<n>
kubectl rollout history deployment/<n>
kubectl rollout undo deployment/<n>

# Debug
kubectl logs <pod> -n <ns>
kubectl logs <pod> -c <container>
kubectl exec -it <pod> -- /bin/sh
kubectl describe pod <pod> -n <ns>
kubectl get events -n <ns>

# Labels & Selectors
kubectl get pod -l key=value
kubectl label pod <pod> key=value
kubectl annotate pod <pod> key=value

# Dry-run & YAML generation
kubectl run <pod> --image=<image> --dry-run=client -oyaml > pod.yaml
kubectl create deployment <n> --image=<image> --dry-run=client -oyaml > deploy.yaml
```

## Broken Scenarios Included

Some questions include pre-configured broken scenarios for debugging practice:

- **Q8**: Deployment with typo in image name (`ngnix` instead of `nginx`)
- **Q18**: Service with wrong selector (points to deployment name instead of pod label)
- **P3**: Readiness probe on wrong port (82 instead of 80)

## Source

Questions based on killer.sh CKAD Simulator:
https://killer.sh/

## License

MIT - Use freely for exam preparation!
