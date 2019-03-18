# remap Caps_Lock and Control to Escape when pressed independently
killall xcape
xcape -e 'Caps_Lock=Escape;Control_L=Escape;Control_R=Escape'
