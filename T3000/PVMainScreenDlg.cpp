// PVMainScreenDlg.cpp : implementation file
//

#include "stdafx.h"
#include "T3000.h"
#include "PVMainScreenDlg.h"
#include "afxdialogex.h"
#include <climits>
#include <ciso646>
#include "NewPNDlg.h"
#include "PartVendorQuotationDlg.h"


// CPVMainScreenDlg dialog

IMPLEMENT_DYNAMIC(CPVMainScreenDlg, CDialogEx)

CPVMainScreenDlg::CPVMainScreenDlg(CWnd* pParent /*=NULL*/)
    : CDialogEx(CPVMainScreenDlg::IDD, pParent)
{
    m_select_type = 0;
    m_PVIMaster= NULL;
    m_PVVendor= NULL;
    m_PVPO = NULL;
    m_PvBuild = NULL;
    m_PvBuy = NULL;
	m_pvCustomer = NULL;
}

CPVMainScreenDlg::~CPVMainScreenDlg()
{
}

void CPVMainScreenDlg::DoDataExchange(CDataExchange* pDX)
{
    CDialogEx::DoDataExchange(pDX);
    DDX_Control(pDX, IDC_STATIC_LIST_VIEW, m_view_static);
    // DDX_Control(pDX, IDC_SPLITTERBUTTON, m_splitterbutton);
    DDX_Control(pDX, IDC_ITEM_MASTER, m_button_IM);
}


BEGIN_MESSAGE_MAP(CPVMainScreenDlg, CDialogEx)
    ON_BN_CLICKED(IDC_ITEM_MASTER, &CPVMainScreenDlg::OnBnClickedItemMaster)
    ON_WM_SIZE()
    //ON_COMMAND(ID_PN_NEWPN, &CPVMainScreenDlg::OnPnNewpn)
    ON_BN_CLICKED(IDC_VENDOR, &CPVMainScreenDlg::OnBnClickedVendor)
    ON_BN_CLICKED(IDC_PO, &CPVMainScreenDlg::OnBnClickedPo)

    /*   ON_COMMAND(ID_PARTS_MAINTAINVENDOR, &CPVMainScreenDlg::OnPartsMaintainvendor)*/
    ON_BN_CLICKED(IDC_PO2, &CPVMainScreenDlg::OnBnClickedPo2)
    ON_BN_CLICKED(IDC_BUY, &CPVMainScreenDlg::OnBnClickedBuy)
    ON_COMMAND(ID_SETTING_UNITSOFMEASURE, &CPVMainScreenDlg::OnSettingUnitsofmeasure)
    ON_WM_SYSCOMMAND()
    ON_COMMAND(ID_SETTING_IMPORTBOM, &CPVMainScreenDlg::OnSettingImportbom)
    ON_COMMAND(ID_SETTING_EXIT, &CPVMainScreenDlg::OnSettingExit)
    ON_BN_CLICKED(IDC_WAREHOUSE, &CPVMainScreenDlg::OnBnClickedWarehouse)
    ON_COMMAND(ID_SETTING_CURRENCIES, &CPVMainScreenDlg::OnSettingCurrencies)
    ON_COMMAND(ID_SETTING_UPDATEPNSEARCHDATA, &CPVMainScreenDlg::OnSettingUpdatepnsearchdata)
	ON_BN_CLICKED(IDC_CUSTOMERS, &CPVMainScreenDlg::OnBnClickedCustomers)
END_MESSAGE_MAP()


// CPVMainScreenDlg message handlers


