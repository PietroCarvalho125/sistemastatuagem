from rotas.login import login, Login
print(login(Login(email='admin@estudio.com', senha='12345')))
print(login(Login(email='funcionario@estudio.com', senha='12345')))
print(login(Login(email='cliente@estudio.com', senha='12345')))
