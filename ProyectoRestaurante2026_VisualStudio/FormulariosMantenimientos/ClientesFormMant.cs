using ProyectoRestaurante2026_VisualStudio.Entidades;
using ProyectoRestaurante2026_VisualStudio.Datos;
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

namespace ProyectoRestaurante2026_VisualStudio.FormulariosMantenimientos
{
    public partial class ClientesFormMant : Form
    {

        public bool Editar = false;
        public int idCliente;
        public ClientesFormMant()
        {
            InitializeComponent();
            this.DoubleBuffered = true;

            txtId.BorderStyle = BorderStyle.None; // Quitamos el borde negro
            txtId.AutoSize = false;               // Desactivamos el ajuste automático
            txtId.Height = 25;

            // Suscribir eventos para TextBoxes
            ConfigurarFoco(txtDni);
            ConfigurarFoco(txtNombres);
            ConfigurarFoco(txtDni);
            ConfigurarFoco(txtNombres);
            ConfigurarFoco(txtApellidos);
            ConfigurarFoco(txtCorreo);
            ConfigurarFoco(txtTelefono);
            ConfigurarFoco(txtObservacion);
        }

        // Cambiamos 'TextBox' por 'Control' para que acepte ambos tipos
        private void ConfigurarFoco(Control ctrl)
        {
            ctrl.GotFocus += (s, e) => this.Invalidate();
            ctrl.LostFocus += (s, e) => this.Invalidate();
            // Para el RichTextBox es bueno agregar este por si cambia de tamaño
            ctrl.SizeChanged += (s, e) => this.Invalidate();
        }
        
        [DllImport("user32.DLL", EntryPoint = "ReleaseCapture")]
        private extern static void ReleaseCapture();
        [DllImport("user32.DLL", EntryPoint = "SendMessage")]
        private extern static void SendMessage(System.IntPtr hwnd, int wmsg, int wparam, int lparam);

        private void BarraTitulo_MouseDown(object sender, MouseEventArgs e)
        {
            ReleaseCapture();
            SendMessage(this.Handle, 0x112, 0xf012, 0);
        }

        private void ClientesFormMant_Load(object sender, EventArgs e)
        {
            
        }

        private void ClientesFormMant_Paint(object sender, PaintEventArgs e)
        {
            Color colorBordeEstandar = Color.FromArgb(20, 73, 70);
            Color colorBordeId = Color.FromArgb(188, 206, 187);

            e.Graphics.SmoothingMode = System.Drawing.Drawing2D.SmoothingMode.AntiAlias;

            if (txtId != null)
            {
                int grosorId = 1; // <--- Cambia este número (2 o 3) para más grosor
                using (Pen penId = new Pen(colorBordeId, grosorId))
                {
                    // Dibujamos el rectángulo rodeando exactamente al control
                    Rectangle rectId = new Rectangle(
                        txtId.Location.X - 1,
                        txtId.Location.Y - 1,
                        txtId.Width + 1,
                        txtId.Height + 1
                    );
                    e.Graphics.DrawRectangle(penId, rectId);
                }
            }
        

            // 3. Dibujar el resto de los controles con el borde estándar
            using (Pen penEstandar = new Pen(colorBordeEstandar, 1))
            {
                // NOTA: Aquí YA NO incluyas a txtId
                Control[] controles = { txtDni, txtNombres, txtApellidos, txtCorreo, txtTelefono, txtObservacion };

                foreach (var ctrl in controles)
                {
                    if (ctrl != null)
                    {
                        Rectangle rect = new Rectangle(
                            ctrl.Location.X - 1,
                            ctrl.Location.Y - 1,
                            ctrl.Width + 1,
                            ctrl.Height + 1
                        );
                        e.Graphics.DrawRectangle(penEstandar, rect);
                    }
                }
            }

            // Si tienes más campos, agrégalos aquí siguiendo la misma lógica:
            // Rectangle rectNombre = new Rectangle(txtNombre.Location.X - 3, ...);
            // e.Graphics.DrawRectangle(pen, rectNombre);

            // --- CÓDIGO EXISTENTE DE LOS TEXTBOXES ---
            // (Mantén aquí el código de los rectángulos de txtDni, etc.)

            // --- NUEVO CÓDIGO PARA EL BORDE DEL FORMULARIO ---

            // Usaremos un verde un poco más oscuro o el mismo (79, 161, 141)
            Color colorMarco = Color.FromArgb(20, 73, 70);
                int grosorMarco = 2; // Delgado como en la imagen

                using (Pen penMarco = new Pen(colorMarco, grosorMarco))
                {
                    // Dibujamos un rectángulo que cubra todo el límite del formulario
                    // Restamos 1 al ancho y alto para que la línea no quede fuera de la pantalla
                    e.Graphics.DrawRectangle(penMarco, 0, 0, this.Width - 1, this.Height - 1);
                }
            }

        private void btnCancelar_Click(object sender, EventArgs e)
        {
            this.DialogResult = DialogResult.Cancel;

            this.Close();
        
        }

        private void btnGuardar_Click(object sender, EventArgs e)
        {
            try
            {
                // VALIDACIONES

                if (txtDni.Text.Trim() == "")
                {
                    MessageBox.Show("Ingrese el DNI");
                    txtDni.Focus();
                    return;
                }

                if (!txtDni.Text.All(char.IsDigit))
                {
                    MessageBox.Show("El DNI solo debe contener números");
                    txtDni.Focus();
                    return;
                }

                if (txtDni.Text.Length != 8)
                {
                    MessageBox.Show("El DNI debe tener 8 dígitos");
                    txtDni.Focus();
                    return;
                }

                if (txtNombres.Text.Trim() == "")
                {
                    MessageBox.Show("Ingrese los nombres");
                    txtNombres.Focus();
                    return;
                }

                if (txtApellidos.Text.Trim() == "")
                {
                    MessageBox.Show("Ingrese los apellidos");
                    txtApellidos.Focus();
                    return;
                }

                // OBJETO
                Cliente c = new Cliente();

                c.id_cliente = idCliente;
                c.dni_cliente = txtDni.Text;
                c.nombre_cliente = txtNombres.Text;
                c.apellido_cliente = txtApellidos.Text;
                c.correo_cliente = txtCorreo.Text;
                c.telefono_cliente = txtTelefono.Text;
                c.observacion_cliente = txtObservacion.Text;

                ClienteDal dao = new ClienteDal();

                string respuesta = "";

                // INSERTAR
                if (Editar == false)
                {
                    respuesta = dao.InsertarCliente(c);
                }
                // ACTUALIZAR
                else
                {
                    respuesta = dao.ActualizarCliente(c);
                }

                MessageBox.Show(
                    respuesta,
                    "Sistema",
                    MessageBoxButtons.OK,
                    MessageBoxIcon.Information);

                this.DialogResult = DialogResult.OK;

                this.Close();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
        }
    }
}


