# 🚀 Projeto Integrado - Clínica Odontológica (MVP)

Este repositório contém a infraestrutura de orquestração via **Docker Compose** para executar o sistema completo da Clínica Odontológica (Backend, Frontend e Banco de Dados MySQL). 

O ambiente baixa automaticamente os códigos mais recentes diretamente dos repositórios oficiais do GitHub, configura o banco de dados com os scripts estruturais e levanta os serviços de forma automatizada.

---

## 📋 Pré-requisitos

Certifique-se de ter instalado na sua máquina:
* **Docker** (versão 20.10 ou superior)
* **Docker Compose** (versão v2 ou superior)

---

## ⚙️ Como Executar o Projeto

1. Clone este repositório de infraestrutura:
   ```bash
   git clone <URL_DESTE_REPOSITORIO>
   cd <NOME_DA_PASTA>
   ```

2. Suba o ambiente completo utilizando o Docker Compose (o parâmetro `--build` força a clonagem dos códigos mais atualizados do front e do back do GitHub):
   ```bash
   docker compose up --build
   ```

3. Aguarde alguns instantes. O MySQL criará as tabelas e inserirá os usuários de teste automaticamente.

---

## 🌐 Endpoints e Acessos

- **Frontend** (Aplicação Web / Flutter): [http://localhost:8080](http://localhost:8080)
- **Backend** (API / FastAPI - Documentação OpenAPI): [http://localhost:8000/docs](http://localhost:8000/docs)
- **Banco de Dados** (MySQL): `Porta 3306`

---

## 🔑 Credenciais de Teste

| Perfil | E-mail | Senha |
| :--- | :--- | :--- |
| **Administrador** | `admin@uninassau.edu.br` | `123456` |
| **Aluno** | `aluno@uninassau.edu.br` | `123456` |
| **Professor** | `professor@uninassau.edu.br` | `123456` |
| **Recepção** | `recepcao@uninassau.edu.br` | `123456` |