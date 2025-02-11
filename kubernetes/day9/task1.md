## Task details

   - Login to your cluster and create a pod with the image name as registry.k8s.io/busybox
   - Use the below command for the container 
   touch /tmp/healthy; sleep 30; rm -f /tmp/healthy; sleep 600
   - Create a livenessprobe that executes the command cat /tmp/healthy after every 5 seconds, the first check should be after 5 seconds
   - Create another pod with the image name as registry.k8s.io/e2e-test-images/agnhost:2.40
   - Add the liveness and readiness probes that perform health checks on port 8080 on the path /healthz , the checks should start after 5 seconds for every 10 seconds
