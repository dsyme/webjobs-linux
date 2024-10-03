FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
USER $APP_UID
WORKDIR /app
EXPOSE 8080

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src
COPY ["WebApi/WebApi.csproj", "WebApi/"]
RUN dotnet restore "WebApi/WebApi.csproj"
COPY . .
WORKDIR "/src/WebApi"
RUN dotnet build "WebApi.csproj" -c $BUILD_CONFIGURATION -o /app/build

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build-cont-webjob
ARG BUILD_CONFIGURATION=Release
WORKDIR /src
COPY ["WebJobContinuous/WebJobContinuous.csproj", "WebJobContinuous/"]
RUN dotnet restore "WebJobContinuous/WebJobContinuous.csproj"
COPY . .
WORKDIR "/src/WebJobContinuous"
RUN dotnet publish "WebJobContinuous.csproj" -c $BUILD_CONFIGURATION -o /app/publish

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build-trig-webjob
ARG BUILD_CONFIGURATION=Release
WORKDIR /src
COPY ["WebJobTriggered/WebJobTriggered.csproj", "WebJobTriggered/"]
RUN dotnet restore "WebJobTriggered/WebJobTriggered.csproj"
COPY . .
WORKDIR "/src/WebJobTriggered"
RUN dotnet publish "WebJobTriggered.csproj" -c $BUILD_CONFIGURATION -o /app/publish

FROM build AS publish
ARG BUILD_CONFIGURATION=Release
RUN dotnet publish "WebApi.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
COPY --from=build-cont-webjob /app/publish app_data/jobs/continuous/webjob-continuous
COPY --from=build-trig-webjob /app/publish app_data/jobs/triggered/webjob-triggered
ENTRYPOINT ["dotnet", "WebApi.dll"]
