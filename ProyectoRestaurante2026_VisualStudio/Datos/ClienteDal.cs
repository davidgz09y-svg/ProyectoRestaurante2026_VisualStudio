using ProyectoRestaurante2026_VisualStudio.Entidades;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ProyectoRestaurante2026_VisualStudio.Datos
{
    public class ClienteDal
    {

        Conexion cn = new Conexion();
         
        public DataTable MostrarCliente()
        {
            using (SqlConnection con = cn.GetConexion())
            {
                SqlDataAdapter da = new SqlDataAdapter("SELECT * FROM vista_cliente", con);
                DataTable dt = new DataTable();
                da.Fill(dt);
                return dt;
            }
        }

        public DataTable BuscarClientes(string texto)
        {
            using (SqlConnection con = cn.GetConexion())
            {
                SqlCommand cmd = new SqlCommand("buscar_cliente", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@p_param", texto);
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);
                return dt;
            }
        }

        public string InsertarCliente(Cliente d)
        {
            using (SqlConnection con = cn.GetConexion())
            {
                SqlCommand cmd = new SqlCommand("insertar_cliente", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@p_dni", d.dni_cliente);
                cmd.Parameters.AddWithValue("@p_nombre", d.nombre_cliente);
                cmd.Parameters.AddWithValue("@p_apellido", d.apellido_cliente);
                cmd.Parameters.AddWithValue(
                    "@p_correo",
                    (object)d.correo_cliente ?? DBNull.Value);
                cmd.Parameters.AddWithValue(
                    "@p_telefono",
                    (object)d.telefono_cliente ?? DBNull.Value);
                cmd.Parameters.AddWithValue(
                    "@p_observacion",
                    (object)d.observacion_cliente ?? DBNull.Value);
                con.Open();
                object result = cmd.ExecuteScalar();
                return result != null
                    ? result.ToString()
                    : "No se recibió respuesta del servidor";
            }
        }

        public string ActualizarCliente(Cliente d)
        {
            using (SqlConnection con = cn.GetConexion())
            {
                SqlCommand cmd = new SqlCommand("actualizar_cliente", con);

                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue(
                    "@p_id_cliente",
                    d.id_cliente);

                cmd.Parameters.AddWithValue(
                    "@p_dni",
                    d.dni_cliente);

                cmd.Parameters.AddWithValue(
                    "@p_nombre",
                    d.nombre_cliente);

                cmd.Parameters.AddWithValue(
                    "@p_apellido",
                    d.apellido_cliente);

                cmd.Parameters.AddWithValue(
                    "@p_correo",
                    (object)d.correo_cliente ?? DBNull.Value);

                cmd.Parameters.AddWithValue(
                    "@p_telefono",
                    (object)d.telefono_cliente ?? DBNull.Value);

                cmd.Parameters.AddWithValue(
                    "@p_observacion",
                    (object)d.observacion_cliente ?? DBNull.Value);

                con.Open();

                object result = cmd.ExecuteScalar();

                return result != null
                    ? result.ToString()
                    : "No se recibió respuesta del servidor";
            }
        }

        public string EliminarCliente(Cliente d)
        {
            using (SqlConnection con = cn.GetConexion())
            {
                SqlCommand cmd = new SqlCommand(
                    "Desactivar_Cliente",
                    con);

                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue(
                    "@p_id_cliente",
                    d.id_cliente);

                con.Open();

                object result = cmd.ExecuteScalar();

                return result != null
                    ? result.ToString()
                    : "No se recibió respuesta del servidor";
            }
        }

    }
}
