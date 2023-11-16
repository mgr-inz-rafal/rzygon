
// RzygonBitmapConverterDlg.h : header file
//

#pragma once
#include "afxwin.h"


// CRzygonBitmapConverterDlg dialog
class CRzygonBitmapConverterDlg : public CDialogEx
{
// Construction
public:
	CRzygonBitmapConverterDlg(CWnd* pParent = NULL);	// standard constructor
	CBitmap bitmap;

// Dialog Data
	enum { IDD = IDD_RZYGONBITMAPCONVERTER_DIALOG };

	protected:
	virtual void DoDataExchange(CDataExchange* pDX);	// DDX/DDV support


// Implementation
protected:
	HICON m_hIcon;

	// Generated message map functions
	virtual BOOL OnInitDialog();
	afx_msg void OnSysCommand(UINT nID, LPARAM lParam);
	afx_msg void OnPaint();
	afx_msg HCURSOR OnQueryDragIcon();
	DECLARE_MESSAGE_MAP()
public:
	afx_msg void OnBnClickedButtonLoad();
	CStatic m_pict;
	afx_msg void OnBnClickedButton2();
};
