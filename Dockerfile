# Build the application
FROM maven:3.9.4-eclipse-temurin-21 AS build
WORKDIR /app

# Copy pom.xml and download dependencies
COPY pom.xml ./
RUN mvn dependency:go-offline -B

# Copy the entire project and build it
COPY . ./
RUN mvn clean package -DskipTests

# Use a lightweight JRE image to run the application
FROM eclipse-temurin:21-jre-alpine
WORKDIR /app

# Copy the built JAR file from the build stage
COPY --from=build /app/target/*.jar app.jar

# Expose the port the app runs on
EXPOSE 8080

# Pass Spring profile and other environment variables
ENV SPRING_PROFILES_ACTIVE=production
ENV JAVA_OPTS=""

# Command to run the application
ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar app.jar"]
