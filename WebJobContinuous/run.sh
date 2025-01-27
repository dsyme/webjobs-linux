
# loop printing the current time then sleeping one second

while true; do
  echo "Continuous WebJob Current time: $(date)"
  sleep 1
done
#dotnet ./WebJobContinuous.dll