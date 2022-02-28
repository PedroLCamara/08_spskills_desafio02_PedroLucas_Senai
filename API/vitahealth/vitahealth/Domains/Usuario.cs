using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

#nullable disable

namespace vitahealth.Domains
{
    public partial class Usuario
    {
        public int Id { get; set; }
        [Required(ErrorMessage = "Email inválido")]
        public string Email { get; set; }
        [Required(ErrorMessage = "Senha inválida")]
        public string Senha { get; set; }
    }
}