using System.ComponentModel.DataAnnotations;
using System.ComponentModel;

namespace ProyectoIntegrador_PZ_KS_DM.Models

{
    public class LoginViewModel
    {
        [Required(ErrorMessage = "El correo electronico es requerido.")]
        [EmailAddress(ErrorMessage = "Por favor, introduce un correo electronico valido.")]
        public string? Correo { get; set; }

        [DataType(DataType.Password)]
        public string? Contrasenia { get; set; }

        [DisplayName("Mantener sesion activa.")]
        public bool MantenerActivo { get; set; }
    }
}
