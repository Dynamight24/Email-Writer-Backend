FROM eclipse-temurin:17-jdk-alpine as builder
WORKDIR /app

# Copy maven wrapper files first
COPY mvnw .
COPY .mvn .mvn
COPY pom.xml .

# ✅ Ensure mvnw is executable
RUN chmod +x mvnw

# Download dependencies
RUN ./mvnw dependency:go-offline -B

# Copy the rest of the source code
COPY src src

# Build the JAR
RUN ./mvnw package -DskipTests

# Runtime image
FROM eclipse-temurin:17-jre-alpine
WORKDIR /app

COPY --from=builder /app/target/*.jar app.jar

ENTRYPOINT ["java", "-jar", "app.jar"]
