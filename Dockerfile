# =========================================================================
# ETAPA 1: Build (Atualizado para Java 21)
# =========================================================================
FROM maven:3.9.9-eclipse-temurin-21 AS builder

WORKDIR /app

# Copia o pom.xml e baixa as dependências
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copia o código-fonte e compila o projeto
COPY src ./src
RUN mvn clean package -DskipTests

# =========================================================================
# ETAPA 2: Runtime (Atualizado para Java 21)
# =========================================================================
FROM eclipse-temurin:21-jre-alpine

WORKDIR /app

# Copia o .jar gerado usando o nome do seu artefato "CadastroDeProduto"
COPY --from=builder /app/target/CadastroDeProduto-*.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