BOOL CPVMainScreenDlg::OnInitDialog()
{
    CDialogEx::OnInitDialog();

    CRect ViewRect;
    GetClientRect(&ViewRect);

    if (m_view_static.GetSafeHwnd())
    {
        m_view_static.MoveWindow(CRect(120,0,ViewRect.Width(),ViewRect.Height()),TRUE);
    }

  Initial_all_dialogs();
  Switch_Windows();


//     CString g_configfile_path=g_strExePth+_T("T3000_config.ini");
//     CString strTemp= g_strExePth + _T("Database\\PV\\PV.mdb");
//     CString path;
//     GetPrivateProfileString(_T("PartsVendors"),_T("PVDB"),strTemp,path.GetBuffer (MAX_PATH),MAX_PATH,g_configfile_path);
//     path.ReleaseBuffer ();



    CString StrTitle;
    StrTitle.Format (_T("Part&Vendor Main Frame:Rev1.1MSSQL"));
    SetWindowText (StrTitle);
   
    MoveWindow (0,0,ViewRect.Width ()-230,ViewRect.Height ());


  
     
    return TRUE;

}
void CPVMainScreenDlg::Initial_all_dialogs()
{
    //ItemMaster
    if (m_PVIMaster==NULL)
    {
        m_PVIMaster = new CPVItemMasterDlg;
        if (!m_PVIMaster->Create(CPVItemMasterDlg::IDD,this))
        {
            return;
        }
    }
    if (m_PVVendor==NULL)
    {
        m_PVVendor = new CPVVendorDlg;
        if (!m_PVVendor->Create(CPVVendorDlg::IDD,this))
        {
            return;
        }
    }
    if (m_PVPO == NULL)
    {
        m_PVPO = new CPVPODlg;
        if (!m_PVPO->Create(CPVPODlg::IDD,this))
        {
            return;
        }
    }
    if (m_PvBuild == NULL)
    {
        m_PvBuild = new CPVBuildDlg;
        if (!m_PvBuild->Create(CPVBuildDlg::IDD,this))
        {
            return;
        }
    }
    if (m_PvBuy == NULL)
    {
        m_PvBuy = new CPVBuyDlg;
        if (!m_PvBuy->Create (CPVBuyDlg::IDD,this))
        {
            return;
        }
    }
	if (m_pvCustomer == NULL)
	{
		m_pvCustomer = new CCustomerDlg;

		if (!m_pvCustomer->Create(CCustomerDlg::IDD,this))
		{
			return ;
		}
	}
}
void CPVMainScreenDlg::Switch_Windows()
{
    CRect rcWnd;
    CWnd* pWnd = GetDlgItem(IDC_STATIC_LIST_VIEW);
    pWnd->GetWindowRect(rcWnd);
    ScreenToClient(rcWnd);
    if (m_select_type == 0)
    {
        m_PVIMaster->ShowWindow(SW_SHOW);
        m_PVVendor->ShowWindow(SW_HIDE);
        m_PVPO->ShowWindow(SW_HIDE);
        m_PvBuild->ShowWindow (SW_HIDE);
        m_PvBuy->ShowWindow (SW_HIDE);
		m_pvCustomer->ShowWindow(SW_HIDE);
        //m_PVIMaster->pn_table.Initial_Data();
        // m_PVIMaster->Load_DataToList();

        m_PVIMaster->MoveWindow(&rcWnd);
    }
    else if (m_select_type == 1)
    {
        m_PVIMaster->ShowWindow(SW_HIDE);
        m_PVVendor->ShowWindow(SW_SHOW);
        m_PVPO->ShowWindow(SW_HIDE);
        m_PvBuild->ShowWindow (SW_HIDE);
        m_PvBuy->ShowWindow (SW_HIDE);
		m_pvCustomer->ShowWindow(SW_HIDE);
        // m_PVVendor->pn_table.Initial_Vendor();
        // m_PVVendor->Load_DataToList();
        m_PVVendor->MoveWindow(&rcWnd);

    }
    else if (m_select_type == 2)
    {
        m_PVPO->ShowWindow(SW_SHOW);
        m_PVIMaster->ShowWindow(SW_HIDE);
        m_PVVendor->ShowWindow(SW_HIDE);
        m_PvBuild->ShowWindow (SW_HIDE);
        m_PvBuy->ShowWindow (SW_HIDE);
		m_pvCustomer->ShowWindow(SW_HIDE);

       /* m_PVPO->pn_table.Initial_PO();
        m_PVPO->Load_DataToList();*/
        m_PVPO->MoveWindow(&rcWnd);
    }
    else if (m_select_type == 3)
    {
        m_PVPO->ShowWindow(SW_HIDE );
        m_PVIMaster->ShowWindow(SW_HIDE);
        m_PVVendor->ShowWindow(SW_HIDE);
        m_PvBuy->ShowWindow (SW_HIDE);
        m_PvBuild->ShowWindow (SW_SHOW);
		m_pvCustomer->ShowWindow(SW_HIDE);
        m_PvBuild->MoveWindow(&rcWnd);
    }
    else if (m_select_type == 4)
    {
        m_PVPO->ShowWindow(SW_HIDE );
        m_PVIMaster->ShowWindow(SW_HIDE);
        m_PVVendor->ShowWindow(SW_HIDE);
        m_PvBuild->ShowWindow (SW_HIDE);
		m_pvCustomer->ShowWindow(SW_HIDE);

        m_PvBuy->ShowWindow (SW_SHOW);
        m_PvBuy->MoveWindow(&rcWnd);
    }
	else if (m_select_type == 5)
	{
		m_PVPO->ShowWindow(SW_HIDE );
		m_PVIMaster->ShowWindow(SW_HIDE);
		m_PVVendor->ShowWindow(SW_HIDE);
		m_PvBuild->ShowWindow (SW_HIDE);
		m_PvBuy->ShowWindow (SW_HIDE);

		m_pvCustomer->ShowWindow(SW_SHOW);
		m_pvCustomer->MoveWindow(&rcWnd);
	}
    if (!m_PVIMaster->IsWindowVisible ())
    {
        if (m_PVIMaster->PartWindow->IsWindowVisible ())
        {
            m_PVIMaster->PartWindow->ShowWindow (FALSE);
        }
        if (m_PVIMaster->PartQuatationWindow->IsWindowVisible())
        {
            m_PVIMaster->PartQuatationWindow->ShowWindow (FALSE);
        }

    }
}

