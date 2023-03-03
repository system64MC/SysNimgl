import imgui
import strutils

proc currentSourceDir(): string {.compileTime.} =
  result = currentSourcePath().replace("\\", "/")
  result = result[0 ..< result.rfind("/")]

{.passC: "-I" & currentSourceDir() & "/imgui/private/cimnodes" & " -DIMGUI_DISABLE_OBSOLETE_FUNCTIONS=1".}
when defined(linux):
  {.passL: "-Xlinker -rpath .".}

when not defined(cpp) or defined(cimguiDLL):
  when defined(windows):
    const imgui_dll* = "cimgui.dll"
  elif defined(macosx):
    const imgui_dll* = "cimgui.dylib"
  else:
    const imgui_dll* = "cimgui.so"
  {.passC: "-DCIMGUI_DEFINE_ENUMS_AND_STRUCTS".}
  {.pragma: imnodes_header, header: "cimnodes.h".}
else:
  {.compile("private/cimnodes/cimnodes.cpp", "-I" & currentSourceDir() & "/private/cimnodes/imnodes/dependencies/imgui-1.84.2"),
    compile("private/cimnodes/imnodes/imnodes.cpp", "-I" & currentSourceDir() & "/private/cimnodes/imnodes/dependencies/imgui-1.84.2").}
  {.pragma: imnodes_header, header: currentSourceDir() & "/private/ncimnodes.h".}

type
    ImNodesCol* {.pure, size: int32.sizeof.} = enum
        ImNodesColNodeBackground = 0
        ImNodesColNodeBackgroundHovered
        ImNodesColNodeBackgroundSelected
        ImNodesColNodeOutline
        ImNodesColTitleBar
        ImNodesColTitleBarHovered
        ImNodesColTitleBarSelected
        ImNodesColLink
        ImNodesColLinkHovered
        ImNodesColLinkSelected
        ImNodesColPin
        ImNodesColPinHovered
        ImNodesColBoxSelector
        ImNodesColBoxSelectorOutline
        ImNodesColGridBackground
        ImNodesColGridLine
        ImNodesColMiniMapBackground
        ImNodesColMiniMapBackgroundHovered
        ImNodesColMiniMapOutline
        ImNodesColMiniMapOutlineHovered
        ImNodesColMiniMapNodeBackground
        ImNodesColMiniMapNodeBackgroundHovered
        ImNodesColMiniMapNodeBackgroundSelected
        ImNodesColMiniMapNodeOutline
        ImNodesColMiniMapLink
        ImNodesColMiniMapLinkSelected
        ImNodesColMiniMapCanvas
        ImNodesColMiniMapCanvasOutline
        ImNodesColCOUNT

    ImNodesMinimapLocation* {.pure, size: int32.sizeof.} = enum
        ImNodesMiniMapLocation_BottomLeft
        ImNodesMiniMapLocation_BottomRight
        ImNodesMiniMapLocation_TopLeft
        ImNodesMiniMapLocation_TopRight

    ImNodesStyleVar* {.pure, size: int32.sizeof.} = enum
        ImNodesStyleVarGridSpacing = 0
        ImNodesStyleVarNodeCornerRounding
        ImNodesStyleVarNodePadding
        ImNodesStyleVarNodeBorderThickness
        ImNodesStyleVarLinkThickness
        ImNodesStyleVarLinkLineSegmentsPerLength
        ImNodesStyleVarLinkHoverDistance
        ImNodesStyleVarPinCircleRadius
        ImNodesStyleVarPinQuadSideLength
        ImNodesStyleVarPinTriangleSideLength
        ImNodesStyleVarPinLineThickness
        ImNodesStyleVarPinHoverRadius
        ImNodesStyleVarinOffset
        ImNodesStyleVarMiniMapPadding
        ImNodesStyleVarMiniMapOffset
        ImNodesStyleVarCOUNT

    ImNodesStyleFlags* {.pure, size: int32.sizeof.} = enum
        ImNodesStyleFlags_None = 0
        ImNodesStyleFlags_NodeOutline = 1
        ImNodesStyleFlags_GridLines = (1 shl 2)

    ImNodesPinShape* {.pure, size: int32.sizeof.} = enum
        ImNodesPinShape_Circle
        ImNodesPinShape_CircleFilled
        ImNodesPinShape_Triangle
        ImNodesPinShape_TriangleFilled
        ImNodesPinShape_Quad
        ImNodesPinShape_QuadFilled

    ImNodesAttributeFlags* {.pure, size: int32.sizeof.} = enum
        ImNodesAttributeFlags_None = 0
        ImNodesAttributeFlags_EnableLinkDetachWithDragClick = 1
        ImNodesAttributeFlags_EnableLinkCreationOnSnap = (1 shl 1)

    EmulateThreeButtonMouse* {.importc: "ImNodesIO", imnodes_header.} = object
        modifier* {.importc: "Modifier".}: bool

    LinkDetachWithModifierClick* {.importc: "LinkDetachWithModifierClick", imnodes_header.} = object
        modifier* {.importc: "Modifier".}: bool

    ImNodesIO* {.importc: "ImNodesIO", imnodes_header.} = object
        emulateThreeButtonMouse* {.importc: "EmulateThreeButtonMouse".}: EmulateThreeButtonMouse
        linkDetachWithModifierClick* {.importc: "LinkDetachWithModifierClick".}: LinkDetachWithModifierClick
        altMouseButton* {.importc: "AltMouseButton".}: int32
        autoPanningSpeed* {.importc: "AutoPanningSpeed".}: float32
        
    ImNodesStyle* {.importc: "ImNodesStyle", imnodes_header.} = object
        gridSpacing* {.importc: "GridSpacing".}: float32
        nodeCornerRounding* {.importc: "NodeCornerRounding".}: float32
        nodePadding* {.importc: "NodePadding".}: ImVec2
        nodeBorderThickness* {.importc: "NodeBorderThickness".}: float32
        linkThickness* {.importc: "LinkThickness".}: float32
        linkLineSegmentsPerLength* {.importc: "LinkLineSegmentsPerLength".}: float32
        linkHoverDistance* {.importc: "LinkHoverDistance".}: float32
        pinCircleRadius* {.importc: "PinCircleRadius".}: float32
        µpinQuadSideLength* {.importc: "PinQuadSideLength".}: float32
        pinTriangleSideLength* {.importc: "PinTriangleSideLength".}: float32
        pinLineThickness* {.importc: "PinLineThickness".}: float32
        pinHoverRadius* {.importc: "PinHoverRadius".}: float32
        pinOffset* {.importc: "PinOffset".}: float32
        miniMapPadding* {.importc: "MiniMapPadding".}: ImVec2
        miniMapOffset* {.importc: "MiniMapOffset".}: ImVec2
        flags* {.importc: "Flags".}: ImNodesStyleFlags
        colors* {.importc: "Colors".}: array[ImNodesCol.ImNodesColCOUNT, uint32]

    ImNodesContext* {.importc: "ImNodesContext", imnodes_header.} = object
    ImNodesEditorContext* {.importc: "ImNodesEditorContext", imnodes_header.} = object

    ImNodesMiniMapNodeHoveringCallback* {.importc: "ImNodesMiniMapNodeHoveringCallback", imnodes_header.} = proc(integer: int32, somePointer: pointer)
    ImNodesMiniMapNodeHoveringCallbackUserData* {.importc: "ImNodesMiniMapNodeHoveringCallbackUserData", imnodes_header.} = pointer

     
