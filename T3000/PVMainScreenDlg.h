#pragma once
#include "PVItemMasterDlg.h"
#include "afxwin.h"
#include "PVVendorDlg.h"
#include "PVPODlg.h"
#include "PVBuildDlg.h"
#include "PVBuyDlg.h"
#include "../ControlSplitter/ControlSplitter.h"
#include "afxbutton.h"
#include "PVDatabase.h"
#include "CustomerDlg.h"
#include "NewPNDlg.h"

// CPVMainScreenDlg dialog

class CPVMainScreenDlg : public CDialogEx
{
	DECLARE_DYNAMIC(CPVMainScreenDlg)

public:
	CPVMainScreenDlg(CWnd* pParent = NULL);   // standard constructor
	virtual ~CPVMainScreenDlg();

// Dialog Data
	enum { IDD = IDD_PV_MAIN_SCREEN };

protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support

	DECLARE_MESSAGE_MAP()
public:
    virtual BOOL OnInitDialog();
    void Initial_all_dialogs();
    void Switch_Windows();
public:
int m_select_type;
CPVItemMasterDlg *m_PVIMaster;
CPVVendorDlg   *m_PVVendor;
CPVPODlg *m_PVPO;
CPVBuildDlg *m_PvBuild;
CPVBuyDlg *m_PvBuy;
CCustomerDlg *m_pvCustomer;
afx_msg void OnBnClickedItemMaster();
afx_msg void OnSize(UINT nType, int cx, int cy);
CStatic m_view_static;
//afx_msg void OnPnNewpn();
afx_msg void OnBnClickedVendor();
afx_msg void OnBnClickedPo();

afx_msg void OnBnClickedPo2();
afx_msg void OnBnClickedBuy();

afx_msg void OnSettingUnitsofmeasure();
afx_msg void OnSysCommand(UINT nID, LPARAM lParam);
afx_msg void OnSettingImportbom();
afx_msg void OnSettingExit();
afx_msg void OnBnClickedWarehouse();
CMFCButton m_button_IM;
afx_msg void OnSettingCurrencies();
afx_msg void OnSettingUpdatepnsearchdata();


Table_PN PVDatabase;
afx_msg void OnBnClickedCustomers();
};
