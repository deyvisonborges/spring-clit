#!/bin/bash

echo "Escolha as dependências para o seu projeto Spring Boot:"
echo "Digite os números das dependências que deseja incluir, separados por espaços."
echo "Exemplo: 1 3 5"
echo

# Lista de dependências disponíveis
options=(
  "Spring Web"
  "Spring Data JPA"
  "Spring Security"
  "Spring Boot DevTools"
  "Spring Actuator"
  "Spring Rest Repositories"
  "Spring Validation"
  "Lombok"
  "Spring Cloud"
  "Spring WebFlux"
  "Spring GraphQL"
  "MySQL Driver"
)

# Exibir a lista de dependências com números
for i in "${!options[@]}"; do
  echo "$((i + 1))) ${options[$i]}"
done

# Ler as escolhas do usuário
read -p "Escolha as dependências (números separados por espaço): " choices

# Inicializar a variável de dependências
dependencies=""

# Mapear as escolhas do usuário para os nomes corretos do Spring Initializr
for choice in $choices; do
  case $choice in
  1) dependencies+="web," ;;
  2) dependencies+="data-jpa," ;;
  3) dependencies+="security," ;;
  4) dependencies+="devtools," ;;
  5) dependencies+="actuator," ;;
  6) dependencies+="rest-repositories," ;;
  7) dependencies+="validation," ;;
  8) dependencies+="lombok," ;;
  9) dependencies+="cloud," ;;
  10) dependencies+="webflux," ;;
  11) dependencies+="graphql," ;;
  12) dependencies+="mysql," ;;
  *) echo "Opção inválida: $choice" ;;
  esac
done

# Remover a vírgula final das dependências
dependencies=${dependencies%,}

# Verificar se o usuário escolheu pelo menos uma dependência
if [ -z "$dependencies" ]; then
  echo "Nenhuma dependência selecionada. Abortando."
  exit 1
fi

# Nome do projeto
read -p "Nome do projeto: " projectName

# Definir outros parâmetros
groupId="com.studiode"
artifactId="$projectName"
description="Demo project for Spring Boot"
packageName="com.studiode.$projectName"
type="gradle-project" # Pode ser mudado para "maven-project" se necessário
platformVersion="3.3.4"
jvmVersion="21"
packaging="jar"

# Codificar os parâmetros corretamente para a URL
description=$(echo $description | sed 's/ /%20/g')
packageName=$(echo $packageName | sed 's/ /%20/g')
projectName=$(echo $projectName | sed 's/ /%20/g')

# Executar o cURL para baixar o projeto Spring Boot
curl "https://start.spring.io/starter.zip?type=$type&language=java&platformVersion=$platformVersion&packaging=$packaging&jvmVersion=$jvmVersion&groupId=$groupId&artifactId=$artifactId&name=$projectName&description=$description&packageName=$packageName&dependencies=$dependencies" -o "$projectName.zip"

# Verificar se o arquivo ZIP foi baixado com sucesso
if [ $? -ne 0 ]; then
  echo "Falha ao baixar o projeto Spring Boot. Verifique sua conexão."
  exit 1
fi

# Descompactar o projeto
unzip "$projectName.zip" -d "$projectName"

# Remover o arquivo zip após a extração
rm "$projectName.zip"

echo "Projeto Spring Boot '$projectName' criado com as dependências: $dependencies"
