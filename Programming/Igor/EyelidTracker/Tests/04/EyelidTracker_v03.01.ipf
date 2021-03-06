//=============================================================
// Name: EyelicTracker
// Authors: Payne Chang, Rick Gray, Randy Chitwood, and Dr. Johnston's Lab @2012

//=============================================================
// Use modern global access method.
#pragma rtGlobals = 1

//=============================================================
// EyelidTracker()
Macro EyelidTracker()

	//================================
	// Notification
	Print "=== EyelicTracker ==="

	//================================
	// Global flags
	Variable /G flagThresholding = 0
	
	//================================
	// Global variables	
	
	// Video
	Variable /G numFrames = 350
	Variable /G framePerSecond = 350
	Variable /G frameIndex = 0
	
	// ROI
	Variable /G roiLeft, roiRight , roiTop, roiBottom, roiWidth, roiHeight
	
	// Image processing
	Variable /G threshold = 128
	Variable /G areaCount
	Variable /G pixelCount
	
	//================================
	// Create control panel	
	DoWindow /K ControlPanel
	execute "ControlPanel()"
	
End	Macro

//=============================================================
// Control Panel
Window ControlPanel() : Panel

	//=================================
	// Suppress macro output
	Silent 1		
	
	//=================================
	// Parameters of control panel
	Variable pnlX = 700
	Variable pnlY = 10
	Variable pnlWidth = 300
	Variable pnlHeight = 350
	
	NewPanel /W=(pnlX, pnlY, pnlX + pnlWidth, pnlY + pnlHeight)
	SetDrawLayer UserBack
	SetDrawEnv fillfgc = (65535 * 0.6, 65535 * 1, 65535 * 0.6)
	DrawRect 2, 2, pnlWidth - 4, pnlHeight - 4
	
	//==================================
	// Parameters of widgets
	Variable itemWidth = 150
	Variable itemHeight = 20
	Variable itemX = 10
	Variable itemY = 10
	Variable itemYGap = 5
	
	//==================================
	// Open video file
	Button btnOpenVideoFile, pos={itemX, itemY}, size={itemWidth, itemHeight}
	Button btnOpenVideoFile, title="Open Video File", proc=OpenVideoFileFunc

	// Select ROI
	itemY += (itemHeight + itemYGap)
	Button btnSelectROI, pos={itemX, itemY}, size={itemWidth, itemHeight}
	Button btnSelectROI, title="Select ROI", proc=SelectROIFunc

	// Analyze Video
	itemY += (itemHeight + itemYGap)
	Button btnAnalyzeVideo, pos={itemX, itemY}, size={itemWidth, itemHeight}
	Button btnAnalyzeVideo, title="Analyze Video", proc=AnalyzeVideoFunc

	// Exit
	itemY += (itemHeight + itemYGap)
	Button btnExit, pos={itemX, itemY}, size={itemWidth, itemHeight}
	Button btnExit, title="Exit", proc=ExitFunc
	
	//=====================================
	itemY += (itemHeight + itemYGap * 2)
	DrawLine 2, itemY, pnlWidth - 3, itemY

	// SetVariable for Number of Frames
	itemY += (itemYGap * 2)
	SetVariable svbNumFrames, pos={itemX, itemY}, size={itemWidth, itemHeight}
	SetVariable svbNumFrames, title="Number of Frames", value=numFrames

	// SetVariable for Frames per Second
	itemY += (itemHeight + itemYGap)
	SetVariable svbFPS, pos={itemX, itemY}, size={itemWidth, itemHeight}
	SetVariable svbFPS, title="Frames per Second", value=framePerSecond

	// SetVariable for Frame Index
	itemY += (itemHeight + itemYGap)
	SetVariable svbFrameIndex, pos={itemX, itemY}, size={itemWidth, itemHeight}
	SetVariable svbFrameIndex, title="Frame Index", proc=ImageProcessingFuncSVB
	SetVariable svbFrameIndex, value=frameIndex

	// Button: Go to Beginning
	itemY += (itemHeight + itemYGap)
	Button btnGoToBeginning, pos={itemX, itemY}, size={itemWidth, itemHeight}
	Button btnGoToBeginning, title="Go to Beginning", proc=ImageProcessingFuncBTN1

	//=====================================
	itemY += (itemHeight + itemYGap * 2)
	DrawLine 2, itemY, pnlWidth - 3, itemY

	// Check Box for Thresholding
	itemY += (itemYGap * 2)
	CheckBox ckbThresholding, pos={itemX, itemY}, size={itemWidth, itemHeight}
	CheckBox ckbThresholding, title="Thresholding", proc=ImageProcessingFuncCKB
	CheckBox ckbThresholding, variable=flagThresholding

	// Slider for Threshold
	itemY += (itemHeight + itemYGap)
	Slider sldThreshold, pos={itemX, itemY}, size={280, itemHeight}
	Slider sldThreshold, title="Threshold", proc=ImageProcessingFuncSLD
	Slider sldThreshold, limits={0, 255, 1}, vert=0, ticks= 25, variable=threshold

	// SetVariable for Threshold
	itemY += (itemHeight + itemYGap) + 30
	SetVariable svbThreshold, pos={itemX, itemY}, size={itemWidth, itemHeight}
	SetVariable svbThreshold, title="Threshold", proc=ImageProcessingFuncSVB
	SetVariable svbThreshold, value=threshold

