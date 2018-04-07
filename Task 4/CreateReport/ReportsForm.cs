using System;
using System.Collections.Generic;
using System.Drawing;
using System.Windows.Forms;
using System.IO;
using System.Xml;
using GrapeCity.ActiveReports.Design;
using GrapeCity.ActiveReports.Design.Resources;

namespace GrapeCity.ActiveReports.Samples.CreateReport
{
	public partial class ReportsForm : Form
	{
        private string filePath = Environment.GetFolderPath(Environment.SpecialFolder.MyDocuments) + @"\GrapeCity Samples\ActiveReports 12\";
        private string fileName = "Untitled.rpx";
        private string reportName;        
        private ToolStripButton exprt;

        public ReportsForm()
		{
			InitializeComponent();
            
            reportName = filePath + fileName;

            reportDesigner.NewReport(DesignerReportType.Section);//Sets the designer to create a blank page based report
                                                                 //Populating the ToolBox,reportExplorer and Propertygrid
            reportDesigner.Toolbox = reportToolbox;//Attaches the toolbox to the report designer
            reportExplorer.ReportDesigner = reportDesigner;//Attaches the report explorer to the report designer
            this.Icon = Properties.Resources.arLogo_32;
            layerList.ReportDesigner = reportDesigner;
            groupEditor.ReportDesigner = reportDesigner;
            reportsLibrary.ReportDesigner = reportDesigner;
            reportDesigner.PropertyGrid = propertyGrid;//Attaches the Property Grid to the report designer
                                                       //Populating the Menu
            ToolStrip toolStrip = reportDesigner.CreateToolStrips(new DesignerToolStrips[]
                {
                    DesignerToolStrips.Menu
                })[0];
            ToolStripDropDownItem fileMenu = (ToolStripDropDownItem)toolStrip.Items[0];
            CreateFileMenu(fileMenu);
            AppendToolStrips(0, new ToolStrip[]
                {
                    toolStrip
                });
            
            AppendToolStrips(1, new ToolStrip[]
                {
                    CreateReportToolbar()
                });                    
        }

        //Adding DropDownItems to the ToolStripDropDownItem
        private void CreateFileMenu(ToolStripDropDownItem fileMenu)
		{
			fileMenu.DropDownItems.Clear();
			fileMenu.DropDownItems.Add(new ToolStripMenuItem("New", Properties.Resources.CmdNewReport, new EventHandler(OnNew), (Keys.Control | Keys.N)));
			fileMenu.DropDownItems.Add(new ToolStripMenuItem("Open", Properties.Resources.CmdOpen, new EventHandler(OnOpen), (Keys.Control | Keys.O)));
			fileMenu.DropDownItems.Add(new ToolStripMenuItem("Save", Properties.Resources.CmdSave, new EventHandler(OnSave), (Keys.Control | Keys.S)));
			fileMenu.DropDownItems.Add(new ToolStripMenuItem("Save As", Properties.Resources.CmdSaveAs, new EventHandler(OnSaveAs)));
			fileMenu.DropDownItems.Add(new ToolStripSeparator());
			fileMenu.DropDownItems.Add(new ToolStripMenuItem("Exit", null, new EventHandler(OnExit)));
		}
		private ToolStrip CreateReportToolbar()
		{
			return new ToolStrip(new ToolStripButton[]
			{				
                CreateToolStripButton("Open", Properties.Resources.defaulticon, new EventHandler(OnOpen), "Open", true),
                exprt = CreateToolStripButton("Export", Properties.Resources.defaulticon, new EventHandler(OnExport), "Export", false)
            });
		}
		//Getting the Designer to open a new Report on Menu Item "New" click
		private void OnNew(object sender, EventArgs e)
		{
			if (ConfirmSaveChanges())
			{
				reportDesigner.ExecuteAction(DesignerAction.NewReport);
			}
		}
		//Getting the Designer to open a Report on Menu Item "Open" click
		private void OnOpen(object sender, EventArgs e)
		{
			if (ConfirmSaveChanges())
			{
                //reportDesigner.ExecuteAction(DesignerAction.FileOpen);
                OpenFileDialog open = new OpenFileDialog();
                open.Filter = "rpx files|*.rpx";
                open.DefaultExt = ".rpx";
                open.InitialDirectory = filePath;
                if (open.ShowDialog() == DialogResult.OK)
                {
                    reportDesigner.LoadReport(new FileInfo(open.FileName));
                    init();
                }                
            }            
        }
		//Getting the Designer to Save the Report on Menu Item "Save" click
		private void OnSave(object sender, EventArgs e)
		{
			reportDesigner.ExecuteAction(DesignerAction.FileSave);
		}
		//Getting the Designer to Save the Report on Menu Item "Save As" click
		private void OnSaveAs(object sender, EventArgs e)
		{
			reportDesigner.ExecuteAction(DesignerAction.FileSave);
		}
		private void OnExit(object sender, EventArgs e)
		{
			Close();
		}
        //Getting the Designer to Export the Report on Menu Item "Export" click
        private void OnExport(object sender, EventArgs e)
        {
            if (ConfirmSaveChanges())
            {
                fileName = SaveFile("pdf files|*.pdf", ".pdf");
                SectionReport rpt = new SectionReport();
                XmlTextReader xtr = new XmlTextReader(reportName);
                rpt.LoadLayout(xtr);
                rpt.Run();
                Export.Pdf.Section.PdfExport PdfExport1 = new Export.Pdf.Section.PdfExport();
                PdfExport1.Export(rpt.Document, fileName);
                System.Diagnostics.Process.Start(fileName);
            }
        }
        //Setup form
        private void init()
        {
            exprt.Enabled = true;

            this.Width = 900;
            this.Height = 600;
            
            reportDesigner.Visible = true;
            reportToolbox.Visible = true;
            reportsLibrary.Visible = true;
            propertyGrid.Visible = true;
            reportExplorer.Visible = true;
            reportExplorerTabControl.Visible = true;
            groupEditor.Visible = true;
            bodyContainer.Visible = true;
                        
        }
        //Checking whether modifications have been made to the report loaded to the designer
        private bool ConfirmSaveChanges()
		{
			if (reportDesigner.IsDirty)
			{
				DialogResult result = MessageBox.Show("Report has been changed. Do you wish to save it?", "", MessageBoxButtons.YesNoCancel, MessageBoxIcon.Question);
				if (result == DialogResult.Cancel)
				{
					return false;
				}
				if (result == DialogResult.Yes)
				{
                    reportName = SaveFile("rpx files|*.rpx", ".rpx");
                    reportDesigner.SaveReport(new FileInfo(reportName));                    
                    reportDesigner.IsDirty = false;                   
                }
			}
			return true;
		}
        //File dialog
        private string SaveFile(string filter, string defaultExt)
        {
            SaveFileDialog saveDialog = new SaveFileDialog();
            saveDialog.Filter = filter;
            saveDialog.DefaultExt = defaultExt;
            saveDialog.InitialDirectory = filePath;

            return saveDialog.ShowDialog() == DialogResult.OK ? saveDialog.FileName : "";
        }

