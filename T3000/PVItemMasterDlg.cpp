// PVItemMasterDlg.cpp : implementation file
//

#include "stdafx.h"
#include "T3000.h"
#include "PVItemMasterDlg.h"
#include "afxdialogex.h"
#include "PVBOMDlg.h"
#include "NewPNDlg.h"
#include "PartVendorQuotationDlg.h"
#include "AssyTreeDlg.h"
 
IMPLEMENT_DYNAMIC(CPVItemMasterDlg, CDialogEx)

CPVItemMasterDlg::CPVItemMasterDlg(CWnd* pParent /*=NULL*/)
    : CDialogEx(CPVItemMasterDlg::IDD, pParent)
    , m_strPN(_T(""))
    , m_strType(_T(""))
{
    m_curRow = -1;
    m_curCol = -1;
    m_oldColorRow = -1;
    m_curColorRow = -1;
    PartWindow = NULL;
    PartQuatationWindow = NULL;

     if (PartWindow==NULL)
     {
         PartWindow=new CNewPNDlg;
         PartWindow->Create(IDD_PV_NEW_PN, this);
         PartWindow->m_hParentWnd = this->m_hWnd;
     }
 
     if (PartQuatationWindow == NULL)
     {
         PartQuatationWindow = new CPartVendorQuotationDlg;
         PartQuatationWindow->Create (CPartVendorQuotationDlg::IDD,this);
         PartQuatationWindow->m_hParentWnd = this->m_hWnd;
     }

}

CPVItemMasterDlg::~CPVItemMasterDlg()
{
    delete PartWindow;
    PartWindow = NULL;
    delete PartQuatationWindow;
    PartQuatationWindow = NULL;
}

void CPVItemMasterDlg::DoDataExchange(CDataExchange* pDX)
{
    CDialogEx::DoDataExchange(pDX);
    DDX_Control(pDX, IDC_LIST1, m_data_list);
    DDX_Text(pDX, IDC_EDIT_PN, m_strPN);
    DDX_CBString(pDX, IDC_COMBO_TYPE, m_strType);
}


BEGIN_MESSAGE_MAP(CPVItemMasterDlg, CDialogEx)
    ON_BN_CLICKED(IDC_SEARCH, &CPVItemMasterDlg::OnBnClickedSearch)
    ON_WM_SIZE()
    ON_NOTIFY(NM_RCLICK, IDC_LIST1, &CPVItemMasterDlg::OnNMRClickList1)
    ON_COMMAND(ID_PARTS_CHECKBOM, &CPVItemMasterDlg::OnPartsCheckbom)
    ON_COMMAND(ID_PARTS_COPYNEWITEM, &CPVItemMasterDlg::OnPartsCopynewitem)
    ON_COMMAND(ID_PN_NEWPN, &CPVItemMasterDlg::OnPnNewpn)
    ON_COMMAND(ID_PARTS_OPEN, &CPVItemMasterDlg::OnPartsOpen)
    ON_COMMAND(ID_PARTS_DELETEITEM, &CPVItemMasterDlg::OnPartsDeleteitem)
    ON_NOTIFY(NM_DBLCLK, IDC_LIST1, &CPVItemMasterDlg::OnNMDblclkList1)
    ON_COMMAND(ID_PARTS_MAINTAINVENDOR, &CPVItemMasterDlg::OnPartsMaintainvendor)
//    ON_NOTIFY(HDN_ITEMCLICK, 0, &CPVItemMasterDlg::OnHdnItemclickList1)
    ON_COMMAND(ID_PARTS_SHOWASSBLYTREE, &CPVItemMasterDlg::OnPartsShowassblytree)
    ON_NOTIFY(NM_CLICK, IDC_LIST1, &CPVItemMasterDlg::OnNMClickList1)
END_MESSAGE_MAP()


// CPVItemMasterDlg message handlers


