FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 8082

ENV ASPNETCORE_URLS=http://+:8082

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["KubenetesTest001.csproj", "./"]
RUN dotnet restore "KubenetesTest001.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "KubenetesTest001.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "KubenetesTest001.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "KubenetesTest001.dll"]