void CPVMainScreenDlg::OnBnClickedItemMaster()
{
    if (m_select_type != 0)
    {
        m_select_type = 0;
        Switch_Windows() ;
    }
}
void CPVMainScreenDlg::OnBnClickedVendor()
{
    if (m_select_type != 1)
    {
        m_select_type = 1;
		//Initial_all_dialogs();
        Switch_Windows();
    }
}
void CPVMainScreenDlg::OnBnClickedPo()
{
    if (m_select_type != 2)
    {
        m_select_type = 2;
        Switch_Windows();
    }
}
void CPVMainScreenDlg::OnSize(UINT nType, int cx, int cy)
{
    CDialogEx::OnSize(nType, cx, cy);
    if (nType == SIZE_MAXIMIZED)
    {
        CRect ViewRect;
        GetClientRect(&ViewRect);

        if (m_view_static.GetSafeHwnd())
        {
            m_view_static.MoveWindow(CRect(120,0,ViewRect.Width(),ViewRect.Height()),TRUE);
            CRect rcWnd;
            CWnd* pWnd = GetDlgItem(IDC_STATIC_LIST_VIEW);
            pWnd->GetWindowRect(rcWnd);
            ScreenToClient(rcWnd);
            m_PVIMaster->MoveWindow(&rcWnd);
            m_PVVendor->MoveWindow(&rcWnd);
            m_PVPO->MoveWindow(&rcWnd);
            m_PvBuild->MoveWindow (&rcWnd);
            m_PvBuy->MoveWindow (&rcWnd);
			m_pvCustomer->MoveWindow(&rcWnd);
        }
    }
    if (nType==SIZE_RESTORED)
    {

        CRect ViewRect;
        GetClientRect(&ViewRect);

        if (m_view_static.GetSafeHwnd())
        {
            m_view_static.MoveWindow(CRect(120,0,ViewRect.Width(),ViewRect.Height()),TRUE);
            CRect rcWnd;
            CWnd* pWnd = GetDlgItem(IDC_STATIC_LIST_VIEW);
            pWnd->GetWindowRect(rcWnd);
            ScreenToClient(rcWnd);
            m_PVIMaster->MoveWindow(&rcWnd);
            m_PVVendor->MoveWindow(&rcWnd);
            m_PVPO->MoveWindow(&rcWnd);
            m_PvBuild->MoveWindow (&rcWnd);
            m_PvBuy->MoveWindow (&rcWnd);
			m_pvCustomer->MoveWindow(&rcWnd);
        }

    }

}

void CPVMainScreenDlg::OnBnClickedPo2()
{
    if (m_select_type != 3)
    {
        m_select_type = 3;
        Switch_Windows();
    }
}


void CPVMainScreenDlg::OnBnClickedBuy()
{
    if (m_select_type != 4)
    {
        m_select_type = 4;
        Switch_Windows();
    }
}

#include "PVUnitMeasureDlg.h"
void CPVMainScreenDlg::OnSettingUnitsofmeasure()
{
    CPVUnitMeasureDlg dlg;
    dlg.DoModal ();
 
}


void CPVMainScreenDlg::OnSysCommand(UINT nID, LPARAM lParam)
{
    
    CDialogEx::OnSysCommand(nID, lParam);
}


#include "PVImportBOMDlg.h"
void CPVMainScreenDlg::OnSettingImportbom()
{
    CPVImportBOMDlg dlg;
    dlg.DoModal ();
}


void CPVMainScreenDlg::OnSettingExit()
{
    //CDialogEx::OnOK();
}

#include "NewPNDlg.h"
void CPVMainScreenDlg::OnBnClickedWarehouse()
{
    CNewPNDlg dlg;
    dlg.m_new_item = 0;
    dlg.m_saveCloseWindow = TRUE;
    dlg.DoModal();
}

#include "PVCurrenciesDlg.h"
void CPVMainScreenDlg::OnSettingCurrencies()
{
     CPVCurrenciesDlg dlg;
     dlg.DoModal ();
}


void CPVMainScreenDlg::OnSettingUpdatepnsearchdata()
{
    PVDatabase.Update_PN_SearchData ();

    AfxMessageBox (_T("Update Sucessfully!"));
}


void CPVMainScreenDlg::OnBnClickedCustomers()
{
	if (m_select_type != 5)
	{
		m_select_type = 5;
		Switch_Windows();
	}
}
