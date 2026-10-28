const API = 'http://127.0.0.1:8000'
const formLogin = document.getElementById('form-login')

if (formLogin) {
  formLogin.addEventListener('submit', async (event) => {
    event.preventDefault()

    const dados = {
      email: document.getElementById('email').value.trim(),
      senha: document.getElementById('senha').value.trim(),
    }

    try {
      const resposta = await fetch(`${API}/login`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(dados),
      })

      const resultado = await resposta.json().catch(() => ({}))

      if (resposta.ok) {
        localStorage.setItem('token', resultado.access_token)
        window.location.href = 'dashboard.html'
        return
      }

      alert('Erro ao entrar: ' + (resultado.erro || 'Credenciais inválidas'))
    } catch (erro) {
      console.error('Erro no login:', erro)
      alert('Não foi possível conectar com a API. Verifique se o backend está rodando em http://127.0.0.1:8000')
    }
  })
}
