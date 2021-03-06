// PVBuyDlg.cpp : implementation file
//

#include "stdafx.h"
#include "T3000.h"
#include "PVBuyDlg.h"
#include "afxdialogex.h"


// CPVBuyDlg dialog

IMPLEMENT_DYNAMIC(CPVBuyDlg, CDialogEx)

CPVBuyDlg::CPVBuyDlg(CWnd* pParent /*=NULL*/)
    : CDialogEx(CPVBuyDlg::IDD, pParent)
    , m_strShipAddress(_T(""))
{
    m_curRow = -1;
    m_curCol = -1;
    m_oldColorRow = -1;
    m_curColorRow = -1;

    m_strPN = _T("");
    m_strPO = _T("");
    m_strTitle = _T("");
    m_strDetail = _T("");
    m_number_units = 1;

    m_num = 0;
    m_parentPN = 1;
    m_pn = 2;
    m_type = 3;
    m_title = 4;
    m_detail = 5;
    m_qty = 6;
    m_totalqty = 7;
    m_stock = 8;
    m_needtobuy = 9;
    m_useunit = 10;
    m_orderQty = 11;
    m_buyas = 12;
    m_unitprice = 13;
    m_totalprice = 14;
    m_vendor = 15;
    m_vendorpn = 16;

    m_strEngrgContact = _T("");
    m_strBuyer = _T("");

    m_hide_show = TRUE;
}

CPVBuyDlg::~CPVBuyDlg()
{
}

void CPVBuyDlg::DoDataExchange(CDataExchange* pDX)
{
    CDialogEx::DoDataExchange(pDX);
    DDX_Control(pDX, IDC_STATIC_PL, m_lable_PL);
    DDX_Control(pDX, IDC_LIST1, m_data_list);
    DDX_Text(pDX, IDC_EDIT_PN, m_strPN);
    DDX_Text(pDX, IDC_EDIT_PO, m_strPO);
    DDX_Text(pDX, IDC_EDIT_TITLE, m_strTitle);
    DDX_Text(pDX, IDC_EDIT_DETAIL, m_strDetail);
    DDX_Text(pDX, IDC_EDIT_NUMBER, m_number_units);
    DDX_Text(pDX, IDC_EDIT_ENGRG, m_strEngrgContact);
    DDX_Text(pDX, IDC_EDIT_BUYER, m_strBuyer);
    DDX_Text(pDX, IDC_SHIP_ADDRESS, m_strShipAddress);
}


BEGIN_MESSAGE_MAP(CPVBuyDlg, CDialogEx)
    ON_BN_CLICKED(IDOK, &CPVBuyDlg::OnBnClickedOk)
    ON_BN_CLICKED(IDCANCEL, &CPVBuyDlg::OnBnClickedCancel)
    ON_BN_CLICKED(IDC_BUILD_LIST_BUTTON, &CPVBuyDlg::OnBnClickedBuildListButton)
    ON_BN_CLICKED(IDC_SEND_TO_PO, &CPVBuyDlg::OnBnClickedSendToPo)
    ON_WM_SIZE()
    ON_BN_CLICKED(IDC_ITEM_PN, &CPVBuyDlg::OnBnClickedItemPn)
    ON_NOTIFY(NM_CLICK, IDC_LIST1, &CPVBuyDlg::OnNMClickList1)
    ON_BN_CLICKED(IDC_DEL_ITEM, &CPVBuyDlg::OnBnClickedDelItem)
    ON_BN_CLICKED(IDC_ADD_ITEM, &CPVBuyDlg::OnBnClickedAddItem)
    ON_BN_CLICKED(IDC_BUTTON_DEL_ALL, &CPVBuyDlg::OnBnClickedButtonDelAll)
    ON_MESSAGE(WM_LIST_ITEM_CHANGED, Change_Item_List)
    ON_BN_CLICKED(IDC_SHOW_HIDE, &CPVBuyDlg::OnBnClickedShowHide)
END_MESSAGE_MAP()


// CPVBuyDlg message handlers


