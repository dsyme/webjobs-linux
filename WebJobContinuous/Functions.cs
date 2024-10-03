using Microsoft.Azure.WebJobs;
using Microsoft.Extensions.Logging;

namespace WebJob;

public class Functions
{
    public static void ProcessQueueMessage([QueueTrigger("webjobs-linux-queue")] string message, ILogger logger)
    {
        logger.LogInformation($"Continuous Job received message: {message}");
    }
}