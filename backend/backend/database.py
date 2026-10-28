# ============================================================
# database.py — Conexão com o MySQL
# Descrição: Função que abre a conexão com o banco de dados
#            usando as variáveis do arquivo .env.
# ============================================================

import os

import pymysql
from dotenv import load_dotenv

load_dotenv()


def conectar():
    # Cria e retorna uma conexão com o banco de dados
    return pymysql.connect(
        host=os.getenv("DB_HOST"),
        user=os.getenv("DB_USER"),
        password=os.getenv("DB_PASSWORD"),
        database=os.getenv("DB_NAME"),
        cursorclass=pymysql.cursors.DictCursor,
        autocommit=True,
    )
