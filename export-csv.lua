-- Check if the user selected layer is not tilemap
local layer = app.activeLayer
if not layer.isTilemap then return app.alert("Layer is not tilemap") end

-- Open Dialog
-- ********************************************************
local data = 
  Dialog("Export Tilemap as .csv"):file{id="path", label="Path:", filename="", open=false, filetypes={"csv"}, save=true, focus=true}
  :label{label="Layer:", text=layer.name}
  :label{label="Frame:", text=app.frame.frameNumber}
  :separator{}
  :button{id="ok",text="&OK",focus=true}
  :button{text="&Cancel" }
  :show().data

-- Check if the user clicked OK or Cancel
if not data.ok then return end

-- Check if the user selected a path
if (#data.path <= 0) then return app.alert("No path selected") end

-- Start Export
-- ********************************************************
mapFile = io.open(data.path, "w")

-- Get Cel in Current Frame
local cel = layer:cel(app.frame.frameNumber)

-- Write to File
local count = 0
for tileNo_it in cel.image:pixels() do
  mapFile:write(tileNo_it())
  count = count + 1

  -- Add Comma or Next Line
  if count % cel.image.width == 0 then
    if count ~= 0 then
      mapFile:write("\n")
    end
  else
    mapFile:write(",")
  end
end

mapFile:close()
