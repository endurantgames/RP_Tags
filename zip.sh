#!/bin/sh

/usr/bin/zip -u RP_Tags.zip \
    -r RP_Tags/  \
       RP_Tags_ElvUI/  \
       RP_Tags_MyRolePlay/  \
       RP_Tags_totalRP3/  \
       RP_UnitFrames/  \
       RP_Tags_Listener/  \
    -x \*old\*  \
    -x \*\.git\*

