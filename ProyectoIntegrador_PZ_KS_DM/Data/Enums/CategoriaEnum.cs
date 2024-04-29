using System.ComponentModel;

namespace ProyectoIntegrador_PZ_KS_DM.Data.Enums
{
    public enum CategoriaEnum
    {
        [Description("Noticias recientes")]
        Noticias,
        [Description("Opiniones recientes")]
        Opinion,
        [Description("Informacion")]
        Bienestar,
        [Description("Herramientas")]
        Recursos,
        [Description("Recursos de aprendizaje")]
        Tutoriales
    }
}