BOOL CPVItemMasterDlg::OnInitDialog()
{
    CDialogEx::OnInitDialog();

    while(m_data_list.DeleteColumn(0));
    m_data_list.ModifyStyle(0, LVS_REPORT|LVS_SHOWSELALWAYS);

    //m_data_list.SetExtendedStyle(m_data_list.GetExtendedStyle()  |LVS_EX_GRIDLINES&(~LVS_EX_FULLROWSELECT));
    m_data_list.InsertColumn(0, _T("NUM"), 50, ListCtrlEx::Normal, LVCFMT_CENTER, ListCtrlEx::SortByDigit);
    m_data_list.InsertColumn(1, _T("P/N"), 140, ListCtrlEx::Normal, LVCFMT_CENTER, ListCtrlEx::SortByString);
    m_data_list.InsertColumn(2, _T("Type"), 80, ListCtrlEx::Normal, LVCFMT_CENTER, ListCtrlEx::SortByString);
    m_data_list.InsertColumn(3, _T("Title"), 200, ListCtrlEx::Normal, LVCFMT_CENTER, ListCtrlEx::SortByString);
    m_data_list.InsertColumn(4, _T("Detail"), 200, ListCtrlEx::Normal, LVCFMT_CENTER, ListCtrlEx::SortByString);
    m_data_list.InsertColumn(5, _T("Rev"), 50, ListCtrlEx::Normal, LVCFMT_CENTER, ListCtrlEx::SortByString);
    m_data_list.InsertColumn(6, _T("Stat"), 80, ListCtrlEx::Normal, LVCFMT_CENTER, ListCtrlEx::SortByString);
    m_data_list.InsertColumn(7, _T("Cur.Cost"), 80, ListCtrlEx::Normal, LVCFMT_CENTER, ListCtrlEx::SortByString);

    CRect ViewRect;
    GetClientRect(&ViewRect);
    // CRect listRect;
    //m_data_list.GetClientRect(&listRect);
    if (m_data_list.GetSafeHwnd())
    {
        m_data_list.MoveWindow(CRect(0,30/*listRect.top*/,ViewRect.Width(),ViewRect.Height()-10),TRUE);
    }

    pn_table.Search_Data_ByPN(m_strPN,m_strType);
    Load_DataToList();
    return TRUE;  // return TRUE unless you set the focus to a control
    // EXCEPTION: OCX Property Pages should return FALSE
}
void CPVItemMasterDlg::Load_DataToList()
{

    // pn_table.Initial_Data();
    CString  strTemp;
    m_data_list.DeleteAllItems();
    for (int row = 0; row<(int)pn_table.pv_Table_PN.size(); row++)
    {
        strTemp.Format(_T("%d"),row+1);
        m_data_list.InsertItem(row,strTemp);
        strTemp=pn_table.pv_Table_PN.at(row).PNPartNumber;
        m_data_list.SetItemText(row,1,strTemp);
        strTemp=pn_table.pv_Table_PN.at(row).PNType;
        m_data_list.SetItemText(row,2,strTemp);
        strTemp=pn_table.pv_Table_PN.at(row).PNTitle;
        m_data_list.SetItemText(row,3,strTemp);
        strTemp=pn_table.pv_Table_PN.at(row).PNDetail;
        m_data_list.SetItemText(row,4,strTemp);
        strTemp=pn_table.pv_Table_PN.at(row).PNRevision;
        m_data_list.SetItemText(row,5,strTemp);
        strTemp=pn_table.pv_Table_PN.at(row).PNStatus;
        m_data_list.SetItemText(row,6,strTemp);
        strTemp.Format(_T("%0.3f"),pn_table.pv_Table_PN.at(row).PNCurrentCost);
        m_data_list.SetItemText(row,7,strTemp);
    }

}

void CPVItemMasterDlg::OnBnClickedSearch()
{
    UpdateData(TRUE);
    m_strPN.TrimLeft ();
    m_strPN.TrimRight ();
    m_strType.TrimLeft ();
    m_strType.TrimRight ();
    if (m_strType.CompareNoCase (_T("All"))==0)
    {
        m_strType = _T("");
    }              //  m_strType
    pn_table.Search_ALLPN(m_strPN);
    Load_DataToList();
}


void CPVItemMasterDlg::OnSize(UINT nType, int cx, int cy)
{
    CDialogEx::OnSize(nType, cx, cy);
    if (nType==SIZE_RESTORED)
    {
        CRect ViewRect;
        GetClientRect(&ViewRect);
        //CRect listRect;
        // m_data_list.GetClientRect(&listRect);
        if (m_data_list.GetSafeHwnd())
        {
            m_data_list.MoveWindow(CRect(0,30/*listRect.top*/,ViewRect.Width(),ViewRect.Height()-10),TRUE);
        }

    }
    // TODO: Add your message handler code here
}


void CPVItemMasterDlg::OnNMRClickList1(NMHDR *pNMHDR, LRESULT *pResult)
{
    LPNMITEMACTIVATE pNMItemActivate = reinterpret_cast<LPNMITEMACTIVATE>(pNMHDR);
    CString temp_cstring;
    long lRow,lCol;
    m_data_list.Set_Edit(true);
    DWORD dwPos=GetMessagePos();//Get which line is click by user.Set the check box, when user enter Insert it will jump to program dialog
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


    if (TRUE)
    {

        CMenu menu;
        menu.LoadMenu(IDR_MENU_PV_MAIN);
        CMenu *pmenu=menu.GetSubMenu(0);
        CPoint point;
        GetCursorPos(&point);
        pmenu->TrackPopupMenu(TPM_LEFTBUTTON | TPM_LEFTALIGN ,point.x,point.y,this);

    }
    else
    {
        return;
    }
    *pResult = 0;

}