BOOL CPVBuyDlg::OnInitDialog()
{
    CDialogEx::OnInitDialog();
    m_lable_PL.SetWindowTextW(_T("Purchase List"));
    m_lable_PL.textColor(RGB(0, 0, 0));
    m_lable_PL.setFont(30, 15, NULL, _T("Arial"));
    /* m_num;
    m_pn;
    m_type;
    m_title;
    m_detail;
    m_qty;
    m_totalqty;
    m_tobuy;
    m_buyas;
    m_unitprice;
    m_totalprice;
    m_vendor;
    m_vendorpn;*/
    m_data_list.ModifyStyle(0, LVS_SINGLESEL | LVS_REPORT | LVS_SHOWSELALWAYS);
    m_data_list.SetExtendedStyle(m_data_list.GetExtendedStyle()  | LVS_EX_GRIDLINES & (~LVS_EX_FULLROWSELECT)); //Not allow full row select.
    m_data_list.InsertColumn(m_num, _T("NUM"), 50, ListCtrlEx::Normal, LVCFMT_CENTER, ListCtrlEx::SortByDigit);
    m_data_list.InsertColumn(m_parentPN, _T("Parent Item"), 100, ListCtrlEx::Normal, LVCFMT_CENTER, ListCtrlEx::SortByString);
    m_data_list.InsertColumn(m_pn, _T("P/N"), 80, ListCtrlEx::Normal, LVCFMT_CENTER, ListCtrlEx::SortByString);
    m_data_list.InsertColumn(m_type, _T("Type"), 50, ListCtrlEx::Normal, LVCFMT_CENTER, ListCtrlEx::SortByString);
    m_data_list.InsertColumn(m_title, _T("Title"), 200, ListCtrlEx::Normal, LVCFMT_CENTER, ListCtrlEx::SortByString);
    m_data_list.InsertColumn(m_detail, _T("Detail"), 200, ListCtrlEx::Normal, LVCFMT_CENTER, ListCtrlEx::SortByString);
    m_data_list.InsertColumn(m_qty, _T("Qty"), 50, ListCtrlEx::EditBox, LVCFMT_CENTER, ListCtrlEx::SortByString);
    m_data_list.InsertColumn(m_totalqty, _T("Use Qty"), 80, ListCtrlEx::Normal, LVCFMT_CENTER, ListCtrlEx::SortByString);
    m_data_list.InsertColumn(m_useunit, _T("Use Unit"), 80, ListCtrlEx::Normal, LVCFMT_CENTER, ListCtrlEx::SortByString);
    m_data_list.InsertColumn(m_stock, _T("Item Stock"), 80, ListCtrlEx::Normal, LVCFMT_CENTER, ListCtrlEx::SortByString);
    m_data_list.InsertColumn(m_needtobuy, _T("Need To Buy"), 100, ListCtrlEx::Normal, LVCFMT_CENTER, ListCtrlEx::SortByString);

    m_data_list.InsertColumn(m_orderQty, _T("Order Qty"), 80, ListCtrlEx::EditBox, LVCFMT_CENTER, ListCtrlEx::SortByString);
    m_data_list.InsertColumn(m_buyas, _T("Buy Unit"), 80, ListCtrlEx::Normal, LVCFMT_CENTER, ListCtrlEx::SortByString);

    m_data_list.InsertColumn(m_unitprice, _T("Unit Price"), 80, ListCtrlEx::EditBox, LVCFMT_CENTER, ListCtrlEx::SortByString);
    m_data_list.InsertColumn(m_totalprice, _T("Total Price"), 50, ListCtrlEx::Normal, LVCFMT_CENTER, ListCtrlEx::SortByString);
    m_data_list.InsertColumn(m_vendor, _T("Vendor"), 80, ListCtrlEx::Normal, LVCFMT_CENTER, ListCtrlEx::SortByString);
    m_data_list.InsertColumn(m_vendorpn, _T("Vendor P/N"), 0, ListCtrlEx::Normal, LVCFMT_CENTER, ListCtrlEx::SortByString);
    // m_data_list.SetItemBkColor (-1,m_orderQty,RGB(0,0,255));

    g_hwnd_now = this->m_hWnd;

    CRect ViewRect;
    GetClientRect(&ViewRect);

    if(m_data_list.GetSafeHwnd())
    {
        m_data_list.MoveWindow(CRect(370, 50, ViewRect.Width(), ViewRect.Height() - 10), TRUE);
    }

    m_strShipAddress = pn_table.GetShippingAddress();
    UpdateData(FALSE);


    return FALSE;  // return TRUE unless you set the focus to a control
    // EXCEPTION: OCX Property Pages should return FALSE
}


void CPVBuyDlg::OnBnClickedOk()
{
    // TODO: Add your control notification handler code here
    // CDialogEx::OnOK();
}


