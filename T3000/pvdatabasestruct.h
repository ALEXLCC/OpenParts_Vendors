#pragma once
#include "afxcmn.h"
#include <vector>
#include "bado/BADO.h"
using namespace std;

#define  WM_MESSAGE_FRESH_BOM WM_USER + 3333
#define  WM_MESSAGE_FRESH_BOMLIST WM_USER + 3334
#define  WM_MESSAGE_ADD_VENDORS_ITEM WM_USER + 3335
#define  WM_MESSAGE_BACK WM_USER + 3336
#define  WM_MESSAGE_FRESH_PN_DETAIL WM_USER + 3337
#define  WM_MESSAGE_ITEM_MASTER WM_USER + 3338

#define WM_MESSAGE_ITEM_VENDORS_LIST WM_USER + 3339

#define WM_MESSAGE_ITEM_RELOAD_ALLDATA WM_USER + 3340
struct PN_Struct{
 int PNID;
 CString PNPartNumber;
 CString PNTitle;
 CString PNDetail;
 CString PNType;
 CString PNRevision;
 CString PNStatus;
 int PNUNID;
 CString ReqBy;
 float PNCurrentCost;
 CString PNPrintFooter;//PNUser3
 float PNMinStockQty;
 float PNLastRollupCost;
 float Stock;//Qty
 CString PNNote;
 CString PNImageName;
 PN_Struct()
 {
       PNID = -1;
       PNPartNumber= L"";
       PNTitle= L"";
       PNDetail= L"";
       PNType= L"";
       PNRevision= L"";
       PNStatus= L"";
       PNUNID = 0;
       ReqBy=L"";
       PNCurrentCost = 0;
       PNPrintFooter=L"";//PNUser3
       PNMinStockQty = 0;
       PNLastRollupCost = 0;
       Stock = 0;//Qty
       PNNote =L"";
       PNImageName = L"";
 }
  
};

struct PList_Struct{
int PLID;
int Item;
int Qty;
int TotalQty;
int LNKID;
int PartID;
int ParentPNID;
CString ParentStrPN;
CString PN;
CString Type;
CString Title;
CString Detail;
CString Reference;
int PNStock;
float MFExtCost;
float MFCost;
CString Vendor;
CString Vendor_PN;
CString Vendor_Desc;
CString Mfr;
CString Mfr_PN; 
int PNUNID;
int BuyUNID;
CString BuyAs;
CString UseAs ;
int UNConvUnits;
int tobuy;
int OrderQty;
float vendorPrice;

};
 
struct TreePL_Struct{
 PList_Struct PLItem;
 int Pos;
 int Flag;
};
struct SU_Struct{
    int SUID;
    CString SUSupplier;
    CString SUAddress;
    CString SUCountry;
    CString SUPhone1;
    CString SUPhone2;
    CString SUFAX;
    CString SUWeb;
    CString SUContact1;
    CString SUContact2;
    CString SUDateLast;
    BOOL    SUFollowup;
    CString SUNotes;
    CString SUCode;  
    CString SUAccount;
    CString SUTerms;
    CString SUFedTaxID;
    CString SUStateTaxID;
    CString SUEMail1;
    CString SUEMail2;
    BOOL SUCurDedExRate;
    int SUCurExRate;
    int SUCURID;
    BOOL SUCurReverse;
    BOOL SUNoPhonePrefix;

};
struct CUR_Struct 
{

        int CURID ;
        CString CURCurrencyName; 
        double CURExchangeRate;
       CString CURCurrencyChar    ;
       CString CURFormat  ;
       CString CURFormatExt;
        
}  ;
struct PO_Struct{
  int      POMID	 ;
  CString  POMNumber	;
  CString  POMDatePrinted	 ;
  CString  POMSupplier	 ;
  CString  POMAddress;
  CString  POMSupplier_Phone;
  int      POMSUID	 ;
  CString  POMAccount	;
  CString  POMNotes	  ;
  CString  POMAttnTo	 ;
  CString  POMFromBuyer	  ;
  CString  POMEngrgContact	   ;
  CString  POMDateReq	        ;
  CString  POMDateClosed	     ;
  CString  POMFOB	              ;
  CString  POMTerms	               ;
  BOOL     POMInsurance	            ;
  BOOL     POMUseOurShpngAcct	     ;
  CString  POMShippingAcct	          ;
  BOOL     POMThisIsRFQ	               ;
  BOOL     POMPendingPrint	            ;
  float    POMTaxRate	                 ;
  CString  POMShipMethod	             ;
  CString  POMShipTo	                  ;
  float  POMTaxRate2	                   ;
  float  POMTaxTotal2	                    ;
  float  POMTax2OnTax1	                 ;
  float  POMTotalCost	                      ;
  float  POMTotalTax	                       ;
  float  POMSubTotal	                        ;
  int  POMCURID	                             ;
  CString  POMCurName	                          ;
  float  POMCurExRate	                           ;
  CString  POMDateReqDate                           ;
};

struct PO_Part_Struct{
    int POID;
    int POPOMID;
    int POLNKID;
    int Item;
    CString  PN;
    CString Descrition;
    CString Buy_As;
    CString Use_As;
    float POCost;
    float POExtension;
    float Qty; 
    float RvcdQty;
    BOOL  RvcdAll;
    int UnitCov;
};

struct Type_Struct{
int TYPEID;
CString TYPEType;
};

struct UN_Struct{
int UNID;
CString UNUseUnits;
CString UNPurchUnits;
int UNConvUnits;
};

struct BOM_PartList{
    int PLID;
    int PLListID;
    int PLPartID;
    int PLItem;
    CString PLQty;
    CString PLRefMemo;
};

struct Vendor_Information_BasedOn_Part{
    int PNID;
    int LNKID;
    int SUID;
    int LNKUNID;
    CString VendorName;
    CString VendorPN;
    CString BuyAs;
    CString Vendor_Description; 
    CString LeadTime;
    int AtLevel;
    float Cost;
    CString Notes;
    int Primary;
};

struct Part_Vendor_Information{
    int PNID;
    int LNKID;
    int SUID;
    int LNKUNID;
    CString PartName;
    CString PartTitle;
    CString PartDetail;
    CString Type;
    CString VendorName;
    CString VendorPN;
    CString BuyAs;
    CString UseAs;
    int UNConvUnits;

    CString Vendor_Description; 
    CString LeadTime;
    int AtLevel;
    float Cost;
    float VendorCost;
    CString Notes;
     
};

struct Cost_Struct{
	int COSTID;
	int COSTLNKID;
	float COSTAtQty;
	float COSTCost;
	int LeadTime;
};  

struct CU_Struct{
	int	CUID  ;
	CString	CUCustomer  ;
	CString	CUAddress  ;
	CString	CUShipAddress  ;
	CString	CUPhone1 ;
	CString	CUPhone2 ;
	CString	CUContact1 ;
	CString	CUContact2 ;
	CString	CUFax ;
	CString	CUEmail1 ;
	CString	CUEmail2 ;
	CString	CUNotes ;
	CString	CUWeb ;
	CString	CUCode ;
	CString	CUAccount ;
	CString	CUTerms ;
	CString	CUFedTaxID ;
	CString	CUStateTaxID ;
	bool	CUNoPhonePrefix ;
};
                                    