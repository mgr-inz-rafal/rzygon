
// RzygonBitmapConverterDlg.cpp : implementation file
//

#include "stdafx.h"
#include "RzygonBitmapConverter.h"
#include "RzygonBitmapConverterDlg.h"
#include "afxdialogex.h"

#include <fstream>
#include <list>
#include <map>

#ifdef _DEBUG
#define new DEBUG_NEW
#endif


// CAboutDlg dialog used for App About

class CAboutDlg : public CDialogEx
{
public:
	CAboutDlg();

// Dialog Data
	enum { IDD = IDD_ABOUTBOX };

	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support

// Implementation
protected:
	DECLARE_MESSAGE_MAP()
};

CAboutDlg::CAboutDlg() : CDialogEx(CAboutDlg::IDD)
{
}

void CAboutDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialogEx::DoDataExchange(pDX);
}

BEGIN_MESSAGE_MAP(CAboutDlg, CDialogEx)
END_MESSAGE_MAP()


// CRzygonBitmapConverterDlg dialog



CRzygonBitmapConverterDlg::CRzygonBitmapConverterDlg(CWnd* pParent /*=NULL*/)
	: CDialogEx(CRzygonBitmapConverterDlg::IDD, pParent)
{
	m_hIcon = AfxGetApp()->LoadIcon(IDR_MAINFRAME);
}

void CRzygonBitmapConverterDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialogEx::DoDataExchange(pDX);
	DDX_Control(pDX, IDC_BITMAP, m_pict);
}

BEGIN_MESSAGE_MAP(CRzygonBitmapConverterDlg, CDialogEx)
	ON_WM_SYSCOMMAND()
	ON_WM_PAINT()
	ON_WM_QUERYDRAGICON()
	ON_BN_CLICKED(IDC_BUTTON_LOAD, &CRzygonBitmapConverterDlg::OnBnClickedButtonLoad)
	ON_BN_CLICKED(IDC_BUTTON2, &CRzygonBitmapConverterDlg::OnBnClickedButton2)
END_MESSAGE_MAP()


// CRzygonBitmapConverterDlg message handlers

BOOL CRzygonBitmapConverterDlg::OnInitDialog()
{
	CDialogEx::OnInitDialog();

	// Add "About..." menu item to system menu.

	// IDM_ABOUTBOX must be in the system command range.
	ASSERT((IDM_ABOUTBOX & 0xFFF0) == IDM_ABOUTBOX);
	ASSERT(IDM_ABOUTBOX < 0xF000);

	CMenu* pSysMenu = GetSystemMenu(FALSE);
	if (pSysMenu != NULL)
	{
		BOOL bNameValid;
		CString strAboutMenu;
		bNameValid = strAboutMenu.LoadString(IDS_ABOUTBOX);
		ASSERT(bNameValid);
		if (!strAboutMenu.IsEmpty())
		{
			pSysMenu->AppendMenu(MF_SEPARATOR);
			pSysMenu->AppendMenu(MF_STRING, IDM_ABOUTBOX, strAboutMenu);
		}
	}

	// Set the icon for this dialog.  The framework does this automatically
	//  when the application's main window is not a dialog
	SetIcon(m_hIcon, TRUE);			// Set big icon
	SetIcon(m_hIcon, FALSE);		// Set small icon

	// TODO: Add extra initialization here

	return TRUE;  // return TRUE  unless you set the focus to a control
}

void CRzygonBitmapConverterDlg::OnSysCommand(UINT nID, LPARAM lParam)
{
	if ((nID & 0xFFF0) == IDM_ABOUTBOX)
	{
		CAboutDlg dlgAbout;
		dlgAbout.DoModal();
	}
	else
	{
		CDialogEx::OnSysCommand(nID, lParam);
	}
}

// If you add a minimize button to your dialog, you will need the code below
//  to draw the icon.  For MFC applications using the document/view model,
//  this is automatically done for you by the framework.

void CRzygonBitmapConverterDlg::OnPaint()
{
	if (IsIconic())
	{
		CPaintDC dc(this); // device context for painting

		SendMessage(WM_ICONERASEBKGND, reinterpret_cast<WPARAM>(dc.GetSafeHdc()), 0);

		// Center icon in client rectangle
		int cxIcon = GetSystemMetrics(SM_CXICON);
		int cyIcon = GetSystemMetrics(SM_CYICON);
		CRect rect;
		GetClientRect(&rect);
		int x = (rect.Width() - cxIcon + 1) / 2;
		int y = (rect.Height() - cyIcon + 1) / 2;

		// Draw the icon
		dc.DrawIcon(x, y, m_hIcon);
	}
	else
	{
		CDialogEx::OnPaint();
	}
}

// The system calls this function to obtain the cursor to display while the user drags
//  the minimized window.
HCURSOR CRzygonBitmapConverterDlg::OnQueryDragIcon()
{
	return static_cast<HCURSOR>(m_hIcon);
}



void CRzygonBitmapConverterDlg::OnBnClickedButtonLoad()
{
	CFileDialog dlgFile(
		TRUE,
		L"*.bmp",
		L"*.bmp");
	if (IDOK != dlgFile.DoModal())
	{
		return;
	}

	CString filename = dlgFile.GetPathName();
	CImage image;
	image.Load(filename);
	bitmap.Attach(image.Detach());
	
	m_pict.SetBitmap(bitmap);
}