void CPVBuyDlg::OnBnClickedCancel()
{
    // TODO: Add your control notification handler code here
    //CDialogEx::OnCancel();
}


LRESULT CPVBuyDlg::WindowProc(UINT message, WPARAM wParam, LPARAM lParam)
{
    if(message  == WM_MESSAGE_FRESH_BOM)
    {
        m_PN_ID = (int)wParam;
        pn_table.Search_PNID(m_PN_ID);

        if(pn_table.pv_Table_PN.size() > 0)
        {
            m_strDetail = pn_table.pv_Table_PN.at(0).PNDetail;
            m_strPN =     pn_table.pv_Table_PN.at(0).PNPartNumber;
            m_strTitle =  pn_table.pv_Table_PN.at(0).PNTitle;
            UpdateData(FALSE);
        }



    }

    return CDialogEx::WindowProc(message, wParam, lParam);
}


void CPVBuyDlg::OnBnClickedBuildListButton()
{
    UpdateData(TRUE);
    pn_table.Build_AssemblyData(m_PN_ID, m_strPN);

    for(int i = 0; i < pn_table.m_bomdataset.size(); i++)
    {
        PList_Struct temp_struct = pn_table.m_bomdataset.at(i);
        BOOL is_in_list = FALSE;
        int index = -1;

        for(vector<PList_Struct>::iterator iter = pn_table.m_buydataset.begin(); iter != pn_table.m_buydataset.end(); iter++)
        {
            if(iter->PLID == temp_struct.PLID)
            {
                is_in_list = TRUE;
                index =   iter - pn_table.m_buydataset.begin();
                break;
            }
        }

        if(!is_in_list)     //不存在--加入列表
        {


            int tobuy = temp_struct.Qty * m_number_units  -  temp_struct.PNStock; //

            if(tobuy < 0)
            {
                tobuy = 0;
            }

            temp_struct.tobuy = tobuy;
            temp_struct.TotalQty = temp_struct.Qty * m_number_units;
            temp_struct.OrderQty = (tobuy + temp_struct.UNConvUnits - 1) / temp_struct.UNConvUnits;
            temp_struct.MFExtCost = temp_struct.vendorPrice * temp_struct.OrderQty;
            pn_table.m_buydataset.push_back(temp_struct);

        }
        else   //存在，把数量加进去
        {

            int tobuy = pn_table.m_buydataset.at(index).TotalQty + temp_struct.Qty * m_number_units -  pn_table.m_buydataset.at(index).PNStock;

            if(tobuy < 0)
            {
                tobuy = 0;
            }

            pn_table.m_buydataset.at(index).tobuy = tobuy;
            pn_table.m_buydataset.at(index).TotalQty += temp_struct.Qty * m_number_units;
            pn_table.m_buydataset.at(index).OrderQty = (tobuy + pn_table.m_buydataset.at(index).UNConvUnits - 1) / pn_table.m_buydataset.at(index).UNConvUnits;
            pn_table.m_buydataset.at(index).MFExtCost = pn_table.m_buydataset.at(index).vendorPrice * pn_table.m_buydataset.at(index).OrderQty;


        }

    }

    LoadData2BuyList();
}



