#What it does: Starts with a base image that includes the Java Development Kit (JDK) for Java 21.
#Why: The JDK provides the tools needed to compile and build Java applications
FROM eclipse-temurin:21-jdk AS build

# What it does: Sets the working directory inside the container to /app.
# Why: Ensures all subsequent commands (e.g., file copies) operate in this directory.
WORKDIR /app

#What it does: Copies the Maven wrapper (mvnw) and its configuration files (.mvn/) into the container.
# Why: Maven is needed to download dependencies and build the project.

COPY mvnw ./
COPY .mvn/ .mvn/

# What it does: Ensures the mvnw script is executable.
# Why: Without this step, the container might not have permission to run Maven commands.

RUN chmod +x mvnw



# What it does:
#     Copies the pom.xml file (which lists all project dependencies) into the container.
#     Downloads the required dependencies for the project.
#     Why: Pre-downloading dependencies speeds up the build process by caching them in the container.
COPY pom.xml ./
RUN ./mvnw dependency:go-offline


# What it does: Copies the source code (src/) of the application into the container.
# Why: This is the actual code that will be compiled into the application.
# What it does:
#     Cleans up old build files.
#     Compiles the code and packages it into a JAR file, skipping tests for faster builds.
#     Why: This creates the runnable JAR file, which is the main output of the build stage.
COPY src ./src
RUN ./mvnw clean package -DskipTests



# What it does: Starts with a base image containing only the Java Runtime Environment (JRE) for Java 21.
# Why: The JRE is smaller than the JDK, making the final image more efficient for running the app.

FROM eclipse-temurin:21-jre


# What it does: Sets /app as the working directory for the runtime container.
# Why: Ensures that the application runs from the expected directory.
WORKDIR /app

# What it does: Copies the JAR file generated in the build stage into the runtime container.
# Why: This step transfers the final application artifact (the JAR file) to the runtime environment.

COPY --from=build /app/target/*.jar app.jar



# What it does: Opens port 8080 for the container.
# Why: This allows the app (typically a Spring Boot app) to accept HTTP requests on port 8080.
EXPOSE 8080


# What it does: Specifies the command to run when the container starts: java -jar /app/app.jar.
# Why: This launches the Java application contained in the app.jar file.

ENTRYPOINT ["java", "-jar", "/app/app.jar"]




# 1. Building the Application (Creating the JAR file):
#     Start with a JDK base image (eclipse-temurin:21-jdk) because the JDK includes tools needed to compile and build Java code.
#     Set the working directory to /app.
#     Copy the Maven wrapper and its configuration files to the container so that Maven commands can be run inside it.
#     Copy the pom.xml (dependency descriptor file) to the container and pre-download dependencies to save build time in future runs.
#     Copy the application's source code (src) into the container.
#     Use Maven to clean, compile, and package the application into a JAR file while skipping tests for faster builds.
#     At the end of this stage, the JAR file is created and ready to run.

#     2. Creating the Runtime Container (For the JAR file):
#     Switch to a JRE base image (eclipse-temurin:21-jre) because the JRE is lighter and designed to only run Java applications (it doesn't include the build tools).
#     Set the working directory to /app again.
#     Copy the JAR file generated in the build stage into this runtime container.
#     Expose port 8080, allowing the app to handle HTTP requests on this port.
#     Specify the command to run the application when the container starts:
#     java -jar /app/app.jar.
#     At the end of this stage, you have a lightweight runtime container ready to run the Java application.