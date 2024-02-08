namespace InstrSet
{
    partial class Form1
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.btnProcessCsv = new System.Windows.Forms.Button();
            this.btnConvertToCsv = new System.Windows.Forms.Button();
            this.btnGatherInstrHandlers = new System.Windows.Forms.Button();
            this.SuspendLayout();
            // 
            // btnProcessCsv
            // 
            this.btnProcessCsv.Location = new System.Drawing.Point(374, 60);
            this.btnProcessCsv.Name = "btnProcessCsv";
            this.btnProcessCsv.Size = new System.Drawing.Size(204, 69);
            this.btnProcessCsv.TabIndex = 0;
            this.btnProcessCsv.Text = "Process CSV File";
            this.btnProcessCsv.UseVisualStyleBackColor = true;
            this.btnProcessCsv.Click += new System.EventHandler(this.btnProcessCsv_Click);
            // 
            // btnConvertToCsv
            // 
            this.btnConvertToCsv.Enabled = false;
            this.btnConvertToCsv.Location = new System.Drawing.Point(113, 60);
            this.btnConvertToCsv.Name = "btnConvertToCsv";
            this.btnConvertToCsv.Size = new System.Drawing.Size(204, 69);
            this.btnConvertToCsv.TabIndex = 0;
            this.btnConvertToCsv.Text = "Convert To CSV";
            this.btnConvertToCsv.UseVisualStyleBackColor = true;
            this.btnConvertToCsv.Click += new System.EventHandler(this.btnConvertToCsv_Click);
            // 
            // btnGatherInstrHandlers
            // 
            this.btnGatherInstrHandlers.Enabled = false;
            this.btnGatherInstrHandlers.Location = new System.Drawing.Point(263, 202);
            this.btnGatherInstrHandlers.Name = "btnGatherInstrHandlers";
            this.btnGatherInstrHandlers.Size = new System.Drawing.Size(170, 67);
            this.btnGatherInstrHandlers.TabIndex = 1;
            this.btnGatherInstrHandlers.Text = "Gather Instruction Handlers";
            this.btnGatherInstrHandlers.UseVisualStyleBackColor = true;
            this.btnGatherInstrHandlers.Click += new System.EventHandler(this.btnGatherInstrHandlers_Click);
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(701, 325);
            this.Controls.Add(this.btnGatherInstrHandlers);
            this.Controls.Add(this.btnConvertToCsv);
            this.Controls.Add(this.btnProcessCsv);
            this.Name = "Form1";
            this.Text = "Form1";
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.Button btnProcessCsv;
        private System.Windows.Forms.Button btnConvertToCsv;
        private System.Windows.Forms.Button btnGatherInstrHandlers;
    }
}

