using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ProyectoRestaurante2026_VisualStudio.Datos
{
    public class Conexion
    {
        private string cadena = "Server=(localdb)\\MSSQLLocalDB;Database=db_restaurant;Trusted_Connection=True";

        public SqlConnection GetConexion()
        {
            return new SqlConnection(cadena);
        }
    }
}
