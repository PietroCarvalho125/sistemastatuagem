# ============================================================
# main.py — API do Estúdio de Tatuagem
# Descrição: Endpoints para gerenciar clientes, tatuadores,
#            agendamentos, seniores, estilos, login e usuários.
# Como rodar: uvicorn main:app --reload
# ============================================================

import os

from fastapi import Depends, FastAPI
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles

from rotas import agendamentos, clientes, estilos, login, senioridade, tatuadores, usuarios
from seguranca import verificar_admin, verificar_token

app = FastAPI(title="Estúdio de Tatuagem API")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

os.makedirs("uploads", exist_ok=True)
app.mount("/uploads", StaticFiles(directory="uploads"), name="uploads")

# Ordem visual no /docs
app.include_router(login.router, tags=["Login"])
app.include_router(usuarios.router, prefix="/usuarios", tags=["Usuários"], dependencies=[Depends(verificar_admin)])
app.include_router(clientes.router, prefix="/clientes", tags=["Clientes"], dependencies=[Depends(verificar_token)])
app.include_router(senioridade.router, prefix="/senioridade", tags=["Senioridade"], dependencies=[Depends(verificar_token)])
app.include_router(estilos.router, prefix="/estilos", tags=["Estilos"], dependencies=[Depends(verificar_token)])
app.include_router(tatuadores.router, prefix="/tatuadores", tags=["Tatuadores"], dependencies=[Depends(verificar_token)])
app.include_router(agendamentos.router, prefix="/agendamentos", tags=["Agendamentos"], dependencies=[Depends(verificar_token)])


@app.get("/")
def inicio():
    return {"mensagem": "API do estúdio de tatuagem funcionando!"}