void CPVBuyDlg::LoadData2BuyList()
{
    /* 1, _T("Item"), 80, L
     2, _T("P/N"), 80, Li
     3, _T("Type"), 50, L
     4, _T("Title"), 200,
     5, _T("Detail"), 200
     6, _T("Qty"), 50, Li
     7, _T("Total Qty"),
     8, _T("Item Stock"),
     9, _T("To Buy"), 80,
     10, _T("Unit Price")
     11, _T("Total Price"
     12, _T("Vendor"), 80
     13, _T("Vendor P/N")
     14, _T("VendorDesc")*/
    CString  strTemp;
    m_data_list.DeleteAllItems();
    TotalPrice = 0;
    int i = 0;

    for(; i < (int)pn_table.m_buydataset.size(); i++)
    {
        strTemp.Format(_T("%d"), i + 1);
        m_data_list.InsertItem(i, strTemp);
        m_data_list.SetItemText(i, m_parentPN, pn_table.m_buydataset.at(i).ParentStrPN);
        m_data_list.SetItemText(i, m_pn, pn_table.m_buydataset.at(i).PN);
        m_data_list.SetItemText(i, m_type, pn_table.m_buydataset.at(i).Type);
        m_data_list.SetItemText(i, m_title, pn_table.m_buydataset.at(i).Title);
        m_data_list.SetItemText(i, m_detail, pn_table.m_buydataset.at(i).Detail);
        strTemp.Format(_T("%d"), pn_table.m_buydataset.at(i).Qty);
        m_data_list.SetItemText(i, m_qty, strTemp);
        strTemp.Format(_T("%d"), pn_table.m_buydataset.at(i).TotalQty);
        m_data_list.SetItemText(i, m_totalqty, strTemp);

        m_data_list.SetItemText(i, m_useunit, pn_table.m_buydataset.at(i).UseAs);

        strTemp.Format(_T("%d"), pn_table.m_buydataset.at(i).PNStock);
        m_data_list.SetItemText(i, m_stock, strTemp);

        strTemp.Format(_T("%d"), pn_table.m_buydataset.at(i).OrderQty);

        m_data_list.SetItemText(i, m_orderQty, strTemp);

        strTemp.Format(_T("%d"), pn_table.m_buydataset.at(i).tobuy);

        m_data_list.SetItemText(i, m_needtobuy, strTemp);


        strTemp = pn_table.m_buydataset.at(i).BuyAs;
        m_data_list.SetItemText(i, m_buyas, strTemp);

        strTemp.Format(_T("%0.5f"), pn_table.m_buydataset.at(i).vendorPrice);
        m_data_list.SetItemText(i, m_unitprice, strTemp);


        float money = pn_table.m_buydataset.at(i).MFExtCost;
        strTemp.Format(_T("%0.3f"), money);

        TotalPrice += money;
        m_data_list.SetItemText(i, m_totalprice, strTemp);

        m_data_list.SetItemText(i, m_vendor, pn_table.m_buydataset.at(i).Vendor);
        m_data_list.SetItemText(i, m_vendorpn, pn_table.m_buydataset.at(i).Vendor_PN);


    }

    strTemp.Format(_T("%d"), i + 1);
    m_data_list.InsertItem(i, strTemp);
    strTemp = _T("Total Price:");
    m_data_list.SetItemText(i, 1, strTemp);

    strTemp.Format(_T("%0.2f"), TotalPrice);
    m_data_list.SetItemText(i, m_totalprice, strTemp);
    m_data_list.SetItemBkColor(i, -1, LIST_ITEM_DEFAULT_BKCOLOR_GRAY);

    m_data_list.SetItemTextColor(-1, m_orderQty, RGB(255, 0, 0));
    m_data_list.SetItemTextColor(-1, m_unitprice, RGB(255, 0, 0));
    g_hwnd_now = this->m_hWnd;
}

void CPVBuyDlg::OnSize(UINT nType, int cx, int cy)
{
    CDialogEx::OnSize(nType, cx, cy);

    if(nType == SIZE_RESTORED)
    {
        CRect ViewRect;
        GetClientRect(&ViewRect);

        if(m_data_list.GetSafeHwnd())
        {
            m_data_list.MoveWindow(CRect(370, 50, ViewRect.Width(), ViewRect.Height() - 10), TRUE);
        }
    }
}

#include "AddBOMPLDlg.h"
void CPVBuyDlg::OnBnClickedItemPn()
{
    CAddBOMPLDlg dlg;
    dlg.open_type = 1;
    dlg.pn_table.Load_Assembly_Data();
    dlg.m_message_handle = this->m_hWnd;
    dlg.DoModal();
}


BOOL CPVBuyDlg::PreTranslateMessage(MSG* pMsg)
{
    // TODO: Add your specialized code here and/or call the base class
    if(WM_KEYDOWN == pMsg->message)
    {

        ListCtrlEx::CListCtrlEx* pEdit = (ListCtrlEx::CListCtrlEx*)GetDlgItem(IDC_LIST1);

        ASSERT(pEdit);

        if(pMsg->hwnd == pEdit->GetSafeHwnd() && VK_DELETE == pMsg->wParam)
        {
            if(m_data_list.GetRowCount() - 1 > m_curRow)
            {

                vector<PList_Struct>::iterator pl_iter = pn_table.m_buydataset.begin();

                pn_table.m_buydataset.erase(pl_iter + m_curRow);
                LoadData2BuyList();
            }

        }
    }

    return CDialogEx::PreTranslateMessage(pMsg);
}


