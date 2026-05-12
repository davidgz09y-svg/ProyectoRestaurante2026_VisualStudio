using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data; 
using System.Drawing; 
using System.Linq;
using System.Text;
using System.Runtime.InteropServices;
using System.Threading.Tasks;
using System.Windows.Forms;
namespace ProyectoRestaurante2026_VisualStudio.Login_Seguridad
{
    public partial class Login : Form
    {
        public Login()
        {
            InitializeComponent();

        }

        private void panelTitulo_MouseDown(object sender, MouseEventArgs e)
        {
            ReleaseCapture();
            SendMessage(this.Handle, 0x112, 0xf012, 0);
        }

        private void Login_Load(object sender, EventArgs e)
        {

        }

        private void iconminimizar_Click(object sender, EventArgs e)
        {
            this.WindowState = FormWindowState.Minimized;
        }

        private void iconcerrar_Click(object sender, EventArgs e)
        {
            Application.Exit();
        }

        private void txtUser_Enter(object sender, EventArgs e)
        {
            if(txtUser.Text == "USUARIO"){
                txtUser.Text = "";
                txtUser.ForeColor = Color.FromArgb(20, 73, 70);

            }
        }

        private void txtUser_Leave(object sender, EventArgs e) 
        {
            if (txtUser.Text== ""){
                txtUser.Text = "USUARIO";
                txtUser.ForeColor = Color.FromArgb(79, 161, 141);
            }
        }

        private void txtPass_Enter(object sender, EventArgs e)
        {
            if (txtPass.Text == "CONTRASEÑA") {
                txtPass.Text = "";
                txtPass.ForeColor = Color.FromArgb(20, 73, 70);
                txtPass.UseSystemPasswordChar = true;
            }
        }

        private void txtPass_Leave(object sender, EventArgs e)
        {
            if (txtPass.Text == "")
            {
                txtPass.Text = "CONTRASEÑA";
                txtPass.ForeColor = Color.FromArgb(79, 161, 141);
                txtPass.UseSystemPasswordChar = false;
            }
        }

        [DllImport("user32.DLL", EntryPoint = "ReleaseCapture")]
        private extern static void ReleaseCapture();
        [DllImport("user32.DLL", EntryPoint = "SendMessage")]
        private extern static void SendMessage(System.IntPtr hwnd, int wmsg, int wparam, int lparam);

    }
}