void CPVItemMasterDlg::OnPartsCheckbom()
{
    CPVBOMDlg pvbomdlg;
    pvbomdlg.m_PN_ID = pn_table.pv_Table_PN.at(m_curRow).PNID;
    CString Title;
    Title.Format (_T("Bom List:%s"),pn_table.pv_Table_PN.at(m_curRow).PNPartNumber);
    pvbomdlg.Title = Title;
    // pvbomdlg.SetWindowTextW(Title);
    pvbomdlg.DoModal();
}


void CPVItemMasterDlg::OnPartsCopynewitem()
{
    if (m_curRow<pn_table.pv_Table_PN.size())
    {
        CNewPNDlg dlg;
        dlg.m_new_item = 1;
        dlg.m_item = pn_table.pv_Table_PN.at(m_curRow);
        dlg.m_saveCloseWindow = TRUE;
        dlg.DoModal();
    }

}


void CPVItemMasterDlg::OnPnNewpn()
{
    CNewPNDlg dlg;
    dlg.m_new_item = 0;
    dlg.m_saveCloseWindow = TRUE;
    dlg.DoModal();
}


void CPVItemMasterDlg::OnPartsOpen()
{
    if(m_curRow<pn_table.pv_Table_PN.size())
    {

        PartWindow->m_new_item = 2;
        PartWindow->m_item = pn_table.pv_Table_PN.at(m_curRow);
        PartWindow->ShowWindow (TRUE);
    }
}
void CPVItemMasterDlg::OnPartsDeleteitem()
{
    int PNID = pn_table.pv_Table_PN.at(m_curRow).PNID;
    pn_table.Delete_ByPN(PNID);
    pn_table.Initial_Data();
    m_data_list.DeleteItem(m_curRow);
    // Load_DataToList();
}


void CPVItemMasterDlg::OnNMDblclkList1(NMHDR *pNMHDR, LRESULT *pResult)
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

    FreshAllWindows ();
    *pResult = 0;
}


void CPVItemMasterDlg::OnPartsMaintainvendor()
{
    CPartVendorQuotationDlg dlg;
    dlg.m_PN_ID = pn_table.pv_Table_PN.at(m_curRow).PNID;
    CString Title;
    Title.Format (_T("Part's Quatation List:%s"),pn_table.pv_Table_PN.at(m_curRow).PNPartNumber);

    dlg.Title = Title;
    if (dlg.DoModal () == IDOK)
    {
        PN_Struct  update_item = pn_table.pv_Table_PN.at(m_curRow); //  / dlg.m_datasector.BuyAs
        pn_table.Initial_UN ();
        int convert_unit = -1;
        for (int i = 0; i<pn_table.m_dataset_UN.size (); i++)
        {
            if (pn_table.m_dataset_UN.at(i).UNPurchUnits.CompareNoCase(dlg.m_datasector.BuyAs) == 0)
            {
                convert_unit =   pn_table.m_dataset_UN.at(i).UNConvUnits;
                update_item.PNCurrentCost = dlg.m_datasector.Cost/convert_unit;
                pn_table.Update_ByPN (update_item);
                pn_table.Initial_Data ();
                Load_DataToList ();
                break;
            }
        }



    }


}
 
//void CPVItemMasterDlg::OnHdnItemclickList1(NMHDR *pNMHDR, LRESULT *pResult)
//{
//    LPNMHEADER phdr = reinterpret_cast<LPNMHEADER>(pNMHDR);
//    // TODO: Add your control notification handler code here
//
//
//    CString temp_cstring;
//    long lRow,lCol;
//    m_data_list.Set_Edit(true);
//    DWORD dwPos=GetMessagePos();
//    //Get which line is click by user.Set the check box, when user enter Insert it will jump to program dialog
//    CPoint point( LOWORD(dwPos), HIWORD(dwPos));
//    m_data_list.ScreenToClient(&point);
//    LVHITTESTINFO lvinfo;
//    lvinfo.pt=point;
//    lvinfo.flags=LVHT_ABOVE;
//    int nItem=m_data_list.SubItemHitTest(&lvinfo);
//
//    lRow = lvinfo.iItem;
//    lCol = lvinfo.iSubItem;
//
//    m_curRow=lRow;
//    m_curCol=lCol;
//    if(lRow>m_data_list.GetItemCount()) //如果点击区超过最大行号，则点击是无效的
//        return;
//    if(lRow<0)
//        return;
//    CString New_CString;
//    CString temp_task_info;
//
//    CString temp1;
//    CStringArray temparray;
//
//      if (m_curCol == 1)
//      {
//         LPRECT rect;
//         m_data_list.GetItemRect (m_curCol,rect,0);
//      }
//
//    *pResult = 0;
//}