void CPVBuyDlg::OnNMClickList1(NMHDR *pNMHDR, LRESULT *pResult)
{
    LPNMITEMACTIVATE pNMItemActivate = reinterpret_cast<LPNMITEMACTIVATE>(pNMHDR);
    CString temp_cstring;
    long lRow, lCol;
    m_data_list.Set_Edit(true);
    DWORD dwPos = GetMessagePos(); //Get which line is click by user.Set the check box, when user enter Insert it will jump to program dialog
    CPoint point(LOWORD(dwPos), HIWORD(dwPos));
    m_data_list.ScreenToClient(&point);
    LVHITTESTINFO lvinfo;
    lvinfo.pt = point;
	lvinfo.flags = LVHT_ABOVE;
	int nItem = m_data_list.SubItemHitTest(&lvinfo);

	lRow = lvinfo.iItem;
	lCol = lvinfo.iSubItem;

	m_curRow = lRow;
	m_curCol = lCol;

    if(lRow > m_data_list.GetItemCount()) //如果点击区超过最大行号，则点击是无效的
        return;

    if(lRow < 0)
        return;

    if(lRow < pn_table.m_buydataset.size())
    {
        if(lCol == 0)
        {

            m_oldColorRow = m_curColorRow;
            m_curColorRow = m_curRow;


            if(m_curColorRow != -1)
            {
                m_data_list.SetItemBkColor(m_curColorRow, -1, LIST_ITEM_SELECTED);
            }

            if(m_oldColorRow != -1)
            {
                m_data_list.SetItemBkColor(m_oldColorRow, -1, RGB(255, 255, 255));
            }

        }

        if(lCol == 1) //Qty
        {
            //  m_data_list.SetCellChecked (lRow,lCol,TRUE);
            /*   for (int i = 0 ;i< (int) m_data_list.GetRowCount ()-1;i++)
               {
                   if (lRow != i)
                   {
                       m_data_list.SetCellChecked (i,lCol,FALSE);
                   }


               }*/



        }

        return  ;


        // ::PostMessage (m_message_handle,WM_MESSAGE_FRESH_BOM,pn_table.pv_Table_PN.at(m_curRow).PNID,0);
    }

    *pResult = 0;
}


