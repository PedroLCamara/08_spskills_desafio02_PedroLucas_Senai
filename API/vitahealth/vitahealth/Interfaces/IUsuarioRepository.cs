using vitahealth.Domains;

namespace vitahealth.Interfaces
{
    public interface IUsuarioRepository
    {
        Usuario Login(string email, string senha);
        void CriptografarSenha(Usuario _usuario);
    }
}
