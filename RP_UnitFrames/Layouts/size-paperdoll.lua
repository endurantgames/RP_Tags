
  local function getPanelHeight(panel, layout)
    local height;

    elseif panel == 'name'                                    then height = fontSize() + 4;

    elseif panel == 'info'                                    then height = fontSize() + 2;

    elseif panel == 'portrait'  and layout  == "PAPERDOLL"    then height = Config.get("PORTWIDTH") * 2;

    elseif panel == 'details'                                 then height = Config.get("DETAILHEIGHT");

    elseif panel == 'statusBar'                                then height = Config.get("STATUSHEIGHT");

    elseif panel == 'icon1'     and layout  == "PAPERDOLL"    then height = Config.get("ICONWIDTH");
    elseif panel == 'icon2'     and layout  == "PAPERDOLL"    then height = Config.get("ICONWIDTH");
    elseif panel == 'icon3'     and layout  == "PAPERDOLL"    then height = Config.get("ICONWIDTH");
    elseif panel == 'icon4'     and layout  == "PAPERDOLL"    then height = Config.get("ICONWIDTH");
    elseif panel == 'icon5'     and layout  == "PAPERDOLL"    then height = Config.get("ICONWIDTH");
    elseif panel == 'icon6'     and layout  == "PAPERDOLL"    then height = Config.get("ICONWIDTH");

    elseif panel == 'name'          and layout == "PAPERDOLL" then width = Config.get("PORTWIDTH") * 1.5 - hgap(2) ;

    elseif panel == 'info'          and layout == "PAPERDOLL" then width = Config.get("PORTWIDTH") * 1.5 - hgap(2);

    elseif panel == 'portrait'   and layout  == "PAPERDOLL"  then width = Config.get("PORTWIDTH") * 1.5;
    elseif panel == 'details'                                then width = Config.get("INFOWIDTH");
    elseif panel == 'icon1'      and layout  == "PAPERDOLL"  then width = Config.get("ICONWIDTH");
    elseif panel == 'icon2'      and layout  == "PAPERDOLL"  then width = Config.get("ICONWIDTH");
    elseif panel == 'icon3'      and layout  == "PAPERDOLL"  then width = Config.get("ICONWIDTH");
    elseif panel == 'icon4'      and layout  == "PAPERDOLL"  then width = Config.get("ICONWIDTH");
    elseif panel == 'icon5'      and layout  == "PAPERDOLL"  then width = Config.get("ICONWIDTH");
    elseif panel == 'icon6'      and layout  == "PAPERDOLL"  then width = Config.get("ICONWIDTH");

  local function getFrameSize(layout)
    local border, width, height;


    elseif layout == "PAPERDOLL" -- -------------------------------------------------------------------------------------------------------------
    then   width  =  border
                     -- + hgap(1) + getPanelWidth('icon1', layout)
                     + getPanelWidth('portrait', layout)
                     -- + hgap(1) + getPanelWidth('icon4', layout)
                     + border;
           height =  math.max(
                     -- formula #1
                     border
                     + hgap(1) + getPanelHeight('name', layout)
                     + hgap(1) + getPanelHeight('info', layout)
                     + hgap(1) + getPanelHeight('portrait', layout)
                     + border, -- no gap needed here
                     -- formula #2
                     border
                     + hgap(1) + getPanelHeight('name', layout)
                     + hgap(1) + getPanelHeight('info', layout)
                     + hgap(2) + getPanelHeight('icon1', layout)
                     + hgap(2) + getPanelHeight('icon2', layout)
                     + hgap(2) + getPanelHeight('icon3', layout)
                     + hgap(1) + border
                    );

