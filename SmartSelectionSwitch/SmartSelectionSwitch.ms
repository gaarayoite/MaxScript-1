--Start Struct--------------------------------------------------------------------------
struct AvaibleMods
(
    -- 1 - mod type, 2 - set ignorebackfacing on\off
    private Mods = #(  
                    #(Editable_Poly,false),
                    #(Edit_Poly,false),
                    #(Editable_mesh,false),
                    #(Unwrap_UVW,false),
                    #(VertexPaint,false)
                    ),

    public function GetMods = 
    (
        return  deepCopy Mods
    )
)
--end struct
--------------------------------------------------------------------------



--Start Struct--------------------------------------------------------------------------
struct SelectionStyles 
(
    private SelStyle = #("Rectangle","Circle","Fance","Lasso","Paint"),

    public function GetSelStyles = 
    (
        return deepcopy SelStyle
    )

)
--end struct
--------------------------------------------------------------------------



--Start Struct--------------------------------------------------------------------------
struct SelTool
(
--------------Members-------------------------------
    public SelectionType, --type of the selection style
    public SelBrushSize, -- brush size for paint selection
    public ModsIgnoreBF, -- arr of mods and they flags for  wich tells on/off ignore backfacing when specific modifier is selected
--------------End Members-----------------------------
    
----------Functions
--------------------------------------------------------------------------------------------------------------------------------------------------------------

    public function SwitchSelStyle =
    (
        
        case SelectionType of 
        (
            "Rectangle":  (actionMan.executeAction 0 "59232") -- Selection: Rectangular Selection Region
            "Circle":(actionMan.executeAction 0 "59233") -- Selection: Circular Selection Region
            "Fance": (actionMan.executeAction 0 "59234") -- Selection: Fence Selection Region
            "Lasso": (actionMan.executeAction 0 "59235") -- Selection: Lasso Selection Region
            "Paint": (actionMan.executeAction 0 "59236") -- Selection: Paint Selection Region
            default: (actionMan.executeAction 0 "59232") -- Selection: Rectangular Selection Region
        )
        if SelectionType == "Paint" do (maxops.paintSelBrushSize = SelBrushSize)   
    ),
--end func	
--------------------------------------------------------------------------------------------------------------------------------------------------------------

    on create do 
    (
        SelectionType = "Rectangle"
        SelBrushSize = 5
        local avmod = AvaibleMods()
        ModsIgnoreBF = avmod.GetMods()
    )
--end func	
--------------------------------------------------------------------------------------------------------------------------------------------------------------
)
--end struct
--------------------------------------------------------------------------

------------Vars----------------------
global TheSmartSelSwitch
------------Vars----------------------
--Start Struct--------------------------------------------------------------------------
struct SmartSelectionTool
(
--------------Members-------------------------------
    private ToolsArr = #(), -- 1- curr tool, 2- tool A, 3 - tool B
    private UseModsArr = #(),-- use modifier
    private CBRegs = false, -- callback is regisrated, bool
    private IBFPropagate = true, -- automaticly on\off ignore backfacing
    private UIData = #(), -- dropdown lists data 
    private IniKeys = #("Editable_Poly","Edit_Poly","Editable_Mesh","UnwrapUVW", "VertexPaint"),
    private ConfigPath = getFilenamePath (getSourceFileName()) + "\\SmartSelSwitchConfig.ini",
---------------End Members---------------------------

----------Functions
--------------------------------------------------------------------------------------------------------------------------------------------------------------
    private function StartIgnoreBF =
    (
        
        local currMod = modPanel.getCurrentObject()

        for i=1 to (ToolsArr[1].ModsIgnoreBF.count) do 
        ( 
            if UseModsArr[i] == true do --check modifier using
            (
                if ClassOf currMod == (ToolsArr[1].ModsIgnoreBF[i][1]) do 
                (
                    local obj = ToolsArr[1].ModsIgnoreBF[i][1]

                    case obj of 
                    (
                        Editable_Poly:  (currMod.ignoreBackfacing = ToolsArr[1].ModsIgnoreBF[i][2]) 
                        Edit_Poly:      (currMod.ignoreBackfacing = ToolsArr[1].ModsIgnoreBF[i][2]) 
                        Editable_mesh:  (meshop.setUIParam currMod #IgBack (ToolsArr[1].ModsIgnoreBF[i][2])) 
                        Unwrap_UVW:     (currMod.setIgnoreBackFaceCull (ToolsArr[1].ModsIgnoreBF[i][2]))
                        VertexPaint:    (currMod.ignoreBackfacing = ToolsArr[1].ModsIgnoreBF[i][2])
                    ) 
                )
            )
        )
            
    ),
--end func	
--------------------------------------------------------------------------------------------------------------------------------------------------------------

     public function SwitchTool = 
    (
        if toolmode.commandmode == #select then  -- check selection tool
        (
            if ToolsArr[1] == ToolsArr[2] then 
            (
                ToolsArr[1] = ToolsArr[3]
            )
            else 
                (
                    if ToolsArr[1] == ToolsArr[3] do 
                    (
                        ToolsArr[1] = ToolsArr[2]   
                    )
                )
                ToolsArr[1].SwitchSelStyle()

                StartIgnoreBF() -- ignore backfacing
        )
        else 
            (
                toolmode.commandmode  = #select -- activate selection tool
            )
                if CBRegs == false and IBFPropagate == true do 
                (
                    try 
                        (   callbacks.removeScripts id:#theStartIgnoreBF
                            --callbacks.addScript #modPanelSelChanged "TheSmartSelSwitch.StartIgnoreBF()" id:#theStartIgnoreBF -- activate callback
                            CBRegs = true 
                        )
                        catch()
                )
    ),
 --end func	
--------------------------------------------------------------------------------------------------------------------------------------------------------------
    
    public function ForceIBFStop = 
    (
      try 
        (
            callbacks.removeScripts id:#theStartIgnoreBF
            CBRegs = false 
         )
         catch()
  
    ),
--end func	
--------------------------------------------------------------------------------------------------------------------------------------------------------------

    public function GetUIData = 
    (
        return deepCopy UiData
    ),
--end func	
--------------------------------------------------------------------------------------------------------------------------------------------------------------

    public function ApplyDefaultParams = 
    (
        UseModsArr[4] = false --unwrapUVW off
        UseModsArr[5] = false -- VertexPaint off
        IBFPropagate = true 

        for j =2 to 3 do 
        (
            local flag = false 
            if j == 3 do (flag = true ) 

            for i=1 to  (ToolsArr[1].ModsIgnoreBF.count) do 
                (
                    
                    ToolsArr[j].ModsIgnoreBF[i][2] = flag  --set IBF flag for specific modifier
                )
        )

        ForceIBFStop()
		ToolsArr[2].SelectionType = UiData[1]
		ToolsArr[3].SelectionType = UiData[5]

        ToolsArr[1] = ToolsArr[2] -- set tool A as active

    ),
--end func	
--------------------------------------------------------------------------------------------------------------------------------------------------------------

    on create do 
    (
        for i =1 to 3 do 
        (  append ToolsArr (SelTool())	)
		
        for i=1 to (ToolsArr[1].ModsIgnoreBF.count) do 
        (  UseModsArr[i] = true )

        local larr = SelectionStyles()
        UiData = larr.GetSelStyles() 
        ApplyDefaultParams()

        if doesFileExist ConfigPath == true do 
        (

        )

    )
--end func	
--------------------------------------------------------------------------------------------------------------------------------------------------------------
)
--end struct
--------------------------------------------------------------------------

TheSmartSelSwitch = SmartSelectionTool() -- make instance of struct
--end script