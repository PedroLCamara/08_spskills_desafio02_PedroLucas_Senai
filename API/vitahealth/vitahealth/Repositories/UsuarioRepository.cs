using System.Linq;
using vitahealth.Contexts;
using vitahealth.Domains;
using vitahealth.Interfaces;
using vitahealth.Utils;

namespace vitahealth.Repositories
{
    public class UsuarioRepository : IUsuarioRepository
    {
        private readonly vitahealthContext ctx;

        public UsuarioRepository(vitahealthContext appContext)
        {
            ctx = appContext;
        }

        public async void CriptografarSenha(Usuario _usuario)
        {
            _usuario.Senha = Criptografia.GerarHash(_usuario.Senha);
            ctx.Usuarios.Update(_usuario);
            await ctx.SaveChangesAsync();
        }

        public Usuario Login(string email, string senha)
        {
            var usuario = ctx.Usuarios.FirstOrDefault(u => u.Email == email);

            if (usuario != null)
            {
                if (Criptografia.ValidarCriptografia(usuario.Senha) == true)
                {
                    bool confere = Criptografia.Comparar(senha, usuario.Senha);
                    if (confere)
                        return usuario;
                }
                else
                {
                    CriptografarSenha(usuario);
                    bool confere = Criptografia.Comparar(senha, usuario.Senha);
                    if (confere)
                        return usuario;
                }
            }

            return null;
        }
    }
}
