FROM microsoft/dotnet:2.2-sdk AS build
WORKDIR /app

# copy csproj and restore as distinct layers
COPY *.sln .
COPY Notez.App/*.csproj ./Notez.App/
RUN dotnet restore

# copy everything else and build app
COPY Notez.App/. ./Notez.App/
WORKDIR /app/Notez.App
RUN dotnet publish -c Debug -o out

FROM microsoft/dotnet:2.2-aspnetcore-runtime AS runtime
WORKDIR /app
COPY --from=build /app/Notez.App/out ./
RUN apt-get update 
RUN apt-get install -y --no-install-recommends apt-utils 
RUN apt-get install -y curl unzip procps
RUN curl -sSL https://aka.ms/getvsdbgsh | bash /dev/stdin -v latest -l /publish/vsdbg;
ENTRYPOINT ["dotnet", "Notez.App.dll"]