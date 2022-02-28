namespace vitahealth.Utils
{
    public static class Criptografia
    {
        public static string GerarHash(string Senha)
        {
            return BCrypt.Net.BCrypt.HashPassword(Senha);
        }

        public static bool Comparar(string SenhaForm, string SenhaBanco)
        {
            bool A = BCrypt.Net.BCrypt.Verify(SenhaForm, SenhaBanco);
            return A;
        }

        public static bool ValidarCriptografia(string SenhaBanco)
        {
            if (SenhaBanco.Length >= 32 && SenhaBanco.Substring(0, 1) == "$")
            {
                return true;
            }
            else return false;
        }
    }
}