void CPVBuyDlg::OnBnClickedDelItem()
{
    if(m_data_list.GetRowCount() - 1 > m_curRow)
    {

        vector<PList_Struct>::iterator pl_iter = pn_table.m_buydataset.begin();

        pn_table.m_buydataset.erase(pl_iter + m_curRow);
        LoadData2BuyList();
    }
}
//struct PList_Struct{
//    int PLID;
//    int Item;
//    int Qty;
//    int ParentPNID;
//    CString ParentStrPN;
//    CString PN   PartName;
//    CString Type  Type;
//    CString Title  PartTitle;
//    CString Detail  PartDetail;
//    CString Reference;
//    int PNStock  0;
//    float MFExtCost;
//    float MFCost  Cost;
//    CString Vendor  VendorName;
//    CString Vendor_PN  VendorPN;
//    CString Vendor_Desc;
//    CString Mfr;
//    CString Mfr_PN;
//    int PNUNID;
//    CString BuyAs  BuyAs;
//    CString UseAs ;
//};
//struct Part_Vendor_Information{
//    int PNID;
//    int LNKID;
//    int SUID;
//    int LNKUNID;
//    CString PartName;
//    CString PartTitle;
//    CString PartDetail;
//    CString Type;
//    CString VendorName;
//    CString VendorPN;
//    CString BuyAs;
//    CString Vendor_Description;
//    CString LeadTime;
//    int AtLevel;
//    float Cost;
//    CString Notes;
//
//};
#include "ItemAndScourceDlg.h"
void CPVBuyDlg::OnBnClickedAddItem()
{
    CItemAndScourceDlg dlg;
    int index = -1;

    if(dlg.DoModal() == IDOK)
    {
        PList_Struct temp_struct;

        for(int i = 0; i < dlg.m_dataset_selector.size(); i++)
        {
            //    CString PN   PartName;
            //    CString Type  Type;
            //    CString Title  PartTitle;
            //    CString Detail  PartDetail;
            //    CString Reference;
            //    int PNStock  0;
            //    float MFExtCost;
            //    float MFCost  Cost;
            //    CString Vendor  VendorName;
            //    CString Vendor_PN  VendorPN;
            //    CString Vendor_Desc;
            //    CString Mfr;
            //    CString Mfr_PN;
            //    int PNUNID;
            //    CString BuyAs  BuyAs;
            //    CString UseAs ;
            temp_struct.PLID = dlg.m_dataset_selector.at(i).PNID;
            temp_struct.PN =  dlg.m_dataset_selector.at(i).PartName;
            temp_struct.Type =  dlg.m_dataset_selector.at(i).Type;
            temp_struct.Title = dlg.m_dataset_selector.at(i).PartTitle;
            temp_struct.Detail = dlg.m_dataset_selector.at(i).PartDetail;
            temp_struct.MFCost = dlg.m_dataset_selector.at(i).Cost;
            temp_struct.MFExtCost = 0;
            temp_struct.Qty = 0;
            temp_struct.TotalQty = 0;
            temp_struct.tobuy = 0;
            temp_struct.Vendor = dlg.m_dataset_selector.at(i).VendorName;
            temp_struct.Vendor_PN = dlg.m_dataset_selector.at(i).VendorPN;
            temp_struct.Vendor_Desc = dlg.m_dataset_selector.at(i).Vendor_Description;
            temp_struct.PNStock = 0;
            temp_struct.LNKID = dlg.m_dataset_selector.at(i).LNKID;
            temp_struct.BuyAs = dlg.m_dataset_selector.at(i).BuyAs;
            temp_struct.UseAs = dlg.m_dataset_selector.at(i).UseAs;
            temp_struct.UNConvUnits = dlg.m_dataset_selector.at(i).UNConvUnits;
            temp_struct.vendorPrice = dlg.m_dataset_selector.at(i).VendorCost;
            /*
                 Date:[11/11/2015]
                 Author:[Alex]
                 Function:
                 检查看看选择的这个产品是不是在产品列表里面
                 如果在产品列表里面，就不加了


            */
            BOOL is_in_list = FALSE;

            for(vector<PList_Struct>::iterator iter = pn_table.m_buydataset.begin(); iter != pn_table.m_buydataset.end(); iter++)
            {
                if(iter->PLID == temp_struct.PLID)
                {
                    is_in_list = TRUE;
                    index = iter -  pn_table.m_buydataset.begin();
                    break;
                }
            }

            if(!is_in_list)
            {
                pn_table.m_buydataset.push_back(temp_struct);
            }


        }
    }

    LoadData2BuyList();

    if(index != -1)
    {
        m_data_list.SetItemBkColor(index, -1, COLORREF(RGB(255, 0, 0)));
    }
}


void CPVBuyDlg::OnBnClickedButtonDelAll()
{
    pn_table.m_buydataset.clear();
    LoadData2BuyList();
}

