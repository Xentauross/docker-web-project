# syntax=docker/dockerfile:1.4

# ── STAGE 1: Compilation with Maven ────────────────────
FROM --platform=$BUILDPLATFORM maven:3.9-eclipse-temurin-17-alpine AS builder

WORKDIR /workdir/server
COPY pom.xml /workdir/server/pom.xml
RUN mvn dependency:go-offline

COPY src /workdir/server/src
RUN mvn install -DskipTests

# ── STAGE 2: Prepare the JAR Layers ───────────────────
FROM builder AS prepare-production

RUN mkdir -p target/dependency
WORKDIR /workdir/server/target/dependency
RUN jar -xf ../*.jar

# ── STAGE 3: Final image (production) ─────────
FROM eclipse-temurin:17-jre-alpine AS production

# Non-root user for security
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

EXPOSE 8080
VOLUME /tmp

ARG DEPENDENCY=/workdir/server/target/dependency
COPY --from=prepare-production ${DEPENDENCY}/BOOT-INF/lib /app/lib
COPY --from=prepare-production ${DEPENDENCY}/META-INF /app/META-INF
COPY --from=prepare-production ${DEPENDENCY}/BOOT-INF/classes /app

USER appuser

ENTRYPOINT ["java", "-cp", "app:app/lib/*", "com.company.project.Application"]