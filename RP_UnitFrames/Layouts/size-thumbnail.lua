  -- frame layout functions ---------------------------------------------------------------------------------------------------------------------------------
  local function hgap(n)    return Config.get("GAPSIZE") * (n or 1);                 end ;
  local function vgap(n)    return Config.get("GAPSIZE") * (n or 1) * -1;            end ;
  local function fontSize() local _, size, _ = GameFontNormal:GetFont(); return size end ;

  local function getPanelHeight(panel, layout)
    local height;

    if panel == 'name'                                    then height = fontSize() + 4;
    elseif panel == 'portrait'                                then height = Config.get("PORTWIDTH") * 1.5;
    elseif panel == 'icon1'     and layout  == "THUMBNAIL"    then height = Config.get("ICONWIDTH");
    end;
  end;

  local function getPanelWidth(panel, layout)
    local width;

    if panel == 'name'       and layout  == "THUMBNAIL"  then width = math.max(
                                                                                  -- formula #1
                                                                                  Config.get("PORTWIDTH") * 2/3 - hgap(2/3),
                                                                                  -- formula #2
                                                                                  Config.get("ICONWIDTH") - hgap(2/3)
                                                                                  );
    elseif panel == 'portrait'   and layout  == "THUMBNAIL"  then width = Config.get("PORTWIDTH") * 2/3;
    elseif panel == 'icon1'      and layout  == "THUMBNAIL"  then width = Config.get("ICONWIDTH");
    end;
  local function getFrameSize(layout)
    elseif layout == "THUMBNAIL" -- -------------------------------------------------------------------------------------------------------------
    then   width  =  math.max(
                     -- formula #1
                     border + getPanelWidth('portrait', layout)  + border,
                     -- formula #2
                     border + getPanelWidth('icon1', layout) + border)
           height =  math.max( -- formula #1
                     border + getPanelHeight('icon1', layout) + getPanelHeight('name', layout) + border,
                     -- Formula #2
                     border + getPanelHeight('portrait', layout) + border);

end);