		private void AppendToolStrips(int row, IList<ToolStrip> toolStrips)
		{
			ToolStripPanel topToolStripPanel = toolStripContainer.TopToolStripPanel;
			int num = toolStrips.Count;
			while (--num >= 0)
			{
				topToolStripPanel.Join(toolStrips[num], row);
			}
		}
		private static ToolStripButton CreateToolStripButton(string text, Image image, EventHandler handler, string toolTip, bool enabled)
		{
			return new ToolStripButton(text, image, handler)
			{
				DisplayStyle = ToolStripItemDisplayStyle.ImageAndText,
				ToolTipText = toolTip,
				DoubleClickEnabled = true,
                Enabled = enabled
			};
		}
		
		private void ReportsForm_Load(object sender, EventArgs e)
		{/*           
            init();
            try
            {
                reportDesigner.LoadReport(new System.IO.FileInfo(filePath + fileName));
            }
            catch (Exception)
            {                
                reportDesigner.NewReport(DesignerReportType.Section);               
            }*/
        }
		
		private void CreateReportExplorer()
		{
			if (reportDesigner.ReportType == DesignerReportType.Section)
			{
				if (explorerpropertygridContainer.Panel1.Controls.Contains(reportExplorerTabControl))
				{
					reportExplorerTabControl.TabPages[0].SuspendLayout();
					explorerpropertygridContainer.Panel1.SuspendLayout();
					explorerpropertygridContainer.Panel1.Controls.Remove(reportExplorerTabControl);
					explorerpropertygridContainer.Panel1.Controls.Add(reportExplorer);
					reportExplorerTabControl.TabPages[0].ResumeLayout();
					explorerpropertygridContainer.Panel1.ResumeLayout();
				}
			}
			else if (!explorerpropertygridContainer.Panel1.Controls.Contains(reportExplorerTabControl))
			{
				reportExplorerTabControl.TabPages[0].SuspendLayout();
				explorerpropertygridContainer.Panel1.SuspendLayout();
				explorerpropertygridContainer.Panel1.Controls.Remove(reportExplorer);
				reportExplorerTabControl.TabPages[0].Controls.Add(reportExplorer);
				explorerpropertygridContainer.Panel1.Controls.Add(reportExplorerTabControl);
				reportExplorerTabControl.TabPages[0].ResumeLayout();
				explorerpropertygridContainer.Panel1.ResumeLayout();
			}
		}
		private void reportDesigner_LayoutChanged(object sender, LayoutChangedArgs e)
		{
			CreateReportExplorer();
		}
		
	}
}
