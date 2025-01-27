
# loop printing the current time then sleeping one second

while true; do
  echo "Continuous WebJob Current time: $(date)"
  echo "DOCKER_REGISTRY_SERVER_URL: $DOCKER_REGISTRY_SERVER_URL"
  echo "TEST_ENV: $TEST_ENV"
  sleep 1
done
#dotnet ./WebJobContinuous.dll