End

//=============================================================
// Function for Open Video File button
Function OpenVideoFileFunc(ctrlName) : ButtonControl
	String ctrlName
	
	//=============================================
	// Notification
	Print "=== Video Information from File ==="
	
	//=============================================
	// Kills the old QuickTime window
	PlayMovieAction /Z kill
	
	//=============================================
	// Open one video file
	PlayMovie /W=(10, 500, 110, 600)
	
	//=============================================
	// Get basic information
	// The information in the video file is not accurate.
	// Manual input is required.
	
	// Start time
	PlayMovieAction stop, gotoBeginning, getTime
	Variable videoTimeStart = V_value
	
	// Video delta time
	PlayMovieAction step = 1, getTime
	Variable videoDeltaTime = V_value - videoTimeStart
	Print "Delta Time =", videoDeltaTime * 1e3, "(ms)"
	Print "Acquisition Rate =", 1/videoDeltaTime, "(fps)"
	
	// End time
	PlayMovieAction gotoEnd, getTime
	Variable videoTimeEnd = V_value
	
	// Calculated Number of frames
	// Igor/QuickTime does not check out of range error.
	Variable videoNumFrames = videoTimeEnd / videoDeltaTime + 1
	Print "Number of Frames =", videoNumFrames	
	
	//=============================================
	// Extract the first frame
	// The current frame is extracted into an 8-bit RGB image wave named M_MovieFrame
	PlayMovieAction gotoBeginning, extract
	
	// Convert the image into 8-bit grayscale image wave (M_RGB2Gray)
	ImageTransform rgb2gray M_MovieFrame
	
	//=============================================
	// Create grayscale window
	DoWindow /K GrayscaleWindow
	NewImage /N=GrayscaleWindow M_RGB2Gray
	
End

//=============================================================
// Select ROI from the marquee in GrayscaleWindow
Function SelectROIFunc(ctrlName) : ButtonControl
	String ctrlName
	
	// Notification
	Print "=== Select ROI ==="
	
	// Extract coordinates of the marquee
	GetMarquee /W=GrayscaleWindow left, top
	Printf "Marquee (left, right, top, bottom) = (%g, %g, %g, %g)\r", V_left, V_right, V_top, V_bottom
	
	// Global ROI variables
	NVAR roiLeft = root:roiLeft; roiLeft = ceil(V_left)
	NVAR roiRight = root:roiRight; roiRight = floor(V_right)
	NVAR roiTop = root:roiTop; roiTop = ceil(V_top)
	NVAR roiBottom = root:roiBottom; roiBottom= floor(V_bottom)
	NVAR roiWidth = root:roiWidth; roiWidth = roiRight - roiLeft + 1
	NVAR roiHeight = root:roiHeight; roiHeight = roiBottom - roiTop + 1
	
	Printf "ROI (left, right, top, bottom) = (%d, %d, %d, %d)\r", roiLeft, roiRight, roiTop, roiBottom
	Printf "ROI (width, height) = (%d, %d)\r", roiWidth, roiHeight
	
	// Create wave roiImage
	Duplicate /O /R=(roiLeft, roiRight)(roiTop, roiBottom) M_RGB2Gray, roiImage
	
	// Create ROIWindow and display roiImage
	DoWindow /K ROIWindow
	NewImage /N=ROIWindow roiImage
	
	// Create wave to store line scan data
	Make /O /N=(roiHeight) wLineScan = 0
	
	// Create LineScanWindow
	DoWindow /K LineScanWindow
	Display /N=LineScanWindow /W=(10, 300, 210, 450) wLineScan
	Label /W=LineScanWindow left "Eyelid Position Index"
	Label /W=LineScanWindow bottom "Y Coordinate (Pixel)"
	SetAxis /W=LineScanWindow left -0.01, 1
	
	// Process image
	ImageProcessingFunc()
	
End