proc LinkDetachWithModifierClickCreate*(): ptr LinkDetachWithModifierClick {.importc: "EmulateThreeButtonMouse_EmulateThreeButtonMouse".}
proc LinkDetachWithModifierClickDestroy*(self: ptr LinkDetachWithModifierClick) {.importc: "EmulateThreeButtonMouse_destroy".}
proc ImNodesIOCreate*(): ptr ImNodesIO {.importc: "LinkDetachWithModifierClick_LinkDetachWithModifierClick".}
proc ImNodesIODestroy*(self: ptr ImNodesIO) {.importc: "LinkDetachWithModifierClick_destroy".}
proc ImNodesStyleCreate*(): ptr ImNodesStyle {.importc: "ImNodesIO_ImNodesIO".}
proc ImNodesStyleDestroy*(self: ptr ImNodesStyle) {.importc: "ImNodesIO_destroy".}
proc imnodesSetImGuiContext*(ctx: ptr ImGuiContext) {.importc: "ImNodesStyle_ImNodesStyle".}
proc imnodesCreateContext*(): ptr ImNodesContext {.importc: "ImNodesStyle_destroy".}
proc imnodesDestroyContext*(ctx: ptr ImNodesContext) {.importc: "imnodes_SetImGuiContext".}
proc imnodesGetCurrentContext*(): ptr ImNodesContext {.importc: "imnodes_CreateContext".}
proc imnodesSetCurrentContext*(ctx: ptr ImNodesContext) {.importc: "imnodes_DestroyContext".}
proc imnodesEditorContextCreate*(): ptr ImNodesEditorContext {.importc: "imnodes_GetCurrentContext".}
proc imnodesEditorContextFree*(noname1: ptr ImNodesEditorContext) {.importc: "imnodes_SetCurrentContext".}
proc imnodesEditorContextSet*(noname1: ptr ImNodesEditorContext) {.importc: "imnodes_EditorContextCreate".}
proc imnodesEditorContextGetPanning*(pOut: ptr ImVec2) {.importc: "imnodes_EditorContextFree".}
proc imnodesEditorContextResetPanning*(pos: ImVec2) {.importc: "imnodes_EditorContextSet".}
proc imnodesEditorContextMoveToNode*(node_id: cint) {.importc: "imnodes_EditorContextGetPanning".}
proc imnodesGetIO*(): ptr ImNodesIO {.importc: "imnodes_EditorContextResetPanning".}
proc imnodesGetStyle*(): ptr ImNodesStyle {.importc: "imnodes_EditorContextMoveToNode".}
proc imnodesStyleColorsDark*() {.importc: "imnodes_GetIO".}
proc imnodesStyleColorsClassic*() {.importc: "imnodes_GetStyle".}
proc imnodesStyleColorsLight*() {.importc: "imnodes_StyleColorsDark".}
proc imnodesBeginNodeEditor*() {.importc: "imnodes_StyleColorsClassic".}
proc imnodesEndNodeEditor*() {.importc: "imnodes_StyleColorsLight".}
proc imnodesMiniMap*(minimap_size_fraction: cfloat, location: ImNodesMiniMapLocation, node_hovering_callback: ImNodesMiniMapNodeHoveringCallback, node_hovering_callback_data: ImNodesMiniMapNodeHoveringCallbackUserData) {.importc: "imnodes_BeginNodeEditor".}
proc imnodesPushColorStyle*(item: ImNodesCol; color: cuint) {.importc: "imnodes_EndNodeEditor".}
proc imnodesPopColorStyle*() {.importc: "imnodes_MiniMap".}
proc imnodesPushStyleVar_Float*(style_item: ImNodesStyleVar; value: cfloat) {.importc: "imnodes_PushColorStyle".}
proc imnodesPushStyleVar_Vec2*(style_item: ImNodesStyleVar; value: ImVec2) {.importc: "imnodes_PopColorStyle".}
proc imnodesPopStyleVar*(count: cint) {.importc: "imnodes_PushStyleVar_Float".}
proc imnodesBeginNode*(id: cint) {.importc: "imnodes_PushStyleVar_Vec2".}
proc imnodesEndNode*() {.importc: "imnodes_PopStyleVar".}
proc imnodesGetNodeDimensions*(pOut: ptr ImVec2; id: cint) {.importc: "imnodes_BeginNode".}
proc imnodesBeginNodeTitleBar*() {.importc: "imnodes_EndNode".}
proc imnodesEndNodeTitleBar*() {.importc: "imnodes_GetNodeDimensions".}
proc imnodesBeginInputAttribute*(id: cint; shape: ImNodesPinShape) {.importc: "imnodes_BeginNodeTitleBar".}
proc imnodesEndInputAttribute*() {.importc: "imnodes_EndNodeTitleBar".}
proc imnodesBeginOutputAttribute*(id: cint; shape: ImNodesPinShape) {.importc: "imnodes_BeginInputAttribute".}
proc imnodesEndOutputAttribute*() {.importc: "imnodes_EndInputAttribute".}
proc imnodesBeginStaticAttribute*(id: cint) {.importc: "imnodes_BeginOutputAttribute".}
proc imnodesEndStaticAttribute*() {.importc: "imnodes_EndOutputAttribute".}
proc imnodesPushAttributeFlag*(flag: ImNodesAttributeFlags) {.importc: "imnodes_BeginStaticAttribute".}
proc imnodesPopAttributeFlag*() {.importc: "imnodes_EndStaticAttribute".}
proc imnodesLink*(id: cint; start_attribute_id: cint; end_attribute_id: cint) {.importc: "imnodes_PushAttributeFlag".}
proc imnodesSetNodeDraggable*(node_id: cint; draggable: bool) {.importc: "imnodes_PopAttributeFlag".}
proc imnodesSetNodeScreenSpacePos*(node_id: cint; screen_space_pos: ImVec2) {.importc: "imnodes_Link".}
proc imnodesSetNodeEditorSpacePos*(node_id: cint; editor_space_pos: ImVec2) {.importc: "imnodes_SetNodeDraggable".}
proc imnodesSetNodeGridSpacePos*(node_id: cint; grid_pos: ImVec2) {.importc: "imnodes_SetNodeScreenSpacePos".}
proc imnodesGetNodeScreenSpacePos*(pOut: ptr ImVec2; node_id: cint) {.importc: "imnodes_SetNodeEditorSpacePos".}
proc imnodesGetNodeEditorSpacePos*(pOut: ptr ImVec2; node_id: cint) {.importc: "imnodes_SetNodeGridSpacePos".}
proc imnodesGetNodeGridSpacePos*(pOut: ptr ImVec2; node_id: cint) {.importc: "imnodes_GetNodeScreenSpacePos".}
proc imnodesIsEditorHovered*(): bool {.importc: "imnodes_GetNodeEditorSpacePos".}
proc imnodesIsNodeHovered*(node_id: ptr cint): bool {.importc: "imnodes_GetNodeGridSpacePos".}
proc imnodesIsLinkHovered*(link_id: ptr cint): bool {.importc: "imnodes_IsEditorHovered".}
proc imnodesIsPinHovered*(attribute_id: ptr cint): bool {.importc: "imnodes_IsNodeHovered".}
proc imnodesNumSelectedNodes*(): cint {.importc: "imnodes_IsLinkHovered".}
proc imnodesNumSelectedLinks*(): cint {.importc: "imnodes_IsPinHovered".}
proc imnodesGetSelectedNodes*(node_ids: ptr cint) {.importc: "imnodes_NumSelectedNodes".}
proc imnodesGetSelectedLinks*(link_ids: ptr cint) {.importc: "imnodes_NumSelectedLinks".}
proc imnodesClearNodeSelection_Nil*() {.importc: "imnodes_GetSelectedNodes".}
proc imnodesClearLinkSelection_Nil*() {.importc: "imnodes_GetSelectedLinks".}
proc imnodesSelectNode*(node_id: cint) {.importc: "imnodes_ClearNodeSelection_Nil".}
proc imnodesClearNodeSelection_Int*(node_id: cint) {.importc: "imnodes_ClearLinkSelection_Nil".}
proc imnodesIsNodeSelected*(node_id: cint): bool {.importc: "imnodes_SelectNode".}
proc imnodesSelectLink*(link_id: cint) {.importc: "imnodes_ClearNodeSelection_Int".}
proc imnodesClearLinkSelection_Int*(link_id: cint) {.importc: "imnodes_IsNodeSelected".}
proc imnodesIsLinkSelected*(link_id: cint): bool {.importc: "imnodes_SelectLink".}
proc imnodesIsAttributeActive*(): bool {.importc: "imnodes_ClearLinkSelection_Int".}
proc imnodesIsAnyAttributeActive*(attribute_id: ptr cint): bool {.importc: "imnodes_IsLinkSelected".}
proc imnodesIsLinkStarted*(started_at_attribute_id: ptr cint): bool {.importc: "imnodes_IsAttributeActive".}
proc imnodesIsLinkDropped*(started_at_attribute_id: ptr cint, including_detached_links: bool): bool {.importc: "imnodes_IsAnyAttributeActive".}
proc imnodesIsLinkCreated_BoolPtr*(started_at_attribute_id: ptr cint, ended_at_attribute_id: ptr cint, created_from_snap: ptr bool): bool {.importc: "imnodes_IsLinkStarted".}
proc imnodesIsLinkCreated_IntPtr*(started_at_node_id: ptr cint, started_at_attribute_id: ptr cint, ended_at_node_id: ptr cint, ended_at_attribute_id: ptr cint, created_from_snap: ptr bool): bool {.importc: "imnodes_IsLinkDropped".}
proc imnodesIsLinkDestroyed*(link_id: ptr cint): bool {.importc: "imnodes_IsLinkCreated_BoolPtr".}
proc imnodesSaveCurrentEditorStateToIniString*(data_size: ptr csize_t): cstring {.importc: "imnodes_IsLinkCreated_IntPtr".}
proc imnodesSaveEditorStateToIniString*(editor: ptr ImNodesEditorContext, data_size: ptr csize_t): cstring {.importc: "imnodes_IsLinkDestroyed".}
proc imnodesLoadCurrentEditorStateFromIniString*(data: cstring; data_size: csize_t) {.importc: "imnodes_SaveCurrentEditorStateToIniString".}
proc imnodesLoadEditorStateFromIniString*(editor: ptr ImNodesEditorContext, data: cstring; data_size: csize_t) {.importc: "imnodes_SaveEditorStateToIniString".}
proc imnodesSaveCurrentEditorStateToIniFile*(file_name: cstring) {.importc: "imnodes_LoadCurrentEditorStateFromIniString".}
proc imnodesSaveEditorStateToIniFile*(editor: ptr ImNodesEditorContext, file_name: cstring) {.importc: "imnodes_LoadEditorStateFromIniString".}
proc imnodesLoadCurrentEditorStateFromIniFile*(file_name: cstring) {.importc: "imnodes_SaveCurrentEditorStateToIniFile".}
proc imnodesLoadEditorStateFromIniFile*(editor: ptr ImNodesEditorContext, file_name: cstring) {.importc: "imnodes_SaveEditorStateToIniFile".}

proc getIOKeyCtrlPtr*(): ptr bool {.importc: "imnodes_SaveEditorStateToIniFile".}

        