void CPVBuyDlg::OnBnClickedSendToPo()
{
    UpdateData(TRUE);

    if(m_strPO.IsEmpty())
    {
        AfxMessageBox(_T("Please Input a PO Number!"));
        return;
    }

    //m_strBuyer
    if(m_strBuyer.IsEmpty())
    {
        AfxMessageBox(_T("Please Input a Buyer Name!"));
        return;
    }

    //m_strEngrgContact)
    if(m_strEngrgContact.IsEmpty())
    {
        AfxMessageBox(_T("Please Input a Engrg Contact or Name!"));
        return;
    }

    if(m_strShipAddress.IsEmpty())
    {
        AfxMessageBox(_T("Please input a shippment address!"));
        return;
    }

    int index = 0;

    for(vector<PList_Struct>::iterator iter_buy = pn_table.m_buydataset.begin(); iter_buy != pn_table.m_buydataset.end(); iter_buy++)
    {
        if(iter_buy->Vendor.IsEmpty())
        {
            continue;
        }

        PO_Struct temp_struct;
        temp_struct.POMSupplier = iter_buy->Vendor;
        BOOL is_in_list = FALSE;

        for(vector<PO_Struct>::iterator iter_Vendor = m_allpos.begin(); iter_Vendor != m_allpos.end(); iter_Vendor++)
        {
            if(temp_struct.POMSupplier.CompareNoCase(iter_Vendor->POMSupplier) == 0)
            {
                is_in_list = TRUE;
                break;
            }
        }

        //检索出vendor
        if(!is_in_list)
        {
            ++index;
            temp_struct.POMNumber.Format(_T("%s-%3d"), m_strPO, index);
            temp_struct.POMFromBuyer = m_strBuyer;
            temp_struct.POMEngrgContact = m_strEngrgContact;
            temp_struct.POMDateReq = _T("ASAP");
            temp_struct.POMShipTo = m_strShipAddress;
            m_allpos.push_back(temp_struct);
        }
    }

    for(int i = 0; i < m_allpos.size(); i++)
    {
        m_allpos.at(i) = pn_table.Insert_PO(m_allpos.at(i));   //插入，并更新,PO 主表Vendor
    }

    //更新子表信息

    for(int i = 0; i < m_allpos.size(); i++)
    {
        int item = 0;
        float TotalCost = 0.0;
        PO_Struct po_temp = m_allpos.at(i);

        for(int pp = 0; pp < pn_table.m_buydataset.size(); pp++)
        {
            if(m_allpos.at(i).POMSupplier.CompareNoCase(pn_table.m_buydataset.at(pp).Vendor) == 0)
            {
                ++item;
                PO_Part_Struct ppstruct;
                ppstruct.Buy_As = pn_table.m_buydataset.at(pp).BuyAs;
                ppstruct.Descrition = pn_table.m_buydataset.at(pp).Detail;
                ppstruct.Item = item;
                ppstruct.PN = pn_table.m_buydataset.at(pp).PN;
                ppstruct.POCost = pn_table.m_buydataset.at(pp).vendorPrice;
                ppstruct.POExtension = pn_table.m_buydataset.at(pp).OrderQty * pn_table.m_buydataset.at(pp).vendorPrice;
                TotalCost +=   ppstruct.POExtension;
                ppstruct.POLNKID = pn_table.m_buydataset.at(pp).LNKID;
                ppstruct.POPOMID = m_allpos.at(i).POMID;
                ppstruct.Qty =  pn_table.m_buydataset.at(pp).OrderQty;
                //2016/01/11
                ppstruct.Use_As = pn_table.m_buydataset.at(pp).UseAs;
                ppstruct.UnitCov = pn_table.m_buydataset.at(pp).UNConvUnits;

                //2016/01/11
                pn_table.Insert_PO_Part(ppstruct);

            }

        }

        po_temp.POMTotalCost = TotalCost;

        pn_table.Update_PO(po_temp);
    }


    AfxMessageBox(_T("Sucessfully,Please go to PO Page!"));
}

LRESULT CPVBuyDlg::Change_Item_List(WPARAM wParam, LPARAM lParam)
{

    int Changed_Item = (int)wParam;
    int Changed_SubItem = (int)lParam;
    int AddressValue = -1;
    CString temp_task_info;
    temp_task_info = m_data_list.GetItemText(Changed_Item, Changed_SubItem);

    if(Changed_SubItem == m_orderQty)
    {
        int OrderQty  = _wtoi(temp_task_info);

        if(pn_table.m_buydataset.at(Changed_Item).OrderQty == OrderQty)
        {
            return 0;
        }


        pn_table.m_buydataset.at(Changed_Item).OrderQty = OrderQty;
        pn_table.m_buydataset.at(Changed_Item).MFExtCost = pn_table.m_buydataset.at(Changed_Item).vendorPrice * pn_table.m_buydataset.at(Changed_Item).OrderQty;
    }

    if(Changed_SubItem == m_unitprice)
    {
        float price  = _wtof(temp_task_info);

        if(pn_table.m_buydataset.at(Changed_Item).vendorPrice - price < 0.00001)
        {
            return 0;
        }

        pn_table.m_buydataset.at(Changed_Item).vendorPrice = price;

        pn_table.m_buydataset.at(Changed_Item).MFExtCost = pn_table.m_buydataset.at(Changed_Item).vendorPrice * pn_table.m_buydataset.at(Changed_Item).OrderQty;
    }

    LoadData2BuyList();
    return 0;
}

