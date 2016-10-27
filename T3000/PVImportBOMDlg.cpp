// PVImportBOMDlg.cpp : implementation file
//

#include "stdafx.h"
#include "T3000.h"
#include "PVImportBOMDlg.h"
#include "afxdialogex.h"
#include "globle_function.h"


// CPVImportBOMDlg dialog

IMPLEMENT_DYNAMIC(CPVImportBOMDlg, CDialogEx)

CPVImportBOMDlg::CPVImportBOMDlg(CWnd* pParent /*=NULL*/)
    : CDialogEx(CPVImportBOMDlg::IDD, pParent)
{
    m_strFilePath = L"";
    m_pFile = new CStdioFile;



    m_oldColorRow = -1;
    m_curColorRow = -1;
    m_curRow = -1;
    m_curCol = -1;

}

CPVImportBOMDlg::~CPVImportBOMDlg()
{
    delete m_pFile;

}

void CPVImportBOMDlg::DoDataExchange(CDataExchange* pDX)
{
    CDialogEx::DoDataExchange(pDX);
    DDX_Control(pDX, IDC_LIST1, m_data_list);
    DDX_Control(pDX, IDC_EDIT_PN, m_combox_PN);
}


BEGIN_MESSAGE_MAP(CPVImportBOMDlg, CDialogEx)
    ON_BN_CLICKED(IDC_BOM_PATH, &CPVImportBOMDlg::OnBnClickedBomPath)
    ON_BN_CLICKED(IDC_NEW_PN, &CPVImportBOMDlg::OnBnClickedNewPn)
    ON_BN_CLICKED(IDC_BUTTON_Reload, &CPVImportBOMDlg::OnBnClickedButtonReload)
    ON_BN_CLICKED(IDOK, &CPVImportBOMDlg::OnBnClickedOk)
    ON_CBN_SELCHANGE(IDC_EDIT_PN, &CPVImportBOMDlg::OnCbnSelchangeEditPn)
    ON_NOTIFY(NM_CLICK, IDC_LIST1, &CPVImportBOMDlg::OnNMClickList1)
END_MESSAGE_MAP()


// CPVImportBOMDlg message handlers


void CPVImportBOMDlg::OnBnClickedBomPath()
{
    CString strFilter = _T("Delimited Text File|*.csv;*.txt;*.bom|all File|*.*||");
    CFileDialog dlg(true,_T("BOM"),NULL,OFN_HIDEREADONLY | OFN_OVERWRITEPROMPT | OFN_EXPLORER,strFilter);
    dlg.DoModal();
    m_strFilePath=dlg.GetPathName();
    GetDlgItem (IDC_EDIT_PATH)->SetWindowText (m_strFilePath);
    Initial_List();
}


BOOL CPVImportBOMDlg::OnInitDialog()
{
    CDialogEx::OnInitDialog();
    m_data_list.ModifyStyle(0, LVS_SINGLESEL|LVS_REPORT|LVS_SHOWSELALWAYS);
    m_data_list.SetExtendedStyle(m_data_list.GetExtendedStyle()  |LVS_EX_GRIDLINES&(~LVS_EX_FULLROWSELECT));




    g_hwnd_now = this->m_hWnd;


    pn_table.Load_Assembly_Data();


    for (int i = 0 ; i<(int) pn_table.pv_Table_PN.size (); i++)
    {
        m_combox_PN.AddString(pn_table.pv_Table_PN.at(i).PNPartNumber);
    }


    return TRUE;
}

