# Use the official .NET SDK image to build the application
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build

# Set the working directory in the container
WORKDIR /app

# Copy the .csproj files and restore any dependencies
COPY ["1. WebAPI/CFS.WebAPI/CFS.WebAPI.csproj","CFS.WebAPI/"]
COPY ["2. BusinessLogic/CFS.BusinessLogic/CFS.BusinessLogic.csproj","CFS.BusinessLogic/"]
COPY ["3. DataAccess/CFS.Data/CFS.Data.csproj","CFS.Data/"]
COPY ["4. Infrastructure/CFS.Model/CFS.Model.csproj","CFS.Model/"]
RUN dotnet restore "CFS.WebAPI/CFS.WebAPI.csproj"


# Copy the rest of the application code and build the application
COPY . ./
RUN dotnet publish -c Release -o out

# Use the official .NET runtime image to run the application
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS runtime
WORKDIR /app
COPY --from=build /app/out .


# Define the entry point for the container
ENTRYPOINT ["dotnet", "CFS.WebAPI.dll"]