void CPVBuyDlg::OnBnClickedShowHide()
{
    if(m_hide_show) //隐藏起来
    {
        GetDlgItem(IDC_STATIC_ASSEMBLY)->ShowWindow(SW_HIDE);
        GetDlgItem(IDC_STATIC_PN)->ShowWindow(SW_HIDE);
        GetDlgItem(IDC_STATIC_TITLE)->ShowWindow(SW_HIDE);
        GetDlgItem(IDC_STATIC_DETAIL)->ShowWindow(SW_HIDE);
        GetDlgItem(IDC_STATIC_NUMBER_UNIT)->ShowWindow(SW_HIDE);
        GetDlgItem(IDC_STATIC_POSETTING)->ShowWindow(SW_HIDE);
        GetDlgItem(IDC_STATIC_PO_BEGIN)->ShowWindow(SW_HIDE);
        GetDlgItem(IDC_STATIC_ENGCONTACT)->ShowWindow(SW_HIDE);
        GetDlgItem(IDC_STATIC_SHIPADDRESS)->ShowWindow(SW_HIDE);
        GetDlgItem(IDC_STATIC_BUYER)->ShowWindow(SW_HIDE);
        GetDlgItem(IDC_EDIT_PN)->ShowWindow(SW_HIDE);
        GetDlgItem(IDC_EDIT_TITLE)->ShowWindow(SW_HIDE);
        GetDlgItem(IDC_EDIT_DETAIL)->ShowWindow(SW_HIDE);
        GetDlgItem(IDC_EDIT_NUMBER)->ShowWindow(SW_HIDE);
        GetDlgItem(IDC_BUILD_LIST_BUTTON)->ShowWindow(SW_HIDE);
        GetDlgItem(IDC_EDIT_PO)->ShowWindow(SW_HIDE);
        GetDlgItem(IDC_EDIT_BUYER)->ShowWindow(SW_HIDE);
        GetDlgItem(IDC_EDIT_ENGRG)->ShowWindow(SW_HIDE);
        GetDlgItem(IDC_SHIP_ADDRESS)->ShowWindow(SW_HIDE);
        GetDlgItem(IDC_SEND_TO_PO)->ShowWindow(SW_HIDE);
        GetDlgItem(IDC_ITEM_PN)->ShowWindow(SW_HIDE);
        m_hide_show = FALSE;
        CRect ViewRect;
        GetClientRect(&ViewRect);

        if(m_data_list.GetSafeHwnd())
        {
            m_data_list.MoveWindow(CRect(0, 50, ViewRect.Width(), ViewRect.Height() - 10), TRUE);
        }
    }
    else
    {
        m_hide_show = TRUE;

        GetDlgItem(IDC_STATIC_ASSEMBLY)->ShowWindow(SW_SHOW);
        GetDlgItem(IDC_STATIC_PN)->ShowWindow(SW_SHOW);
        GetDlgItem(IDC_STATIC_TITLE)->ShowWindow(SW_SHOW);
        GetDlgItem(IDC_STATIC_DETAIL)->ShowWindow(SW_SHOW);
        GetDlgItem(IDC_STATIC_NUMBER_UNIT)->ShowWindow(SW_SHOW);
        GetDlgItem(IDC_STATIC_POSETTING)->ShowWindow(SW_SHOW);
        GetDlgItem(IDC_STATIC_PO_BEGIN)->ShowWindow(SW_SHOW);
        GetDlgItem(IDC_STATIC_ENGCONTACT)->ShowWindow(SW_SHOW);
        GetDlgItem(IDC_STATIC_SHIPADDRESS)->ShowWindow(SW_SHOW);
        GetDlgItem(IDC_STATIC_BUYER)->ShowWindow(SW_SHOW);
        GetDlgItem(IDC_EDIT_PN)->ShowWindow(SW_SHOW);
        GetDlgItem(IDC_EDIT_TITLE)->ShowWindow(SW_SHOW);
        GetDlgItem(IDC_EDIT_DETAIL)->ShowWindow(SW_SHOW);
        GetDlgItem(IDC_EDIT_NUMBER)->ShowWindow(SW_SHOW);
        GetDlgItem(IDC_BUILD_LIST_BUTTON)->ShowWindow(SW_SHOW);
        GetDlgItem(IDC_EDIT_PO)->ShowWindow(SW_SHOW);
        GetDlgItem(IDC_EDIT_BUYER)->ShowWindow(SW_SHOW);
        GetDlgItem(IDC_EDIT_ENGRG)->ShowWindow(SW_SHOW);
        GetDlgItem(IDC_SHIP_ADDRESS)->ShowWindow(SW_SHOW);
        GetDlgItem(IDC_SEND_TO_PO)->ShowWindow(SW_SHOW);
        GetDlgItem(IDC_ITEM_PN)->ShowWindow(SW_SHOW);
        CRect ViewRect;
        GetClientRect(&ViewRect);

        if(m_data_list.GetSafeHwnd())
        {
            m_data_list.MoveWindow(CRect(370, 50, ViewRect.Width(), ViewRect.Height() - 10), TRUE);
        }
    }
}
