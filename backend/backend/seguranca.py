# ============================================================
# seguranca.py — Verificação do token JWT
# Descrição: Função usada pelas rotas protegidas para conferir
#            se quem está fazendo a requisição tem um token válido.
# ============================================================

import os

import jwt
from fastapi import Depends, HTTPException
from fastapi.security import HTTPAuthorizationCredentials, HTTPBearer

SECRET_KEY = os.getenv("SECRET_KEY")
ALGORITMO = "HS256"

# HTTPBearer() é o que faz o botão "Authorize" aparecer no /docs
esquema_token = HTTPBearer()


# "Segurança de porta" — confere se o token que veio na requisição é válido
def verificar_token(credenciais: HTTPAuthorizationCredentials = Depends(esquema_token)):
    token = credenciais.credentials

    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITMO])
        return payload
    except jwt.ExpiredSignatureError:
        raise HTTPException(status_code=401, detail="Token expirado, faça login de novo")
    except jwt.InvalidTokenError:
        raise HTTPException(status_code=401, detail="Token inválido")


# Segurança mais rigorosa — além de conferir o token, exige que seja admin
def verificar_admin(payload: dict = Depends(verificar_token)):
    if payload.get("tipo") != "admin":
        raise HTTPException(status_code=403, detail="Acesso restrito a administradores")
    return payload
