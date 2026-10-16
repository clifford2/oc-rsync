# rsync container image

Container image for use by OpenShift `oc rsync` as a CP4BA `data-loader` pod.

## Build

Build with:

```sh
podman build -t docker.io/cliffordw/rsync:10.2-1791891203 .
```

## Use

Example deployment for target pod:

```yaml
---
apiVersion: v1
kind: Pod
metadata:
  name: data-loader
  namespace: cp4ba
spec:
  containers:
    - name: loader
      # image: registry.access.redhat.com/ubi9/ubi:latest
      image: docker.io/cliffordw/rsync:10.2-1791891203
      command: ["sleep", "infinity"]
      volumeMounts:
        - name: filestore
          mountPath: /mnt/filestore
      resources:
        requests:
          memory: "256Mi"
          cpu: "250m"
        limits:
          memory: "512Mi"
          cpu: "500m"
  volumes:
    - name: filestore
      persistentVolumeClaim:
        claimName: cp4ba-cpe-filestore-pvc
```

Sync with:

```sh
# oc rsync <source> <destination> [-c <container>]
oc -n cp4ba rsync /mnt/winfilestore/ data-loader:/mnt/filestore/ --progress
```

## oc rsync doc

Doc for `oc rsync`: [Copying files to or from OKD containers](https://docs.okd.io/4.19/nodes/containers/nodes-containers-copying-files.html).

Key requirement: `rsync` must be installed both on the client machine and in the target pod.

Prerequisites:

- rsync must be installed. The `oc rsync` command uses the local `rsync` tool, if present on the client machine and the remote container.
- If `rsync` is not found locally or in the remote container, a tar archive is created locally and sent to the container where the tar utility is used to extract the files. If tar is not available in the remote container, the copy will fail.
- The tar copy method does not provide the same functionality as `oc rsync`. For example, `oc rsync` creates the destination directory if it does not exist and only sends files that are different between the source and the destination.
