using ProyectoRestaurante2026_VisualStudio.Datos;
using ProyectoRestaurante2026_VisualStudio.Entidades;
using ProyectoRestaurante2026_VisualStudio.FormulariosMantenimientos;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Runtime.InteropServices;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace ProyectoRestaurante2026_VisualStudio.Formularios
{
    public partial class ClientesForm : Form
    {
        public ClientesForm()
        {
            InitializeComponent();
            dataGridView1.ClearSelection(); // Quita el azul/verde de la fila
            dataGridView1.CurrentCell = null; // Quita el foco de la celda específica

            txtBuscar.Focus(); // Mandamos al usuario a buscar directamente
            // Primero configuramos el estilo
            txtBuscar.BorderStyle = BorderStyle.None;
            txtBuscar.AutoSize = false;
            txtBuscar.Height = 25;

            // AL FINAL llamamos a la API
            SendMessage(txtBuscar.Handle, EM_SETCUEBANNER, 1, "Buscar:");
        }

        [DllImport("user32.dll", CharSet = CharSet.Auto)]
        private static extern Int32 SendMessage(IntPtr hWnd, int msg, int wParam, [MarshalAs(UnmanagedType.LPWStr)] string lParam);

        private const int EM_SETCUEBANNER = 0x1501;

        private void btnNuevo_Click(object sender, EventArgs e)
        {
            // Guardar fila actual
            int filaActual = 0;

            if (dataGridView1.CurrentRow != null)
            {
                filaActual = dataGridView1.CurrentRow.Index;
            }

            ClientesFormMant frm = new ClientesFormMant();
            if (frm.ShowDialog() == DialogResult.OK)
            {
                // Recargar datos
                MostrarClientes();

                // Ir a la última fila
                if (dataGridView1.Rows.Count > 0)
                {
                    int ultimaFila = dataGridView1.Rows.Count - 1;

                    dataGridView1.CurrentCell =
                        dataGridView1.Rows[ultimaFila].Cells[0];

                    dataGridView1.FirstDisplayedScrollingRowIndex =
                        ultimaFila;
                }
            }
            else
            {
                // Volver a la fila donde estaba
                if (dataGridView1.Rows.Count > filaActual)
                {
                    dataGridView1.CurrentCell =
                        dataGridView1.Rows[filaActual].Cells[0];

                    dataGridView1.FirstDisplayedScrollingRowIndex =
                        filaActual;
                }
            }

        }

        private void ClientesForm_Load(object sender, EventArgs e)
        {
            MostrarClientes();
        }

        private void MostrarClientes()
        {
            ClienteDal dao = new ClienteDal();

            dataGridView1.DataSource = dao.MostrarCliente();
            
        }

        private void txtBuscar_TextChanged(object sender, EventArgs e)
        {
            ClienteDal cliente = new ClienteDal();

            dataGridView1.DataSource =
                cliente.BuscarClientes(txtBuscar.Text);
        }
        protected override void OnShown(EventArgs e)
        {
            base.OnShown(e);

            // 1. Esto desmarca la fila que Windows marcó por defecto al abrir
            dataGridView1.ClearSelection();

            // 2. Esto quita el foco de la celda para que no se vea el recuadro de puntos
            dataGridView1.CurrentCell = null;

            // 3. Aseguramos que el foco esté en el buscador y no en la tabla
            txtBuscar.Focus();
        }

        private void btnEditar_Click(object sender, EventArgs e)
        {
            // VALIDAR SI HAY FILA SELECCIONADA
            if (dataGridView1.CurrentRow == null)
            {
                MessageBox.Show(
                    "Seleccione una fila para editar",
                    "Mensaje",
                    MessageBoxButtons.OK,
                    MessageBoxIcon.Warning);

                return;
            }

            // GUARDAR POSICIÓN ACTUAL
            int filaSeleccionada = dataGridView1.CurrentRow.Index;

            // ABRIR FORMULARIO
            ClientesFormMant frm = new ClientesFormMant();

            // MODO EDITAR
            frm.Editar = true;

            // ENVIAR ID
            frm.idCliente = Convert.ToInt32(
                dataGridView1.CurrentRow.Cells[0].Value);

            // LLENAR CAMPOS
            frm.txtId.Text =
                dataGridView1.CurrentRow.Cells[0].Value.ToString();

            frm.txtDni.Text =
                dataGridView1.CurrentRow.Cells[1].Value.ToString();

            frm.txtNombres.Text =
                dataGridView1.CurrentRow.Cells[2].Value.ToString();

            frm.txtApellidos.Text =
                dataGridView1.CurrentRow.Cells[3].Value.ToString();

            frm.txtCorreo.Text =
                dataGridView1.CurrentRow.Cells[4].Value.ToString();

            frm.txtTelefono.Text =
                dataGridView1.CurrentRow.Cells[5].Value.ToString();

            frm.txtObservacion.Text =
                dataGridView1.CurrentRow.Cells[6].Value.ToString();

            // ABRIR
            if (frm.ShowDialog() == DialogResult.OK)
            {
                // RECARGAR
                MostrarClientes();

                // VOLVER A LA FILA
                dataGridView1.ClearSelection();

                dataGridView1.Rows[filaSeleccionada].Selected = true;

                dataGridView1.CurrentCell =
                    dataGridView1.Rows[filaSeleccionada].Cells[0];

                // HACER SCROLL HACIA ESA FILA
                dataGridView1.FirstDisplayedScrollingRowIndex =
                    filaSeleccionada;
            }
        }

        private void btnEliminar_Click(object sender, EventArgs e)
        {
            if (dataGridView1.CurrentRow == null)
            {
                MessageBox.Show(
                    "Seleccione una fila",
                    "Mensaje",
                    MessageBoxButtons.OK,
                    MessageBoxIcon.Warning);

                return;
            }

            DialogResult resultado = MessageBox.Show(
                "¿Desea eliminar este cliente?",
                "Confirmación",
                MessageBoxButtons.YesNo,
                MessageBoxIcon.Question);

            if (resultado == DialogResult.Yes)
            {
                Cliente c = new Cliente();

                c.id_cliente = Convert.ToInt32(
                    dataGridView1.CurrentRow.Cells[0].Value);

                ClienteDal dao = new ClienteDal();

                MessageBox.Show(
                    dao.EliminarCliente(c));

                // RECARGAR GRID
                MostrarClientes();
            }
        }
    }
}