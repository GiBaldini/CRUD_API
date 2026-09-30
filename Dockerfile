# =========================================================================
# ETAPA 1: Build (Compilação do projeto com Maven)
# =========================================================================
FROM maven:3.9.9-eclipse-temurin-17 AS builder

# Define o diretório de trabalho dentro do container
WORKDIR /app

# Copia apenas o pom.xml primeiro para aproveitar o cache de dependências do Docker
COPY pom.xml .

# Baixa as dependências do Maven (evita baixar tudo de novo se o pom.xml não mudou)
RUN mvn dependency:go-offline -B

# Copia a pasta do código-fonte (src) para o container
COPY src ./src

# Executa o build pulando os testes unitários
RUN mvn clean package -DskipTests

# =========================================================================
# ETAPA 2: Runtime (Execução da aplicação com uma imagem leve)
# =========================================================================
FROM eclipse-temurin:17-jre-alpine

# Define o diretório de trabalho no container final
WORKDIR /app

# Copia o .jar gerado na Etapa 1 (builder) para a imagem final
# OBS: Substitua "nome-da-sua-aplicacao" pelo nome real gerado no seu pom.xml
COPY --from=builder /app/target/nome-da-sua-aplicacao-*.jar app.jar

# Expõe a porta padrão que sua aplicação Java costuma usar (ex: 8080)
EXPOSE 8080

# Comando para rodar a aplicação
ENTRYPOINT ["java", "-jar", "app.jar"]