//=============================================================
//  AnalyzeVideoFunc
Function AnalyzeVideoFunc(ctrlName) : ButtonControl
	String ctrlName
	
	//=============================================
	// Notification
	Print "=== Analyze Video ==="
	
	//=============================================
	// Global variable
	NVAR numFrames = root:numFrames
	NVAR frameIndex = root:frameIndex
	NVAR numVideos = root:numVideos
	
	NVAR areaCount = root:areaCount
	NVAR pixelCount = root:pixelCount
	
	Make /N=(numFrames) /O wAreaCount=0
	Make /N=(numFrames) /O wPixelCount=0

	//=============================================
	// Create TraceWindow
	DoWindow /K TraceWindow
	Display /N=TraceWindow /W=(450, 400, 750, 600) wAreaCount, wPixelCount
	ModifyGraph rgb(wPixelCount)=(0, 0, 65535)
	Label /W=TraceWindow left "Eyelid Position Index"
	Label /W=TraceWindow bottom "Frame Index"
	SetAxis /W=TraceWindow left -0.01, 1
	
	//=============================================
	// Get baseline
	frameIndex = 0
	ImageProcessingFunc()
	
	Variable areaCountBaseline = areaCount
	Variable pixelCountBaseline = pixelCount
	
	//=============================================
	// Go through each frame
	for(frameIndex = 0; frameIndex < numFrames; frameIndex += 1)
	
		// Image processing
		ImageProcessingFunc()
		
		// Save eyelid position index
		wAreaCount[frameIndex] =  (areaCountBaseline - areaCount) / areaCountBaseline
		wPixelCount[frameIndex] =  (pixelCountBaseline - pixelCount) / pixelCountBaseline
	
		// Update graphs
		DoUpdate
		
	endfor
	
	//=============================================
	frameIndex = numFrames - 1
	
End

//=============================================================
// Exit function
Function ExitFunc(ctrlName) : ButtonControl
	String ctrlName
		
	// Kill control panel
	DoWindow /K ControlPanel
	
	// Kill QuickTime window
	PlayMovieAction /Z kill

	// Kill GrayscaleWindow
	DoWindow /K GrayscaleWindow

	// Kill AnalysisWindow
	DoWindow /K ROIWindow

	// Kill ResultWindow
	DoWindow /K ResultWindow
	
	// Kill TraceWindow
	DoWindow /K TraceWindow

	// Kill LineScanWindow
	DoWindow /K LineScanWindow

End

//=============================================================
// Image Processing Function

// CheckBox
Function ImageProcessingFuncCKB(ctrlName, checked) : CheckBoxControl
	String ctrlName
	Variable checked
	
	ImageProcessingFunc()
	
End

// Slider
Function ImageProcessingFuncSLD(name, value, event) :SliderControl
	String name
	Variable value
	Variable event
	
	ImageProcessingFunc()
	
End

// SetVariable
Function ImageProcessingFuncSVB(ctrlName, varNum, varStr, varName) :SetVariableControl
	String ctrlName
	Variable varNum
	String varStr
	String varName
	
	ImageProcessingFunc()
	
End

// Button
Function ImageProcessingFuncBTN1(ctrlName) : ButtonControl
	String ctrlName
	
	NVAR frameIndex
	frameIndex = 0
	
	ImageProcessingFunc()
	
End

//==========================
// Image Processing Function
Function ImageProcessingFunc()
	
	//==========================
	// Global variables
	NVAR frameIndex = root:frameIndex
	NVAR numFrames = root:numFrames
	NVAR roiWidth = root:roiWidth
	NVAR roiHeight = root:roiHeight
	NVAR roiLeft = root:roiLeft
	NVAR roiTop = root:roiTop
	NVAR threshold = root:threshold
	NVAR flagThresholding = root:flagThresholding
	
	WAVE roiImage, wLineScan
	WAVE M_MovieFrame, M_RGB2Gray
	
	//==========================
	// Local variables
	Variable x, y, value
	
	//==========================
	// Extract one frame
	if(frameIndex < 0)
		frameIndex = 0
	endif
	
	if(frameIndex >= numFrames)
		frameIndex = numFrames - 1
	endif
	
	PlayMovieAction frame = frameIndex, extract

	//==========================
	// Convert the image into grayscale image wave
	ImageTransform rgb2gray M_MovieFrame

	//==========================
	// Go through each pixel
	NVAR areaCount = root:areaCount
	NVAR pixelCount = root:pixelCount
	Variable pixelCountTmp
	
	// Reset area count
	areaCount = 0
	pixelCount = 0
	
	for(y = 0; y < roiHeight; y += 1)
	
		// Reset pixel count
		pixelCountTmp = 0
		
		// Go through each pixel along one horizontal line
		for(x = 0; x < roiWidth; x += 1)
		
			// Extract pixel value
			value = M_RGB2Gray[roiLeft + x][roiTop + y]
			
			// Thresholding
			if(flagThresholding)
				if(value > threshold)
					roiImage[x][y] = 255
				else
					roiImage[x][y] = 0
					
					// Count
					areaCount += 1
				endif
			else
				roiImage[x][y] = value
				
				// Count
				areaCount += (255 - value)
			endif
			
			// Integration along one horizontal line
			pixelCountTmp += roiImage[x][y]
			
		endfor
		
		// Save integration data
		wLineScan[y] = pixelCountTmp / (255 * roiWidth)
		
		if(wLineScan[y] < 0.5)
			pixelCount += 1
		endif
		
	endfor
	
End

//=============================================//
// End of procedure