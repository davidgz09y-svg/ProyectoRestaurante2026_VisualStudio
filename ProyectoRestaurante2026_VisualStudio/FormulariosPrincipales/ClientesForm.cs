using ProyectoRestaurante2026_VisualStudio.FormulariosMantenimientos;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
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
        }

        private void button1_Click(object sender, EventArgs e)
        {
            
        }

        private void ClientesForm_Load(object sender, EventArgs e)
        {
            InsertarFilas();
        }

        private void InsertarFilas()
        {
            dataGridView1.Rows.Insert(0, "1", "Rafael", "Fernandezzzzzzzzzz", "AV. Melgar", "56465");
            dataGridView1.Rows.Insert(1, "2", "Rafael", "Fernandez", "AV. Melgar", "56465");
            dataGridView1.Rows.Insert(2, "3", "Rafael", "Fernandez", "AV. Melgar", "56465");
            dataGridView1.Rows.Insert(3, "4", "Rafael", "Fernandez", "AV. Melgar", "56465");
            dataGridView1.Rows.Insert(4, "5", "Rafael", "Fernandez", "AV. Melgar", "56465");
            dataGridView1.Rows.Insert(5, "6", "Rafael", "Fernandez", "AV. Melgar", "56465");
            dataGridView1.Rows.Insert(6, "7", "Rafael", "Fernandez", "AV. Melgar", "56465");
            dataGridView1.Rows.Insert(7, "8", "Rafael", "Fernandez", "AV. Melgar", "56465");
            dataGridView1.Rows.Insert(8, "9", "Rafael", "Fernandez", "AV. Melgar", "56465");
            dataGridView1.Rows.Insert(9, "10", "Rafael", "Fernandez", "AV. Melgar", "56465");
            dataGridView1.Rows.Insert(10, "11", "Rafael", "Fernandez", "AV. Melgar", "56465");
            dataGridView1.Rows.Insert(11, "12", "Rafael", "Fernandez", "AV. Melgar", "56465");
            dataGridView1.Rows.Insert(12, "13", "Rafael", "Fernandez", "AV. Melgar", "56465");
            dataGridView1.Rows.Insert(13, "14", "Rafael", "Fernandez", "AV. Melgar", "56465");
            dataGridView1.Rows.Insert(14, "15", "Rafael", "Fernandez", "AV. Melgar", "56465");
            dataGridView1.Rows.Insert(15, "16", "Rafael", "Fernandez", "AV. Melgar", "56465");
            dataGridView1.Rows.Insert(16, "17", "Rafael", "Fernandez", "AV. Melgar", "56465");
            dataGridView1.Rows.Insert(17, "18", "Rafael", "Fernandez", "AV. Melgar", "56465");
            dataGridView1.Rows.Insert(18, "19", "Rafael", "Fernandez", "AV. Melgar", "56465");
            dataGridView1.Rows.Insert(19, "20", "Rafael", "Fernandez", "AV. Melgar", "56465");
        }

        private void button3_Click(object sender, EventArgs e)
        {
            ClientesFormMant frm = new ClientesFormMant();
            frm.ShowDialog();
        }
    }
}