void CPVImportBOMDlg::Initial_List ()
{
    int colcount  = 0;
    char chToken= '\\';
    if (m_strFilePath.IsEmpty ())
    {
        return;
    }

    if(m_pFile->Open(m_strFilePath.GetString(),CFile::modeRead|CFile::shareDenyNone))
    {
        m_BOMContent.clear();

        CString strRead;
        while(m_pFile->ReadString(strRead))//过滤掉没有的数据
        {
            if (strRead.CompareNoCase (L"______________________________________________")==0)
            {
                break;
            }
        }
        while(m_pFile->ReadString(strRead))
        {

            if (!strRead.IsEmpty ())
            {
                CString StrLog;
                StrLog.Format (_T("%s   \n"),strRead);
                //TRACE(strRead+L"\n");

                m_BOMContent.push_back(strRead);
                CStringArray ArrayString;
                SplitCStringA (ArrayString,strRead,L"\t",FALSE);

                if (colcount<ArrayString.GetSize ())  //插入列
                {
                    /*   int insertCol = ArrayString.GetSize ()- colcount;
                    for(int col = 0; col<insertCol; col++)
                    {
                    m_data_list.InsertColumn(colcount+col, _T(""), 80, ListCtrlEx::EditBox, LVCFMT_CENTER, ListCtrlEx::SortByDigit);
                    }*/
                    colcount = ArrayString.GetSize ();
                }
                int testsize = ArrayString.GetSize ();
                if (testsize<=0)
                {
                    continue;
                }
                vector<CString> TempArrayString;
                if (testsize>0)
                {
                    if (ArrayString[0].IsEmpty ())
                    {
                        // continue;
                        int lastrow = m_fileContent.size ()-1;
                        for (int col = 0; col<ArrayString.GetSize (); col++)
                        {
                            if (col == 4)
                            {
                                int index = ArrayString[col].ReverseFind (chToken);
                                if (index!=-1)
                                {
                                    ArrayString[col].Delete(0,index+1);
                                }
                            }

                            CString strData = m_fileContent.at(lastrow).at(col);
                            strData += ArrayString[col];
                            m_fileContent.at(lastrow)[col]=strData;

                        }
                        continue;
                    }
                }

                /*  int rowcount = m_data_list.GetRowCount ();
                  m_data_list.InsertItem (rowcount,ArrayString[0]);*/
                TempArrayString.clear ();
                for (int col = 0; col<ArrayString.GetSize (); col++)
                {
                    // m_data_list.SetItemText (rowcount-1,col,ArrayString[col]);
                    if (col == 4)
                    {
                        int index = ArrayString[col].ReverseFind (chToken);
                        if (index!=-1)
                        {
                            ArrayString[col].Delete(0,index+1);
                        }
                    }

                    TempArrayString.push_back (ArrayString[col]);
                }

                m_fileContent.push_back (TempArrayString);

            }

        }

        m_pFile->Close();


    }
    else
    {
        ASSERT(0);
        m_pFile->Close();
        return  ;
    }

    //for(int col = 0; col<colcount; col++)//插入列
    //{
    //    m_data_list.InsertColumn(col, _T(""), 50, ListCtrlEx::Normal, LVCFMT_CENTER, ListCtrlEx::SortByDigit);
    //}

    m_data_list.InsertColumn(0, _T("Item"), 50, ListCtrlEx::Normal, LVCFMT_CENTER, ListCtrlEx::SortByDigit);
    m_data_list.InsertColumn(1, _T("Quantity"), 100, ListCtrlEx::Normal, LVCFMT_CENTER, ListCtrlEx::SortByString);
    m_data_list.InsertColumn(2, _T("Reference	Value"), 100, ListCtrlEx::Normal, LVCFMT_CENTER, ListCtrlEx::SortByString);
    m_data_list.InsertColumn(3, _T("PCB"), 50, ListCtrlEx::EditBox, LVCFMT_CENTER, ListCtrlEx::SortByString);
    m_data_list.InsertColumn(4, _T("Footprint"), 250, ListCtrlEx::ComboBox, LVCFMT_CENTER, ListCtrlEx::SortByString);
    m_data_list.InsertColumn(5, _T("Description"), 250, ListCtrlEx::ComboBox, LVCFMT_CENTER, ListCtrlEx::SortByString);
    m_data_list.InsertColumn(6, _T("Part_Number"), 250, ListCtrlEx::ComboBox, LVCFMT_CENTER, ListCtrlEx::SortByString);

    for (int row = 0; row<(int)m_fileContent.size (); row++)
    {
        m_data_list.InsertItem (row,m_fileContent.at(row).at(0));
        for (int col = 0; col<m_fileContent.at(row).size(); col++)
        {
            m_data_list.SetItemText (row,col,m_fileContent.at(row).at(col));
        }
    }
}

