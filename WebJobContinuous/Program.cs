using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;

namespace WebJob;

class Program
{
    static async Task Main()
    {
        var builder = new HostBuilder();
        builder.ConfigureWebJobs(b =>
        {
            b.AddAzureStorageCoreServices();
            b.AddAzureStorageQueues();
        });
        builder.ConfigureLogging((context, b) =>
        {
            b.AddConsole();
        });
        
        using var host = builder.Build();
        await host.RunAsync();
    }
}