// Returns Pixel color from bitmap
COLORREF GetPixelValueFromBitmap(const int x, const int y, CBitmap& bmp)
{
	// DC for desktop
	CDC dcDesktop;
	dcDesktop.Attach(::GetDC(GetDesktopWindow()));

	// Create a DC compatible with desktop or any other existing window
	CDC dc;
	dc.CreateCompatibleDC(&dcDesktop);

	// Save the DC settings here, so that we can restore it later
	const int nRestorePoint = dc.SaveDC();

	// Select the bitmap into the DC
	dc.SelectObject(&bmp);

	// Now get the pixels value from the DC
	const COLORREF clr = dc.GetPixel(x, y);

	// Restore DC settings
	dc.RestoreDC(nRestorePoint);

	// Return pixel value/color
	return clr;
}// End GetPixelValueFromBitmap

void CRzygonBitmapConverterDlg::OnBnClickedButton2()
{
	CFileDialog dlgFile(
		FALSE,
		L"sra",
		L"pic");
	if (IDOK != dlgFile.DoModal())
	{
		return;
	}

	std::ofstream out(dlgFile.GetPathName(), std::ofstream::binary);
	std::ofstream out1(dlgFile.GetPathName() + CString("down"), std::ofstream::binary);

	std::list<COLORREF> colors;

	for (int y = 0; y < 192; ++y)
	{
		for (int x = 0; x < 320; x+=2)
		{
			COLORREF clr = GetPixelValueFromBitmap(x, y, bitmap);
			colors.push_back(clr);
		}
	}
	colors.sort();
	colors.unique();
	colors.pop_front();
	if (colors.size() != 3)
	{
		AfxMessageBox(L"Incorrect color count");
		return;
	}
	std::map<COLORREF, int> colormap = { { 0, 0 } };
	int counter = 1;
	for (auto col : colors)
	{
		colormap.insert(std::make_pair(col, counter++));
	}

	for (int y = 0; y < 192/2; ++y)
	{
		for (int x = 0; x < 320; x+=8)
		{
			COLORREF clr1 = GetPixelValueFromBitmap(x, y, bitmap);
			COLORREF clr2 = GetPixelValueFromBitmap(x+2, y, bitmap);
			COLORREF clr3 = GetPixelValueFromBitmap(x+4, y, bitmap);
			COLORREF clr4 = GetPixelValueFromBitmap(x+6, y, bitmap);
			unsigned char targetColor = 0xff;
			switch (colormap[clr1])
			{
			case 0:
				targetColor &= 0x3F;
				break;
			case 1:
				targetColor &= 0x7F;
				break;
			case 2:
				targetColor &= 0xBF;
				break;
			case 3:
				targetColor &= 0xFF;
				break;
			}
			switch (colormap[clr2])
			{
			case 0:
				targetColor &= 0xCF;
				break;
			case 1:
				targetColor &= 0xDF;
				break;
			case 2:
				targetColor &= 0xEF;
				break;
			case 3:
				targetColor &= 0xFF;
				break;
			}
			switch (colormap[clr3])
			{
			case 0:
				targetColor &= 0xF3;
				break;
			case 1:
				targetColor &= 0xF7;
				break;
			case 2:
				targetColor &= 0xFB;
				break;
			case 3:
				targetColor &= 0xFF;
				break;
			}
			switch (colormap[clr4])
			{
			case 0:
				targetColor &= 0xFC;
				break;
			case 1:
				targetColor &= 0xFD;
				break;
			case 2:
				targetColor &= 0xFE;
				break;
			case 3:
				targetColor &= 0xFF;
				break;
			}
			out.put(targetColor);
		}
	}

	for (int y = 192/2; y < 192; ++y)
	{
		for (int x = 0; x < 320; x += 8)
		{
			COLORREF clr1 = GetPixelValueFromBitmap(x, y, bitmap);
			COLORREF clr2 = GetPixelValueFromBitmap(x + 2, y, bitmap);
			COLORREF clr3 = GetPixelValueFromBitmap(x + 4, y, bitmap);
			COLORREF clr4 = GetPixelValueFromBitmap(x + 6, y, bitmap);
			unsigned char targetColor = 0xff;
			switch (colormap[clr1])
			{
			case 0:
				targetColor &= 0x3F;
				break;
			case 1:
				targetColor &= 0x7F;
				break;
			case 2:
				targetColor &= 0xBF;
				break;
			case 3:
				targetColor &= 0xFF;
				break;
			}
			switch (colormap[clr2])
			{
			case 0:
				targetColor &= 0xCF;
				break;
			case 1:
				targetColor &= 0xDF;
				break;
			case 2:
				targetColor &= 0xEF;
				break;
			case 3:
				targetColor &= 0xFF;
				break;
			}
			switch (colormap[clr3])
			{
			case 0:
				targetColor &= 0xF3;
				break;
			case 1:
				targetColor &= 0xF7;
				break;
			case 2:
				targetColor &= 0xFB;
				break;
			case 3:
				targetColor &= 0xFF;
				break;
			}
			switch (colormap[clr4])
			{
			case 0:
				targetColor &= 0xFC;
				break;
			case 1:
				targetColor &= 0xFD;
				break;
			case 2:
				targetColor &= 0xFE;
				break;
			case 3:
				targetColor &= 0xFF;
				break;
			}
			out1.put(targetColor);
		}
	}

	// P035.SRA
	// out.put((unsigned char)0xde);
	// out.put((unsigned char)135);
	// out.put((unsigned char)18);

	// P162.SRA
	//out.put((unsigned char)32);
	//out.put((unsigned char)135);
	//out.put((unsigned char)227);

	AfxMessageBox(L"Jórz");
}