#include "NewPNDlg.h"
void CPVImportBOMDlg::OnBnClickedNewPn()
{
    CNewPNDlg dlg;
    dlg.m_new_item = 0;
    dlg.m_saveCloseWindow = TRUE;
    dlg.DoModal();
}


void CPVImportBOMDlg::OnBnClickedButtonReload()
{
    pn_table.Load_Assembly_Data();
    m_combox_PN.ResetContent ();

    for (int i = 0 ; i<(int) pn_table.pv_Table_PN.size (); i++)
    {
        m_combox_PN.AddString(pn_table.pv_Table_PN.at(i).PNPartNumber);
    }
}


void CPVImportBOMDlg::OnBnClickedOk()
{
    if (-1==m_parentItem.PNID)
    {
        AfxMessageBox (_T("Please select a assembly item!"));
        return;
    }
    if (1>m_fileContent.size ())
    {
        AfxMessageBox (_T("Didn't find parts list!"));
        return;
    }
    //Part List insert Database
    for (int row = 0; row<(int)m_fileContent.size (); row++)
    {
        PN_Struct InsertItem;
        InsertItem.PNPrintFooter = m_fileContent.at(row).at(4);
        InsertItem.PNDetail = m_fileContent.at(row).at(5);
        InsertItem.PNTitle =  m_fileContent.at(row).at(3);
        InsertItem.PNPartNumber = m_fileContent.at(row).at(6);
        InsertItem=pn_table.Insert_ByPN (InsertItem);
        m_InsertItems.push_back (InsertItem);
    }
    //Link the part list to assembly item
    for (int index=0; index<m_InsertItems.size(); index++)
    {
        BOM_PartList addItem;
        addItem.PLPartID =m_InsertItems.at(index).PNID;
        addItem.PLListID =m_parentItem.PNID;
        addItem.PLItem = _wtoi(m_fileContent.at(index).at(0));
        addItem.PLQty  = m_fileContent.at(index).at(1);
        addItem.PLRefMemo = m_fileContent.at(index).at(2);
        pn_table.Insert_PL (addItem);
    }
    AfxMessageBox (_T("Import Successfully!"));
    // CDialogEx::OnOK();
}


void CPVImportBOMDlg::OnCbnSelchangeEditPn()
{
    m_parentItem = pn_table.pv_Table_PN.at(m_combox_PN.GetCurSel ());
}


void CPVImportBOMDlg::OnNMClickList1(NMHDR *pNMHDR, LRESULT *pResult)
{
    LPNMITEMACTIVATE pNMItemActivate = reinterpret_cast<LPNMITEMACTIVATE>(pNMHDR);
    CString temp_cstring;
    long lRow,lCol;
    m_data_list.Set_Edit(true);
    DWORD dwPos=GetMessagePos();
    //Get which line is click by user.Set the check box, when user enter Insert it will jump to program dialog
    CPoint point( LOWORD(dwPos), HIWORD(dwPos));
    m_data_list.ScreenToClient(&point);
    LVHITTESTINFO lvinfo;
    lvinfo.pt=point;
    lvinfo.flags=LVHT_ABOVE;
    int nItem=m_data_list.SubItemHitTest(&lvinfo);

    lRow = lvinfo.iItem;
    lCol = lvinfo.iSubItem;

    m_curRow=lRow;

    m_curCol=lCol;
    if(lRow>m_data_list.GetItemCount()) //如果点击区超过最大行号，则点击是无效的
        return;
    if(lRow<0)
        return;
    CString New_CString;
    CString temp_task_info;

    CString temp1;
    CStringArray temparray;

    if (lCol == 0)
    {

        m_oldColorRow = m_curColorRow;
        m_curColorRow = m_curRow;


        if (m_curColorRow != -1)
        {
            m_data_list.SetItemBkColor (m_curColorRow,-1,LIST_ITEM_SELECTED);
        }

        if (m_oldColorRow != -1)
        {
            m_data_list.SetItemBkColor (m_oldColorRow,-1,RGB(255,255,255));
        }

    }


    *pResult = 0;
}