void CPVItemMasterDlg::OnPartsShowassblytree()
{
    int PNID = pn_table.pv_Table_PN.at(m_curRow).PNID;
    CAssyTreeDlg dlg;
    dlg.m_PNID =  PNID;
    dlg.PNName = pn_table.pv_Table_PN.at(m_curRow).PNPartNumber;
    CString Title;
    Title.Format (_T("Assy Tree List For %s"),pn_table.pv_Table_PN.at(m_curRow).PNPartNumber);
    dlg.m_title = Title;
    dlg.DoModal ();
}


void CPVItemMasterDlg::OnNMClickList1(NMHDR *pNMHDR, LRESULT *pResult)
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

     FreshAllWindows ();

     m_data_list.SetFocus ();

    *pResult = 0;
}

void CPVItemMasterDlg::FreshAllWindows ()
{
    if (m_curRow < pn_table.pv_Table_PN.size ())
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

         PartWindow->m_hParentWnd = this->m_hWnd;
         PartQuatationWindow->m_hParentWnd = this->m_hWnd;
        if(m_curRow<pn_table.pv_Table_PN.size())
        {

            PartWindow->m_new_item = 2;
            PartWindow->m_item = pn_table.pv_Table_PN.at(m_curRow);
            PartWindow->m_index = m_curRow;
            
            if (!PartWindow->IsWindowVisible ())
            {
                PartWindow->ShowWindow (TRUE);

                ::PostMessageA (PartWindow->m_hWnd,WM_MESSAGE_FRESH_PN_DETAIL,0,0);
            }
            else
            {
                ::PostMessageA (PartWindow->m_hWnd,WM_MESSAGE_FRESH_PN_DETAIL,0,0);
            }

            PartQuatationWindow->m_PN_ID = pn_table.pv_Table_PN.at(m_curRow).PNID;
            if (!PartQuatationWindow->IsWindowVisible ())
            {
                PartQuatationWindow->ShowWindow (TRUE);
                ::PostMessageA (PartQuatationWindow->m_hWnd,WM_MESSAGE_ITEM_VENDORS_LIST,0,0);
            }
            else
            {
                ::PostMessageA (PartQuatationWindow->m_hWnd,WM_MESSAGE_ITEM_VENDORS_LIST,0,0);
            }

        }

    }
}

LRESULT CPVItemMasterDlg::WindowProc(UINT message, WPARAM wParam, LPARAM lParam)
{
    // TODO: Add your specialized code here and/or call the base class
    if (message == WM_MESSAGE_ITEM_MASTER)
    {
        // pn_table.Search_Data_ByPN(m_strPN,m_strType);
        Load_DataToList();
    }

    if (message == WM_MESSAGE_ITEM_RELOAD_ALLDATA)
    {
        pn_table.Search_Data_ByPN(m_strPN,m_strType);
        Load_DataToList();
    }
    return CDialogEx::WindowProc(message, wParam, lParam);
}


BOOL CPVItemMasterDlg::PreTranslateMessage(MSG* pMsg)
{
    // TODO: Add your specialized code here and/or call the base class
    if(pMsg->message==WM_KEYDOWN)
    {
        if(GetFocus()->GetDlgCtrlID() == IDC_LIST1)
        {

           
            switch(pMsg->wParam)
            {
            case VK_UP:
            {
                if (m_curRow < pn_table.pv_Table_PN.size ())
                {
                    m_curRow--;
                }
                else
                {
                    m_curRow =pn_table.pv_Table_PN.size ()-1;
                }
                FreshAllWindows ();
            }
            break;

            case VK_DOWN:
            {
                if (m_curRow < pn_table.pv_Table_PN.size ())
                {
                    m_curRow++;
                }
                else
                {
                    m_curRow =0;
                }

                FreshAllWindows ();
            }
            break;
            }



            return TRUE;
        }

        if (pMsg->wParam ==VK_RETURN)
        {
             OnBnClickedSearch();
             return TRUE;
        }
    }

   

    return CDialogEx::PreTranslateMessage(pMsg);
}
